package bridge

import (
	"bytes"
	"crypto"
	"encoding/hex"
	"fmt"
	"io"
	"strconv"
	"strings"
	"time"

	"github.com/ProtonMail/go-crypto/openpgp"
	"github.com/ProtonMail/go-crypto/openpgp/armor"
	"github.com/ProtonMail/go-crypto/openpgp/clearsign"
	"github.com/ProtonMail/go-crypto/openpgp/packet"
	flatbuffers "github.com/google/flatbuffers/go"
	"golang.org/x/text/encoding/ianaindex"
	"golang.org/x/text/transform"
)

// ── Dispatcher ───────────────────────────────────────────────────────────────

// Call dispatches an operation by name with a FlatBuffers-encoded payload.
func Call(name string, payload []byte) ([]byte, error) {
	switch name {
	case "generate":
		return callGenerate(payload)
	case "encrypt":
		return callEncrypt(payload)
	case "encryptBytes":
		return callEncryptBytes(payload)
	case "decrypt":
		return callDecrypt(payload)
	case "decryptBytes":
		return callDecryptBytes(payload)
	case "sign":
		return callSign(payload)
	case "signBytes":
		return callSignBytes(payload)
	case "signBytesToString":
		return callSignBytesToString(payload)
	case "signData":
		return callSignData(payload)
	case "signDataBytes":
		return callSignDataBytes(payload)
	case "signDataBytesToString":
		return callSignDataBytesToString(payload)
	case "verify":
		return callVerify(payload)
	case "verifyBytes":
		return callVerifyBytes(payload)
	case "verifyData":
		return callVerifyData(payload)
	case "verifyDataBytes":
		return callVerifyDataBytes(payload)
	case "encryptSymmetric":
		return callEncryptSymmetric(payload)
	case "encryptSymmetricBytes":
		return callEncryptSymmetricBytes(payload)
	case "decryptSymmetric":
		return callDecryptSymmetric(payload)
	case "decryptSymmetricBytes":
		return callDecryptSymmetricBytes(payload)
	case "armorEncode":
		return callArmorEncode(payload)
	case "armorDecode":
		return callArmorDecode(payload)
	case "convertPrivateKeyToPublicKey":
		return callConvertPrivateKeyToPublicKey(payload)
	case "getPublicKeyMetadata":
		return callGetPublicKeyMetadata(payload)
	case "getPrivateKeyMetadata":
		return callGetPrivateKeyMetadata(payload)
	default:
		return errStringResponse(fmt.Errorf("unknown operation: %s", name)), nil
	}
}

// ── Text encoding helpers (used by main.go exports) ──────────────────────────

// EncodeText converts a Go string to the named charset and returns the bytes.
func EncodeText(input, encoding string) ([]byte, error) {
	enc, err := ianaindex.IANA.Encoding(encoding)
	if err != nil || enc == nil {
		return []byte(input), nil
	}
	out, _, err := transform.Bytes(enc.NewEncoder(), []byte(input))
	if err != nil {
		return nil, err
	}
	return out, nil
}

// DecodeText converts bytes in the named charset to a UTF-8 Go string.
func DecodeText(input []byte, encoding string, fatal, ignoreBOM, _ bool) string {
	enc, err := ianaindex.IANA.Encoding(encoding)
	if err != nil || enc == nil {
		return string(input)
	}
	out, _, err := transform.Bytes(enc.NewDecoder(), input)
	if err != nil {
		return string(input)
	}
	return string(out)
}

// ── FlatBuffers request parsers ───────────────────────────────────────────────

type keyOptions struct {
	algorithm        int32
	curve            int32
	hash             int32
	cipher           int32
	compression      int32
	compressionLevel int32
	rsaBits          int32
	keyLifetimeSecs  int32
}

type options struct {
	name       string
	comment    string
	email      string
	passphrase string
	keyOptions *keyOptions
}

type entityFields struct {
	publicKey  string
	privateKey string
	passphrase string
}

type fileHints struct {
	isBinary bool
	fileName string
	modTime  string
}

