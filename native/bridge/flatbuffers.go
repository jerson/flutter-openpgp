package bridge

import (
	flatbuffers "github.com/google/flatbuffers/go"
)

// ── Reading helpers ──────────────────────────────────────────────────────────

// rootTable initialises a Table from a FlatBuffers byte slice.
func rootTable(buf []byte) flatbuffers.Table {
	n := flatbuffers.GetUOffsetT(buf)
	return flatbuffers.Table{Bytes: buf, Pos: n}
}

// fbString reads a string at the given vtable offset, returning "" when absent.
func fbString(t *flatbuffers.Table, vtOff flatbuffers.VOffsetT) string {
	if off := t.Offset(vtOff); off != 0 {
		return t.String(t.Pos + flatbuffers.UOffsetT(off))
	}
	return ""
}

// fbBytes reads a byte-vector at the given vtable offset.
func fbBytes(t *flatbuffers.Table, vtOff flatbuffers.VOffsetT) []byte {
	if off := t.Offset(vtOff); off != 0 {
		return t.ByteVector(t.Pos + flatbuffers.UOffsetT(off))
	}
	return nil
}

// fbInt32 reads an int32 scalar.
func fbInt32(t *flatbuffers.Table, vtOff flatbuffers.VOffsetT) int32 {
	return t.GetInt32Slot(vtOff, 0)
}

// fbBool reads a bool scalar.
func fbBool(t *flatbuffers.Table, vtOff flatbuffers.VOffsetT) bool {
	return t.GetBoolSlot(vtOff, false)
}

// fbTable reads a nested table.  Returns nil when the field is absent.
func fbTable(t *flatbuffers.Table, vtOff flatbuffers.VOffsetT) *flatbuffers.Table {
	if off := t.Offset(vtOff); off != 0 {
		return &flatbuffers.Table{
			Bytes: t.Bytes,
			Pos:   t.Indirect(t.Pos + flatbuffers.UOffsetT(off)),
		}
	}
	return nil
}

// fbTableVector reads a vector of nested tables.
// off is the raw VOffsetT from t.Offset(); pass the vtable slot value directly.
func fbTableVector(t *flatbuffers.Table, vtOff flatbuffers.VOffsetT) []*flatbuffers.Table {
	off := t.Offset(vtOff)
	if off == 0 {
		return nil
	}
	// Vector/VectorLen take offset relative to t.Pos (they add t.Pos internally)
	relOff := flatbuffers.UOffsetT(off)
	vecLen := t.VectorLen(relOff)
	vecOff := t.Vector(relOff)
	out := make([]*flatbuffers.Table, vecLen)
	for i := 0; i < vecLen; i++ {
		elemOff := t.Indirect(vecOff + flatbuffers.UOffsetT(i*flatbuffers.SizeUOffsetT))
		out[i] = &flatbuffers.Table{Bytes: t.Bytes, Pos: elemOff}
	}
	return out
}

// ── Writing helpers ──────────────────────────────────────────────────────────

// strOffset writes a string into the builder and returns the offset.
// Returns 0 when s is empty so callers can skip the slot.
func strOffset(b *flatbuffers.Builder, s string) flatbuffers.UOffsetT {
	if s == "" {
		return 0
	}
	return b.CreateString(s)
}

// bytesOffset writes a byte slice.  Returns 0 for nil/empty.
func bytesOffset(b *flatbuffers.Builder, data []byte) flatbuffers.UOffsetT {
	if len(data) == 0 {
		return 0
	}
	return b.CreateByteVector(data)
}

// prepStr is a convenience for PrependUOffsetTSlot for a string field.
func prepStr(b *flatbuffers.Builder, fieldIdx int, off flatbuffers.UOffsetT) {
	b.PrependUOffsetTSlot(fieldIdx, off, 0)
}

// ── Response builders ────────────────────────────────────────────────────────

// stringResponse serialises { output: string, error: string }.
func stringResponse(output, errMsg string) []byte {
	b := flatbuffers.NewBuilder(256)
	outOff := strOffset(b, output)
	errOff := strOffset(b, errMsg)
	b.StartObject(2)
	prepStr(b, 0, outOff)
	prepStr(b, 1, errOff)
	tbl := b.EndObject()
	b.Finish(tbl)
	return b.FinishedBytes()
}

