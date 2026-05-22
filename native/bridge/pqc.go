package bridge

import (
	"crypto"
	"fmt"

	"github.com/ProtonMail/go-crypto/openpgp"
	"github.com/ProtonMail/go-crypto/openpgp/packet"
)

// Algorithm integer constants (must match Dart enum ordinals in lib/openpgp.dart).
const (
	AlgoRSA            = 0
	AlgoECDSA          = 1
	AlgoEdDSA          = 2
	AlgoECDH           = 3
	AlgoDSA            = 4
	AlgoElGamal        = 5
	AlgoMLDSA65Ed25519 = 6 // ML-DSA-65+Ed25519 (dil3x25519)
	AlgoMLDSA87Ed448   = 7 // ML-DSA-87+Ed448   (dil5x448)
	AlgoMLKEM768X25519 = 8 // Ed25519 primary + ML-KEM-768+X25519 subkey
	AlgoMLKEM1024X448  = 9 // Ed448 primary + ML-KEM-1024+X448 subkey
)

func isPQCAlgorithm(algo int32) bool {
	return algo >= AlgoMLDSA65Ed25519 && algo <= AlgoMLKEM1024X448
}

// GeneratePQCKeyPair generates a PQC key entity.
func GeneratePQCKeyPair(name, comment, email, passphrase string, algo int32, hash crypto.Hash) (*openpgp.Entity, error) {
	cfg := pqcConfig(algo, hash)
	if cfg == nil {
		return nil, fmt.Errorf("unsupported PQC algorithm %d", algo)
	}

	entity, err := openpgp.NewEntity(name, comment, email, cfg)
	if err != nil {
		return nil, fmt.Errorf("generating PQC key: %w", err)
	}

	if passphrase != "" {
		if err = entity.PrivateKey.Encrypt([]byte(passphrase)); err != nil {
			return nil, fmt.Errorf("encrypting PQC primary key: %w", err)
		}
		for _, sub := range entity.Subkeys {
			if sub.PrivateKey != nil {
				if err = sub.PrivateKey.Encrypt([]byte(passphrase)); err != nil {
					return nil, fmt.Errorf("encrypting PQC subkey: %w", err)
				}
			}
		}
	}

	return entity, nil
}

// pqcConfig returns an openpgp.Config for the requested PQC algorithm.
// ML-DSA algorithms require V6Keys=true (draft-ietf-openpgp-pqc).
// For ML-KEM algorithms, the library auto-creates an Ed25519/Ed448 primary key.
func pqcConfig(algo int32, defaultHash crypto.Hash) *packet.Config {
	if defaultHash == 0 {
		defaultHash = crypto.SHA256
	}
	aead := &packet.AEADConfig{}

	switch algo {
	case AlgoMLDSA65Ed25519:
		return &packet.Config{
			Algorithm:   packet.PubKeyAlgoMldsa65Ed25519,
			DefaultHash: defaultHash,
			AEADConfig:  aead,
			V6Keys:      true,
		}
	case AlgoMLDSA87Ed448:
		return &packet.Config{
			Algorithm:   packet.PubKeyAlgoMldsa87Ed448,
			DefaultHash: defaultHash,
			AEADConfig:  aead,
			V6Keys:      true,
		}
	case AlgoMLKEM768X25519:
		// Setting the algorithm to ML-KEM-768+X25519 causes the library to
		// generate an Ed25519 primary signing key with an ML-KEM encryption subkey.
		return &packet.Config{
			Algorithm:   packet.PubKeyAlgoMlkem768X25519,
			DefaultHash: defaultHash,
			AEADConfig:  aead,
		}
	case AlgoMLKEM1024X448:
		return &packet.Config{
			Algorithm:   packet.PubKeyAlgoMlkem1024X448,
			DefaultHash: defaultHash,
			AEADConfig:  aead,
			V6Keys:      true,
		}
	}
	return nil
}

// mapHash converts a Dart Hash enum value (0–3) to a crypto.Hash.
func mapHash(h int32) crypto.Hash {
	switch h {
	case 1:
		return crypto.SHA224
	case 2:
		return crypto.SHA384
	case 3:
		return crypto.SHA512
	default:
		return crypto.SHA256
	}
}