func parseKeyOptions(t *flatbuffers.Table) *keyOptions {
	if t == nil {
		return nil
	}
	return &keyOptions{
		algorithm:        fbInt32(t, 4),
		curve:            fbInt32(t, 6),
		hash:             fbInt32(t, 8),
		cipher:           fbInt32(t, 10),
		compression:      fbInt32(t, 12),
		compressionLevel: fbInt32(t, 14),
		rsaBits:          fbInt32(t, 16),
		keyLifetimeSecs:  fbInt32(t, 18),
	}
}

func parseOptions(t *flatbuffers.Table) *options {
	if t == nil {
		return nil
	}
	return &options{
		name:       fbString(t, 4),
		comment:    fbString(t, 6),
		email:      fbString(t, 8),
		passphrase: fbString(t, 10),
		keyOptions: parseKeyOptions(fbTable(t, 12)),
	}
}

func parseEntity(t *flatbuffers.Table) *entityFields {
	if t == nil {
		return nil
	}
	return &entityFields{
		publicKey:  fbString(t, 4),
		privateKey: fbString(t, 6),
		passphrase: fbString(t, 8),
	}
}

func parseFileHints(t *flatbuffers.Table) *fileHints {
	if t == nil {
		return nil
	}
	return &fileHints{
		isBinary: fbBool(t, 4),
		fileName: fbString(t, 6),
		modTime:  fbString(t, 8),
	}
}

// ── Config builders ───────────────────────────────────────────────────────────

func buildConfig(ko *keyOptions) *packet.Config {
	if ko == nil {
		return nil
	}
	cfg := &packet.Config{}
	cfg.DefaultHash = mapHash(ko.hash)

	switch ko.cipher {
	case 1:
		cfg.DefaultCipher = packet.CipherAES192
	case 2:
		cfg.DefaultCipher = packet.CipherAES256
	case 3:
		cfg.DefaultCipher = packet.Cipher3DES
	case 4:
		cfg.DefaultCipher = packet.CipherCAST5
	default:
		cfg.DefaultCipher = packet.CipherAES128
	}

	if ko.compression > 0 {
		level := int(ko.compressionLevel)
		if level == 0 {
			level = -1
		}
		cfg.CompressionConfig = &packet.CompressionConfig{Level: level}
	}

	if ko.rsaBits > 0 {
		if ko.rsaBits < 2048 {
			ko.rsaBits = 2048
		}
		cfg.RSABits = int(ko.rsaBits)
	}

	if ko.keyLifetimeSecs > 0 {
		cfg.KeyLifetimeSecs = uint32(ko.keyLifetimeSecs)
	}

	switch ko.algorithm {
	case AlgoECDSA, AlgoEdDSA, AlgoECDH:
		cfg.Curve = mapCurve(ko.curve)
	}

	return cfg
}

func mapCurve(c int32) packet.Curve {
	switch c {
	case 1:
		return packet.Curve448
	case 2:
		return packet.CurveNistP256
	case 3:
		return packet.CurveNistP384
	case 4:
		return packet.CurveNistP521
	default:
		return packet.Curve25519
	}
}

func mapPubKeyAlgo(algo int32) packet.PublicKeyAlgorithm {
	switch algo {
	case AlgoECDSA:
		return packet.PubKeyAlgoECDSA
	case AlgoEdDSA:
		return packet.PubKeyAlgoEdDSA
	case AlgoECDH:
		return packet.PubKeyAlgoECDH
	case AlgoDSA:
		return packet.PubKeyAlgoDSA
	case AlgoElGamal:
		return packet.PubKeyAlgoElGamal
	default:
		return packet.PubKeyAlgoRSA
	}
}

// ── OpenPGP helpers ───────────────────────────────────────────────────────────

func readArmoredKey(armoredKey string) (openpgp.EntityList, error) {
	reader := strings.NewReader(armoredKey)
	var all openpgp.EntityList
	for {
		block, err := armor.Decode(reader)
		if err == io.EOF || block == nil {
			break
		}
		if err != nil {
			break
		}
		entities, err := openpgp.ReadKeyRing(block.Body)
		if err != nil {
			continue
		}
		all = append(all, entities...)
	}
	if len(all) == 0 {
		return nil, fmt.Errorf("no armored keys found")
	}
	return all, nil
}