// bytesResponse serialises { output: [byte], error: string }.
func bytesResponse(output []byte, errMsg string) []byte {
	b := flatbuffers.NewBuilder(256 + len(output))
	outOff := bytesOffset(b, output)
	errOff := strOffset(b, errMsg)
	b.StartObject(2)
	b.PrependUOffsetTSlot(0, outOff, 0)
	prepStr(b, 1, errOff)
	tbl := b.EndObject()
	b.Finish(tbl)
	return b.FinishedBytes()
}

// boolResponse serialises { output: bool, error: string }.
func boolResponse(output bool, errMsg string) []byte {
	b := flatbuffers.NewBuilder(64)
	errOff := strOffset(b, errMsg)
	b.StartObject(2)
	b.PrependBoolSlot(0, output, false)
	prepStr(b, 1, errOff)
	tbl := b.EndObject()
	b.Finish(tbl)
	return b.FinishedBytes()
}

// keyPairResponse serialises { output: KeyPair, error: string }.
//
//	KeyPair = { publicKey: string, privateKey: string }
func keyPairResponse(publicKey, privateKey, errMsg string) []byte {
	b := flatbuffers.NewBuilder(512)
	pubOff := strOffset(b, publicKey)
	privOff := strOffset(b, privateKey)
	errOff := strOffset(b, errMsg)

	b.StartObject(2)
	prepStr(b, 0, pubOff)
	prepStr(b, 1, privOff)
	kpOff := b.EndObject()

	b.StartObject(2)
	b.PrependUOffsetTSlot(0, kpOff, 0)
	prepStr(b, 1, errOff)
	tbl := b.EndObject()
	b.Finish(tbl)
	return b.FinishedBytes()
}

// armorDecodeResponse serialises { output: ArmorMetadata, error: string }.
//
//	ArmorMetadata = { body: [byte], type: string }
func armorDecodeResponse(body []byte, armorType, errMsg string) []byte {
	b := flatbuffers.NewBuilder(256 + len(body))
	bodyOff := bytesOffset(b, body)
	typeOff := strOffset(b, armorType)
	errOff := strOffset(b, errMsg)

	b.StartObject(2)
	b.PrependUOffsetTSlot(0, bodyOff, 0)
	prepStr(b, 1, typeOff)
	metaOff := b.EndObject()

	b.StartObject(2)
	b.PrependUOffsetTSlot(0, metaOff, 0)
	prepStr(b, 1, errOff)
	tbl := b.EndObject()
	b.Finish(tbl)
	return b.FinishedBytes()
}

// identityOffset creates an Identity table inside the builder.
//
//	Identity = { id, comment, email, name } at vTable offsets 4,6,8,10
func identityOffset(b *flatbuffers.Builder, id, comment, email, name string) flatbuffers.UOffsetT {
	idOff := strOffset(b, id)
	commentOff := strOffset(b, comment)
	emailOff := strOffset(b, email)
	nameOff := strOffset(b, name)
	b.StartObject(4)
	prepStr(b, 0, idOff)
	prepStr(b, 1, commentOff)
	prepStr(b, 2, emailOff)
	prepStr(b, 3, nameOff)
	return b.EndObject()
}

