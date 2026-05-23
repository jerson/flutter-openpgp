//go:build js && wasm

package main

import (
	"syscall/js"

	"github.com/jerson/openpgp-mobile/bridge"
)

func main() {
	js.Global().Set("openPGPBridgeCall", js.FuncOf(openPGPBridgeCall))
	// Block forever so the WASM module stays alive while the worker runs.
	select {}
}

// openPGPBridgeCall matches the JS call in worker.js:
//
//	openPGPBridgeCall(name, request, request.length, (error, response) => { … })
func openPGPBridgeCall(_ js.Value, args []js.Value) any {
	name := args[0].String()
	jsArr := args[1]
	length := args[2].Int()
	callback := args[3]

	payload := make([]byte, length)
	js.CopyBytesToGo(payload, jsArr)

	result, err := bridge.Call(name, payload)
	if err != nil {
		callback.Invoke(err.Error(), js.Null())
		return nil
	}

	jsResult := js.Global().Get("Uint8Array").New(len(result))
	js.CopyBytesToJS(jsResult, result)
	callback.Invoke(js.Null(), jsResult)
	return nil
}