func readAndUnlockPrivateKey(armoredKey, passphrase string) (*openpgp.Entity, error) {
	entities, err := readArmoredKey(armoredKey)
	if err != nil {
		return nil, fmt.Errorf("reading private key: %w", err)
	}
	if len(entities) == 0 {
		return nil, fmt.Errorf("no keys found")
	}
	entity := entities[0]
	if passphrase != "" {
		if entity.PrivateKey != nil && entity.PrivateKey.Encrypted {
			if err = entity.PrivateKey.Decrypt([]byte(passphrase)); err != nil {
				return nil, fmt.Errorf("decrypting primary key: %w", err)
			}
		}
		for _, sub := range entity.Subkeys {
			if sub.PrivateKey != nil && sub.PrivateKey.Encrypted {
				if err = sub.PrivateKey.Decrypt([]byte(passphrase)); err != nil {
					return nil, fmt.Errorf("decrypting subkey: %w", err)
				}
			}
		}
	}
	return entity, nil
}

func serializePublicKey(entity *openpgp.Entity) (string, error) {
	var buf bytes.Buffer
	w, err := armor.Encode(&buf, "PGP PUBLIC KEY BLOCK", nil)
	if err != nil {
		return "", err
	}
	if err = entity.Serialize(w); err != nil {
		return "", err
	}
	w.Close()
	return buf.String(), nil
}

func serializePrivateKey(entity *openpgp.Entity) (string, error) {
	var buf bytes.Buffer
	w, err := armor.Encode(&buf, "PGP PRIVATE KEY BLOCK", nil)
	if err != nil {
		return "", err
	}
	if err = entity.SerializePrivate(w, nil); err != nil {
		return "", err
	}
	w.Close()
	return buf.String(), nil
}

func pgpFileHints(fh *fileHints) *openpgp.FileHints {
	if fh == nil {
		return nil
	}
	hints := &openpgp.FileHints{
		IsBinary: fh.isBinary,
		FileName: fh.fileName,
	}
	if fh.modTime != "" {
		t, err := time.Parse(time.RFC3339, fh.modTime)
		if err == nil {
			hints.ModTime = t
		}
	}
	return hints
}

func keyIDHex(id uint64) string {
	return fmt.Sprintf("%016X", id)
}

func keyIDShortHex(id uint64) string {
	return fmt.Sprintf("%08X", id&0xFFFFFFFF)
}

func fingerprintHex(fp []byte) string {
	return strings.ToUpper(hex.EncodeToString(fp))
}

func algoName(algo packet.PublicKeyAlgorithm) string {
	switch algo {
	case packet.PubKeyAlgoRSA, packet.PubKeyAlgoRSAEncryptOnly, packet.PubKeyAlgoRSASignOnly:
		return "RSA"
	case packet.PubKeyAlgoDSA:
		return "DSA"
	case packet.PubKeyAlgoElGamal:
		return "ElGamal"
	case packet.PubKeyAlgoECDH:
		return "ECDH"
	case packet.PubKeyAlgoECDSA:
		return "ECDSA"
	case packet.PubKeyAlgoEdDSA:
		return "EdDSA"
	case packet.PubKeyAlgoEd25519:
		return "Ed25519"
	case packet.PubKeyAlgoEd448:
		return "Ed448"
	case packet.PubKeyAlgoX25519:
		return "X25519"
	case packet.PubKeyAlgoX448:
		return "X448"
	case packet.PubKeyAlgoMldsa65Ed25519:
		return "ML-DSA-65+Ed25519"
	case packet.PubKeyAlgoMldsa87Ed448:
		return "ML-DSA-87+Ed448"
	case packet.PubKeyAlgoMlkem768X25519:
		return "ML-KEM-768+X25519"
	case packet.PubKeyAlgoMlkem1024X448:
		return "ML-KEM-1024+X448"
	default:
		return strconv.Itoa(int(algo))
	}
}

func collectIdentities(entity *openpgp.Entity) []identityData {
	ids := make([]identityData, 0, len(entity.Identities))
	for uid, id := range entity.Identities {
		ids = append(ids, identityData{
			id:      uid,
			name:    id.UserId.Name,
			comment: id.UserId.Comment,
			email:   id.UserId.Email,
		})
	}
	return ids
}

// ── Operations ────────────────────────────────────────────────────────────────

