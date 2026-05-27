//go:build !js

package main

/*
#include <stdlib.h>
#include <string.h>

typedef struct {
	void* message;
	int   size;
	char* error;
} BytesReturn;
*/
import "C"
import (
	"unsafe"

	"github.com/jerson/openpgp-mobile/bridge"
)

//export OpenPGPBridgeCall
func OpenPGPBridgeCall(name *C.char, payload unsafe.Pointer, payloadSize C.int) *C.BytesReturn {
	result, err := bridge.Call(
		C.GoString(name),
		C.GoBytes(payload, payloadSize),
	)
	ret := (*C.BytesReturn)(C.malloc(C.sizeof_BytesReturn))
	if err != nil {
		ret.error = C.CString(err.Error())
		ret.message = nil
		ret.size = 0
		return ret
	}
	if len(result) == 0 {
		ret.message = nil
		ret.size = 0
		ret.error = nil
		return ret
	}
	ret.message = C.CBytes(result)
	ret.size = C.int(len(result))
	ret.error = nil
	return ret
}

//export OpenPGPEncodeText
func OpenPGPEncodeText(input *C.char, encoding *C.char) *C.BytesReturn {
	result, err := bridge.EncodeText(C.GoString(input), C.GoString(encoding))
	ret := (*C.BytesReturn)(C.malloc(C.sizeof_BytesReturn))
	if err != nil {
		ret.error = C.CString(err.Error())
		ret.message = nil
		ret.size = 0
		return ret
	}
	ret.message = C.CBytes(result)
	ret.size = C.int(len(result))
	ret.error = nil
	return ret
}

//export OpenPGPDecodeText
func OpenPGPDecodeText(input unsafe.Pointer, size C.int, encoding *C.char, fatal C.int, ignoreBOM C.int, stream C.int) *C.char {
	return C.CString(bridge.DecodeText(
		C.GoBytes(input, size),
		C.GoString(encoding),
		fatal != 0,
		ignoreBOM != 0,
		stream != 0,
	))
}

// OpenPGPFreeResult frees a BytesReturn struct and its inner fields using the
// same allocator (C.malloc / C.free) used when the struct was created. Calling
// this from Dart avoids cross-allocator mismatches on Windows where Dart's
// package:ffi malloc and Go's CGo malloc may come from different C runtimes.
//
//export OpenPGPFreeResult
func OpenPGPFreeResult(ptr *C.BytesReturn) {
	if ptr == nil {
		return
	}
	if ptr.message != nil {
		C.free(ptr.message)
	}
	if ptr.error != nil {
		C.free(unsafe.Pointer(ptr.error))
	}
	C.free(unsafe.Pointer(ptr))
}

func main() {}
