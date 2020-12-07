self.importScripts('wasm_exec.js');

let loaded = false;
load = () => {
    const go = new Go();
    let mod, inst;
    return WebAssembly.instantiateStreaming(fetch("openpgp.wasm"), go.importObject).then(async result => {
        mod = result.module;
        inst = result.instance;
        loaded = true;
        const run = async () => {
            try {
                await go.run(inst);
            } catch (e) {
                console.warn(e);
                loaded = false;
                await load();
            }
        };
        run();
    });
};

onmessage = async ({ data }) => {
    if (!loaded) {
        await load();
    }

    const { request, name, id } = data;
    openPGPBridgeCall(name, request, request.length, (error, response) => {
        const payload = {
            id,
            response,
            error
        };
        postMessage(payload);
    });
};