func callGenerate(payload []byte) ([]byte, error) {
	t := rootTable(payload)
	optsTbl := fbTable(&t, 4)
	opts := parseOptions(optsTbl)

	name, comment, email, passphrase := "", "", "", ""
	var ko *keyOptions
	if opts != nil {
		name = opts.name
		comment = opts.comment
		email = opts.email
		passphrase = opts.passphrase
		ko = opts.keyOptions
	}

	var entity *openpgp.Entity
	var err error

	algo := int32(0)
	if ko != nil {
		algo = ko.algorithm
	}

	if isPQCAlgorithm(algo) {
		hash := crypto.SHA256
		if ko != nil {
			hash = mapHash(ko.hash)
		}
		entity, err = GeneratePQCKeyPair(name, comment, email, passphrase, algo, hash)
	} else {
		cfg := &packet.Config{}
		if ko != nil {
			cfg = buildConfig(ko)
			cfg.Algorithm = mapPubKeyAlgo(algo)
		}
		entity, err = openpgp.NewEntity(name, comment, email, cfg)
		if err == nil && passphrase != "" {
			if encErr := entity.PrivateKey.Encrypt([]byte(passphrase)); encErr != nil {
				err = encErr
			}
			for _, sub := range entity.Subkeys {
				if sub.PrivateKey != nil {
					sub.PrivateKey.Encrypt([]byte(passphrase))
				}
			}
		}
	}
	if err != nil {
		return errKeyPairResponse(err), nil
	}

	pub, err := serializePublicKey(entity)
	if err != nil {
		return errKeyPairResponse(err), nil
	}
	priv, err := serializePrivateKey(entity)
	if err != nil {
		return errKeyPairResponse(err), nil
	}
	return keyPairResponse(pub, priv, ""), nil
}

func callEncrypt(payload []byte) ([]byte, error) {
	t := rootTable(payload)
	message := fbString(&t, 4)
	publicKey := fbString(&t, 6)
	ko := parseKeyOptions(fbTable(&t, 8))
	signed := parseEntity(fbTable(&t, 10))
	fh := parseFileHints(fbTable(&t, 12))

	recipients, err := readArmoredKey(publicKey)
	if err != nil {
		return errStringResponse(err), nil
	}

	var signer *openpgp.Entity
	if signed != nil && signed.privateKey != "" {
		signer, err = readAndUnlockPrivateKey(signed.privateKey, signed.passphrase)
		if err != nil {
			return errStringResponse(err), nil
		}
	}

	var buf bytes.Buffer
	armorWriter, err := armor.Encode(&buf, "PGP MESSAGE", nil)
	if err != nil {
		return errStringResponse(err), nil
	}
	cfg := buildConfig(ko)
	w, err := openpgp.Encrypt(armorWriter, recipients, signer, pgpFileHints(fh), cfg)
	if err != nil {
		return errStringResponse(err), nil
	}
	if _, err = io.WriteString(w, message); err != nil {
		return errStringResponse(err), nil
	}
	w.Close()
	armorWriter.Close()
	return stringResponse(buf.String(), ""), nil
}

func callEncryptBytes(payload []byte) ([]byte, error) {
	t := rootTable(payload)
	message := fbBytes(&t, 4)
	publicKey := fbString(&t, 6)
	ko := parseKeyOptions(fbTable(&t, 8))
	signed := parseEntity(fbTable(&t, 10))
	fh := parseFileHints(fbTable(&t, 12))

	recipients, err := readArmoredKey(publicKey)
	if err != nil {
		return errBytesResponse(err), nil
	}

	var signer *openpgp.Entity
	if signed != nil && signed.privateKey != "" {
		signer, err = readAndUnlockPrivateKey(signed.privateKey, signed.passphrase)
		if err != nil {
			return errBytesResponse(err), nil
		}
	}

	var buf bytes.Buffer
	cfg := buildConfig(ko)
	w, err := openpgp.Encrypt(&buf, recipients, signer, pgpFileHints(fh), cfg)
	if err != nil {
		return errBytesResponse(err), nil
	}
	if _, err = w.Write(message); err != nil {
		return errBytesResponse(err), nil
	}
	w.Close()
	return bytesResponse(buf.Bytes(), ""), nil
}