// publicKeyMetadataResponse serialises PublicKeyMetadataResponse.
func publicKeyMetadataResponse(
	algorithm, keyID, keyIDShort, creationTime, fingerprint, keyIDNumeric string,
	isSubKey, canSign, canEncrypt bool,
	identities []identityData,
	errMsg string,
) []byte {
	b := flatbuffers.NewBuilder(512)

	algOff := strOffset(b, algorithm)
	kidOff := strOffset(b, keyID)
	kidSOff := strOffset(b, keyIDShort)
	ctOff := strOffset(b, creationTime)
	fpOff := strOffset(b, fingerprint)
	kidNOff := strOffset(b, keyIDNumeric)
	errOff := strOffset(b, errMsg)

	idOffsets := make([]flatbuffers.UOffsetT, len(identities))
	for i, id := range identities {
		idOffsets[i] = identityOffset(b, id.id, id.comment, id.email, id.name)
	}
	var idVecOff flatbuffers.UOffsetT
	if len(idOffsets) > 0 {
		b.StartVector(flatbuffers.SizeUOffsetT, len(idOffsets), flatbuffers.SizeUOffsetT)
		for i := len(idOffsets) - 1; i >= 0; i-- {
			b.PrependUOffsetT(idOffsets[i])
		}
		idVecOff = b.EndVector(len(idOffsets))
	}

	b.StartObject(11)
	prepStr(b, 0, algOff)
	prepStr(b, 1, kidOff)
	prepStr(b, 2, kidSOff)
	prepStr(b, 3, ctOff)
	prepStr(b, 4, fpOff)
	prepStr(b, 5, kidNOff)
	b.PrependBoolSlot(6, isSubKey, false)
	b.PrependBoolSlot(7, canSign, false)
	b.PrependBoolSlot(8, canEncrypt, false)
	if idVecOff != 0 {
		b.PrependUOffsetTSlot(9, idVecOff, 0)
	}
	metaOff := b.EndObject()

	b.StartObject(2)
	b.PrependUOffsetTSlot(0, metaOff, 0)
	prepStr(b, 1, errOff)
	tbl := b.EndObject()
	b.Finish(tbl)
	return b.FinishedBytes()
}

// privateKeyMetadataResponse serialises PrivateKeyMetadataResponse.
func privateKeyMetadataResponse(
	keyID, keyIDShort, creationTime, fingerprint, keyIDNumeric string,
	isSubKey, encrypted, canSign bool,
	identities []identityData,
	errMsg string,
) []byte {
	b := flatbuffers.NewBuilder(512)

	kidOff := strOffset(b, keyID)
	kidSOff := strOffset(b, keyIDShort)
	ctOff := strOffset(b, creationTime)
	fpOff := strOffset(b, fingerprint)
	kidNOff := strOffset(b, keyIDNumeric)
	errOff := strOffset(b, errMsg)

	idOffsets := make([]flatbuffers.UOffsetT, len(identities))
	for i, id := range identities {
		idOffsets[i] = identityOffset(b, id.id, id.comment, id.email, id.name)
	}
	var idVecOff flatbuffers.UOffsetT
	if len(idOffsets) > 0 {
		b.StartVector(flatbuffers.SizeUOffsetT, len(idOffsets), flatbuffers.SizeUOffsetT)
		for i := len(idOffsets) - 1; i >= 0; i-- {
			b.PrependUOffsetT(idOffsets[i])
		}
		idVecOff = b.EndVector(len(idOffsets))
	}

	b.StartObject(10)
	prepStr(b, 0, kidOff)
	prepStr(b, 1, kidSOff)
	prepStr(b, 2, ctOff)
	prepStr(b, 3, fpOff)
	prepStr(b, 4, kidNOff)
	b.PrependBoolSlot(5, isSubKey, false)
	b.PrependBoolSlot(6, encrypted, false)
	b.PrependBoolSlot(7, canSign, false)
	if idVecOff != 0 {
		b.PrependUOffsetTSlot(8, idVecOff, 0)
	}
	metaOff := b.EndObject()

	b.StartObject(2)
	b.PrependUOffsetTSlot(0, metaOff, 0)
	prepStr(b, 1, errOff)
	tbl := b.EndObject()
	b.Finish(tbl)
	return b.FinishedBytes()
}

// identityData is a plain-Go holder used when building responses.
type identityData struct {
	id, comment, email, name string
}

// errStringResponse is a shortcut for returning only an error.
func errStringResponse(err error) []byte  { return stringResponse("", err.Error()) }
func errBytesResponse(err error) []byte   { return bytesResponse(nil, err.Error()) }
func errBoolResponse(err error) []byte    { return boolResponse(false, err.Error()) }
func errKeyPairResponse(err error) []byte { return keyPairResponse("", "", err.Error()) }
