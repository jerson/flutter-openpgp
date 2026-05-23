self.importScripts("wasm_exec.js");

self.loaded = false;
self.library = "openpgp.wasm";

// Tracks in-flight requests so we can reject them on worker error.
const pending = new Map();

// Exponential-backoff reload: cap at 30 s, give up after 5 attempts.
let _reloadAttempts = 0;
const _maxReloadAttempts = 5;

function scheduleReload(loadFn) {
  if (_reloadAttempts >= _maxReloadAttempts) {
    console.error("openpgp worker: WASM failed to load after max retries");
    // Reject every pending request so callers don't hang forever.
    for (const [id, reject] of pending) {
      reject("WASM failed to load");
    }
    pending.clear();
    return;
  }
  const delay = Math.min(1000 * Math.pow(2, _reloadAttempts), 30000);
  _reloadAttempts++;
  setTimeout(loadFn, delay);
}

load = () => {
  if (!WebAssembly.hasOwnProperty('instantiateStreaming')) {
    return loadFallback();
  }

  const go = new Go();
  return WebAssembly.instantiateStreaming(
    fetch(self.library),
    go.importObject
  ).then(async (result) => {
    _reloadAttempts = 0;
    const run = async () => {
      try {
        self.loaded = true;
        await go.run(result.instance);
        // go.run() resolves when the WASM program exits cleanly — reload it.
        self.loaded = false;
        scheduleReload(load);
      } catch (e) {
        console.warn("openpgp worker: WASM runtime error", e);
        self.loaded = false;
        scheduleReload(load);
      }
    };
    run();
  }).catch((e) => {
    console.warn("openpgp worker: WASM instantiation error", e);
    scheduleReload(load);
  });
};

loadFallback = () => {
  const go = new Go();
  return fetch(self.library)
    .then(r => r.arrayBuffer())
    .then(bytes => WebAssembly.instantiate(bytes, go.importObject))
    .then(async (result) => {
      _reloadAttempts = 0;
      const run = async () => {
        try {
          self.loaded = true;
          await go.run(result.instance);
          self.loaded = false;
          scheduleReload(loadFallback);
        } catch (e) {
          console.warn("openpgp worker: WASM runtime error (fallback)", e);
          self.loaded = false;
          scheduleReload(loadFallback);
        }
      };
      run();
    }).catch((e) => {
      console.warn("openpgp worker: WASM fetch error (fallback)", e);
      scheduleReload(loadFallback);
    });
};

onmessage = async ({ data }) => {
  const { request, name, id } = data;

  if (!self.loaded) {
    await load();
  }

  try {
    openPGPBridgeCall(name, request, request.length, (error, response) => {
      pending.delete(id);
      postMessage({ id, response, error });
    });
  } catch (e) {
    self.loaded = false;
    pending.delete(id);
    postMessage({ id, response: null, error: e.message });
  }
};