func callDecrypt(payload []byte) ([]byte, error) {
	t := rootTable(payload)
	message := fbString(&t, 4)
	privateKey := fbString(&t, 6)
	passphrase := fbString(&t, 8)
	// options at 10, signed at 12 – not used for decryption output type

	entity, err := readAndUnlockPrivateKey(privateKey, passphrase)
	if err != nil {
		return errStringResponse(err), nil
	}

	block, err := armor.Decode(strings.NewReader(message))
	if err != nil {
		return errStringResponse(err), nil
	}
	md, err := openpgp.ReadMessage(block.Body, openpgp.EntityList{entity}, nil, nil)
	if err != nil {
		return errStringResponse(err), nil
	}
	plain, err := io.ReadAll(md.UnverifiedBody)
	if err != nil {
		return errStringResponse(err), nil
	}
	return stringResponse(string(plain), ""), nil
}

func callDecryptBytes(payload []byte) ([]byte, error) {
	t := rootTable(payload)
	message := fbBytes(&t, 4)
	privateKey := fbString(&t, 6)
	passphrase := fbString(&t, 8)

	entity, err := readAndUnlockPrivateKey(privateKey, passphrase)
	if err != nil {
		return errBytesResponse(err), nil
	}

	md, err := openpgp.ReadMessage(bytes.NewReader(message), openpgp.EntityList{entity}, nil, nil)
	if err != nil {
		return errBytesResponse(err), nil
	}
	plain, err := io.ReadAll(md.UnverifiedBody)
	if err != nil {
		return errBytesResponse(err), nil
	}
	return bytesResponse(plain, ""), nil
}

// sign creates a detached armored signature (string output).
// verify(signature, message, publicKey) checks it.
func callSign(payload []byte) ([]byte, error) {
	t := rootTable(payload)
	message := fbString(&t, 4)
	// vTable slot 1 (offset 6) is intentionally skipped in SignRequest
	privateKey := fbString(&t, 8)
	passphrase := fbString(&t, 10)
	ko := parseKeyOptions(fbTable(&t, 12))

	entity, err := readAndUnlockPrivateKey(privateKey, passphrase)
	if err != nil {
		return errStringResponse(err), nil
	}

	var buf bytes.Buffer
	armorWriter, err := armor.Encode(&buf, "PGP SIGNATURE", nil)
	if err != nil {
		return errStringResponse(err), nil
	}
	cfg := buildConfig(ko)
	if err = openpgp.DetachSignText(armorWriter, entity, strings.NewReader(message), cfg); err != nil {
		return errStringResponse(err), nil
	}
	armorWriter.Close()
	return stringResponse(buf.String(), ""), nil
}

// signBytes creates a detached signature from binary input, returns bytes.
func callSignBytes(payload []byte) ([]byte, error) {
	t := rootTable(payload)
	message := fbBytes(&t, 4)
	privateKey := fbString(&t, 8)
	passphrase := fbString(&t, 10)
	ko := parseKeyOptions(fbTable(&t, 12))

	entity, err := readAndUnlockPrivateKey(privateKey, passphrase)
	if err != nil {
		return errBytesResponse(err), nil
	}

	var buf bytes.Buffer
	cfg := buildConfig(ko)
	if err = openpgp.DetachSign(&buf, entity, bytes.NewReader(message), cfg); err != nil {
		return errBytesResponse(err), nil
	}
	return bytesResponse(buf.Bytes(), ""), nil
}

// signBytesToString creates a detached armored signature from binary input.
func callSignBytesToString(payload []byte) ([]byte, error) {
	t := rootTable(payload)
	message := fbBytes(&t, 4)
	privateKey := fbString(&t, 8)
	passphrase := fbString(&t, 10)
	ko := parseKeyOptions(fbTable(&t, 12))

	entity, err := readAndUnlockPrivateKey(privateKey, passphrase)
	if err != nil {
		return errStringResponse(err), nil
	}

	var buf bytes.Buffer
	armorWriter, err := armor.Encode(&buf, "PGP SIGNATURE", nil)
	if err != nil {
		return errStringResponse(err), nil
	}
	cfg := buildConfig(ko)
	if err = openpgp.DetachSign(armorWriter, entity, bytes.NewReader(message), cfg); err != nil {
		return errStringResponse(err), nil
	}
	armorWriter.Close()
	return stringResponse(buf.String(), ""), nil
}

// signData creates a cleartext signed message (verifiable by verifyData).
func callSignData(payload []byte) ([]byte, error) {
	t := rootTable(payload)
	message := fbString(&t, 4)
	privateKey := fbString(&t, 6)
	passphrase := fbString(&t, 8)
	ko := parseKeyOptions(fbTable(&t, 10))

	entity, err := readAndUnlockPrivateKey(privateKey, passphrase)
	if err != nil {
		return errStringResponse(err), nil
	}

	var buf bytes.Buffer
	cfg := buildConfig(ko)
	w, err := clearsign.Encode(&buf, entity.PrivateKey, cfg)
	if err != nil {
		return errStringResponse(err), nil
	}
	if _, err = io.WriteString(w, message); err != nil {
		return errStringResponse(err), nil
	}
	w.Close()
	return stringResponse(buf.String(), ""), nil
}

// signDataBytes creates a signed literal data packet from binary input (bytes output).
func callSignDataBytes(payload []byte) ([]byte, error) {
	t := rootTable(payload)
	message := fbBytes(&t, 4)
	privateKey := fbString(&t, 6)
	passphrase := fbString(&t, 8)
	ko := parseKeyOptions(fbTable(&t, 10))

	entity, err := readAndUnlockPrivateKey(privateKey, passphrase)
	if err != nil {
		return errBytesResponse(err), nil
	}

	var buf bytes.Buffer
	cfg := buildConfig(ko)
	w, err := openpgp.Sign(&buf, entity, &openpgp.FileHints{IsBinary: true}, cfg)
	if err != nil {
		return errBytesResponse(err), nil
	}
	if _, err = w.Write(message); err != nil {
		return errBytesResponse(err), nil
	}
	w.Close()
	return bytesResponse(buf.Bytes(), ""), nil
}

// signDataBytesToString creates a signed literal data packet (armored string output).
func callSignDataBytesToString(payload []byte) ([]byte, error) {
	t := rootTable(payload)
	message := fbBytes(&t, 4)
	privateKey := fbString(&t, 6)
	passphrase := fbString(&t, 8)
	ko := parseKeyOptions(fbTable(&t, 10))

	entity, err := readAndUnlockPrivateKey(privateKey, passphrase)
	if err != nil {
		return errStringResponse(err), nil
	}

	var buf bytes.Buffer
	armorWriter, err := armor.Encode(&buf, "PGP MESSAGE", nil)
	if err != nil {
		return errStringResponse(err), nil
	}
	cfg := buildConfig(ko)
	w, err := openpgp.Sign(armorWriter, entity, &openpgp.FileHints{IsBinary: true}, cfg)
	if err != nil {
		return errStringResponse(err), nil
	}
	if _, err = w.Write(message); err != nil {
		return errStringResponse(err), nil
	}
	w.Close()
	armorWriter.Close()
	return stringResponse(buf.String(), ""), nil
}

// verify checks a detached text signature (produced by sign).
func callVerify(payload []byte) ([]byte, error) {
	t := rootTable(payload)
	signature := fbString(&t, 4)
	message := fbString(&t, 6)
	publicKey := fbString(&t, 8)

	keyring, err := readArmoredKey(publicKey)
	if err != nil {
		return errBoolResponse(err), nil
	}
	_, err = openpgp.CheckArmoredDetachedSignature(keyring, strings.NewReader(message), strings.NewReader(signature), nil)
	if err != nil {
		return boolResponse(false, err.Error()), nil
	}
	return boolResponse(true, ""), nil
}

// verifyBytes checks a detached binary signature against binary message.
func callVerifyBytes(payload []byte) ([]byte, error) {
	t := rootTable(payload)
	signature := fbString(&t, 4)
	message := fbBytes(&t, 6)
	publicKey := fbString(&t, 8)

	keyring, err := readArmoredKey(publicKey)
	if err != nil {
		return errBoolResponse(err), nil
	}

	block, err := armor.Decode(strings.NewReader(signature))
	if err != nil {
		return errBoolResponse(err), nil
	}
	_, err = openpgp.CheckDetachedSignature(keyring, bytes.NewReader(message), block.Body, nil)
	if err != nil {
		return boolResponse(false, err.Error()), nil
	}
	return boolResponse(true, ""), nil
}

// verifyData checks a cleartext signed message (produced by signData).
func callVerifyData(payload []byte) ([]byte, error) {
	t := rootTable(payload)
	signature := fbString(&t, 4)
	publicKey := fbString(&t, 6)

	keyring, err := readArmoredKey(publicKey)
	if err != nil {
		return errBoolResponse(err), nil
	}

	block, _ := clearsign.Decode([]byte(signature))
	if block == nil {
		return boolResponse(false, "not a cleartext signed message"), nil
	}
	_, err = openpgp.CheckDetachedSignature(keyring, bytes.NewReader(block.Bytes), block.ArmoredSignature.Body, nil)
	if err != nil {
		return boolResponse(false, err.Error()), nil
	}
	return boolResponse(true, ""), nil
}

// verifyDataBytes checks an inline signed binary message.
func callVerifyDataBytes(payload []byte) ([]byte, error) {
	t := rootTable(payload)
	signature := fbBytes(&t, 4)
	publicKey := fbString(&t, 6)

	keyring, err := readArmoredKey(publicKey)
	if err != nil {
		return errBoolResponse(err), nil
	}

	md, err := openpgp.ReadMessage(bytes.NewReader(signature), keyring, nil, nil)
	if err != nil {
		return boolResponse(false, err.Error()), nil
	}
	if _, err = io.Copy(io.Discard, md.UnverifiedBody); err != nil {
		return boolResponse(false, err.Error()), nil
	}
	if md.SignatureError != nil {
		return boolResponse(false, md.SignatureError.Error()), nil
	}
	return boolResponse(md.IsSigned && md.SignedBy != nil, ""), nil
}

func callEncryptSymmetric(payload []byte) ([]byte, error) {
	t := rootTable(payload)
	message := fbString(&t, 4)
	passphrase := fbString(&t, 6)
	ko := parseKeyOptions(fbTable(&t, 8))
	fh := parseFileHints(fbTable(&t, 10))

	var buf bytes.Buffer
	armorWriter, err := armor.Encode(&buf, "PGP MESSAGE", nil)
	if err != nil {
		return errStringResponse(err), nil
	}
	cfg := buildConfig(ko)
	w, err := openpgp.SymmetricallyEncrypt(armorWriter, []byte(passphrase), pgpFileHints(fh), cfg)
	if err != nil {
		return errStringResponse(err), nil
	}
	if _, err = io.WriteString(w, message); err != nil {
		return errStringResponse(err), nil
	}
	w.Close()
	armorWriter.Close()
	return stringResponse(buf.String(), ""), nil
}

func callEncryptSymmetricBytes(payload []byte) ([]byte, error) {
	t := rootTable(payload)
	message := fbBytes(&t, 4)
	passphrase := fbString(&t, 6)
	ko := parseKeyOptions(fbTable(&t, 8))
	fh := parseFileHints(fbTable(&t, 10))

	var buf bytes.Buffer
	cfg := buildConfig(ko)
	w, err := openpgp.SymmetricallyEncrypt(&buf, []byte(passphrase), pgpFileHints(fh), cfg)
	if err != nil {
		return errBytesResponse(err), nil
	}
	if _, err = w.Write(message); err != nil {
		return errBytesResponse(err), nil
	}
	w.Close()
	return bytesResponse(buf.Bytes(), ""), nil
}

func callDecryptSymmetric(payload []byte) ([]byte, error) {
	t := rootTable(payload)
	message := fbString(&t, 4)
	passphrase := fbString(&t, 6)

	block, err := armor.Decode(strings.NewReader(message))
	if err != nil {
		return errStringResponse(err), nil
	}
	prompt := func(keys []openpgp.Key, symmetric bool) ([]byte, error) {
		return []byte(passphrase), nil
	}
	md, err := openpgp.ReadMessage(block.Body, nil, prompt, nil)
	if err != nil {
		return errStringResponse(err), nil
	}
	plain, err := io.ReadAll(md.UnverifiedBody)
	if err != nil {
		return errStringResponse(err), nil
	}
	return stringResponse(string(plain), ""), nil
}

func callDecryptSymmetricBytes(payload []byte) ([]byte, error) {
	t := rootTable(payload)
	message := fbBytes(&t, 4)
	passphrase := fbString(&t, 6)

	prompt := func(keys []openpgp.Key, symmetric bool) ([]byte, error) {
		return []byte(passphrase), nil
	}
	md, err := openpgp.ReadMessage(bytes.NewReader(message), nil, prompt, nil)
	if err != nil {
		return errBytesResponse(err), nil
	}
	plain, err := io.ReadAll(md.UnverifiedBody)
	if err != nil {
		return errBytesResponse(err), nil
	}
	return bytesResponse(plain, ""), nil
}

func callArmorEncode(payload []byte) ([]byte, error) {
	t := rootTable(payload)
	data := fbBytes(&t, 4)
	armorType := fbString(&t, 6)

	if armorType == "" {
		armorType = "PGP MESSAGE"
	}
	var buf bytes.Buffer
	w, err := armor.Encode(&buf, armorType, nil)
	if err != nil {
		return errStringResponse(err), nil
	}
	if _, err = w.Write(data); err != nil {
		return errStringResponse(err), nil
	}
	w.Close()
	return stringResponse(buf.String(), ""), nil
}

func callArmorDecode(payload []byte) ([]byte, error) {
	t := rootTable(payload)
	message := fbString(&t, 4)

	block, err := armor.Decode(strings.NewReader(message))
	if err != nil {
		return armorDecodeResponse(nil, "", err.Error()), nil
	}
	body, err := io.ReadAll(block.Body)
	if err != nil {
		return armorDecodeResponse(nil, "", err.Error()), nil
	}
	return armorDecodeResponse(body, block.Type, ""), nil
}

func callConvertPrivateKeyToPublicKey(payload []byte) ([]byte, error) {
	t := rootTable(payload)
	privateKey := fbString(&t, 4)

	entity, err := readAndUnlockPrivateKey(privateKey, "")
	if err != nil {
		return errStringResponse(err), nil
	}
	pub, err := serializePublicKey(entity)
	if err != nil {
		return errStringResponse(err), nil
	}
	return stringResponse(pub, ""), nil
}

func callGetPublicKeyMetadata(payload []byte) ([]byte, error) {
	t := rootTable(payload)
	publicKey := fbString(&t, 4)

	entities, err := readArmoredKey(publicKey)
	if err != nil {
		return publicKeyMetadataResponse("", "", "", "", "", "", false, false, false, nil, err.Error()), nil
	}
	if len(entities) == 0 {
		return publicKeyMetadataResponse("", "", "", "", "", "", false, false, false, nil, "no keys found"), nil
	}
	entity := entities[0]
	pk := entity.PrimaryKey

	isSubKey := false
	canSign := pk.PubKeyAlgo.CanSign()
	canEncrypt := pk.PubKeyAlgo.CanEncrypt()

	ids := collectIdentities(entity)
	return publicKeyMetadataResponse(
		algoName(pk.PubKeyAlgo),
		keyIDHex(pk.KeyId),
		keyIDShortHex(pk.KeyId),
		pk.CreationTime.UTC().Format(time.RFC3339),
		fingerprintHex(pk.Fingerprint),
		strconv.FormatUint(pk.KeyId, 10),
		isSubKey,
		canSign,
		canEncrypt,
		ids,
		"",
	), nil
}

func callGetPrivateKeyMetadata(payload []byte) ([]byte, error) {
	t := rootTable(payload)
	privateKey := fbString(&t, 4)

	entities, err := readArmoredKey(privateKey)
	if err != nil {
		return privateKeyMetadataResponse("", "", "", "", "", false, false, false, nil, err.Error()), nil
	}
	if len(entities) == 0 {
		return privateKeyMetadataResponse("", "", "", "", "", false, false, false, nil, "no keys found"), nil
	}
	entity := entities[0]
	pk := entity.PrimaryKey
	priv := entity.PrivateKey

	encrypted := priv != nil && priv.Encrypted
	isSubKey := false
	canSign := pk.PubKeyAlgo.CanSign()

	ids := collectIdentities(entity)
	return privateKeyMetadataResponse(
		keyIDHex(pk.KeyId),
		keyIDShortHex(pk.KeyId),
		pk.CreationTime.UTC().Format(time.RFC3339),
		fingerprintHex(pk.Fingerprint),
		strconv.FormatUint(pk.KeyId, 10),
		isSubKey,
		encrypted,
		canSign,
		ids,
		"",
	), nil
}
