package openpgp

import (
	"errors"

	flutter "github.com/go-flutter-desktop/go-flutter"
	"github.com/go-flutter-desktop/go-flutter/plugin"
	openPGPMobile "github.com/jerson/openpgp-mobile/openpgp"

	// this is a temporary fix to add missing crypto
	_ "golang.org/x/crypto/ripemd160"
)

const channelName = "openpgp"

// Plugin implements flutter.Plugin and handles method.
type Plugin struct {
	channel  *plugin.MethodChannel
	instance *openPGPMobile.FastOpenPGP
}

var _ flutter.Plugin = &Plugin{} // compile-time type check

// InitPlugin initializes the plugin.
func (p *Plugin) InitPlugin(messenger plugin.BinaryMessenger) error {
	p.channel = plugin.NewMethodChannel(messenger, channelName, plugin.StandardMethodCodec{})
	p.instance = openPGPMobile.NewFastOpenPGP()
	p.channel.HandleFunc("encrypt", p.encrypt)
	p.channel.HandleFunc("encryptBytes", p.encryptBytes)
	p.channel.HandleFunc("decrypt", p.decrypt)
	p.channel.HandleFunc("decryptBytes", p.decryptBytes)
	p.channel.HandleFunc("encryptSymmetric", p.encryptSymmetric)
	p.channel.HandleFunc("encryptSymmetricBytes", p.encryptSymmetricBytes)
	p.channel.HandleFunc("decryptSymmetric", p.decryptSymmetric)
	p.channel.HandleFunc("decryptSymmetricBytes", p.decryptSymmetricBytes)
	p.channel.HandleFunc("sign", p.sign)
	p.channel.HandleFunc("signBytes", p.signBytes)
	p.channel.HandleFunc("signBytesToString", p.signBytesToString)
	p.channel.HandleFunc("verify", p.verify)
	p.channel.HandleFunc("verify", p.verify)
	p.channel.HandleFunc("generate", p.generate)
	p.channel.CatchAllHandleFunc(p.catchAllTest)

	return nil
}

func (p *Plugin) encrypt(arguments interface{}) (reply interface{}, err error) {
	args := arguments.(map[interface{}]interface{})

	result, err := p.instance.Encrypt(
		args["message"].(string),
		args["publicKey"].(string),
	)
	if err != nil {
		return nil, plugin.NewError("error", err)
	}
	return result, nil
}

func (p *Plugin) encryptBytes(arguments interface{}) (reply interface{}, err error) {
	args := arguments.(map[interface{}]interface{})

	result, err := p.instance.EncryptBytes(
		args["message"].([]byte),
		args["publicKey"].(string),
	)
	if err != nil {
		return nil, plugin.NewError("error", err)
	}
	return result, nil
}

func (p *Plugin) decrypt(arguments interface{}) (reply interface{}, err error) {
	args := arguments.(map[interface{}]interface{})

	result, err := p.instance.Decrypt(
		args["message"].(string),
		args["privateKey"].(string),
		args["passphrase"].(string),
	)
	if err != nil {
		return nil, plugin.NewError("error", err)
	}
	return result, nil
}

func (p *Plugin) decryptBytes(arguments interface{}) (reply interface{}, err error) {
	args := arguments.(map[interface{}]interface{})

	result, err := p.instance.DecryptBytes(
		args["message"].([]byte),
		args["privateKey"].(string),
		args["passphrase"].(string),
	)
	if err != nil {
		return nil, plugin.NewError("error", err)
	}
	return result, nil
}

func (p *Plugin) encryptSymmetric(arguments interface{}) (reply interface{}, err error) {
	args := arguments.(map[interface{}]interface{})

	result, err := p.instance.EncryptSymmetric(
		args["message"].(string),
		args["passphrase"].(string),
		getKeyOptions(args["options"].(map[interface{}]interface{})),
	)
	if err != nil {
		return nil, plugin.NewError("error", err)
	}
	return result, nil
}

func (p *Plugin) encryptSymmetricBytes(arguments interface{}) (reply interface{}, err error) {
	args := arguments.(map[interface{}]interface{})

	result, err := p.instance.EncryptSymmetricBytes(
		args["message"].([]byte),
		args["passphrase"].(string),
		getKeyOptions(args["options"].(map[interface{}]interface{})),
	)
	if err != nil {
		return nil, plugin.NewError("error", err)
	}
	return result, nil
}

func (p *Plugin) decryptSymmetric(arguments interface{}) (reply interface{}, err error) {
	args := arguments.(map[interface{}]interface{})

	result, err := p.instance.DecryptSymmetric(
		args["message"].(string),
		args["passphrase"].(string),
		getKeyOptions(args["options"].(map[interface{}]interface{})),
	)
	if err != nil {
		return nil, plugin.NewError("error", err)
	}
	return result, nil
}

func (p *Plugin) decryptSymmetricBytes(arguments interface{}) (reply interface{}, err error) {
	args := arguments.(map[interface{}]interface{})

	result, err := p.instance.DecryptSymmetricBytes(
		args["message"].([]byte),
		args["passphrase"].(string),
		getKeyOptions(args["options"].(map[interface{}]interface{})),
	)
	if err != nil {
		return nil, plugin.NewError("error", err)
	}
	return result, nil
}

func (p *Plugin) sign(arguments interface{}) (reply interface{}, err error) {
	args := arguments.(map[interface{}]interface{})

	result, err := p.instance.Sign(
		args["message"].(string),
		args["publicKey"].(string),
		args["privateKey"].(string),
		args["passphrase"].(string),
	)
	if err != nil {
		return nil, plugin.NewError("error", err)
	}
	return result, nil
}

func (p *Plugin) signBytes(arguments interface{}) (reply interface{}, err error) {
	args := arguments.(map[interface{}]interface{})

	result, err := p.instance.SignBytes(
		args["message"].([]byte),
		args["publicKey"].(string),
		args["privateKey"].(string),
		args["passphrase"].(string),
	)
	if err != nil {
		return nil, plugin.NewError("error", err)
	}
	return result, nil
}

func (p *Plugin) signBytesToString(arguments interface{}) (reply interface{}, err error) {
	args := arguments.(map[interface{}]interface{})

	result, err := p.instance.SignBytesToString(
		args["message"].([]byte),
		args["publicKey"].(string),
		args["privateKey"].(string),
		args["passphrase"].(string),
	)
	if err != nil {
		return nil, plugin.NewError("error", err)
	}
	return result, nil
}

func (p *Plugin) verify(arguments interface{}) (reply interface{}, err error) {
	args := arguments.(map[interface{}]interface{})

	result, err := p.instance.Verify(
		args["signature"].(string),
		args["message"].(string),
		args["publicKey"].(string),
	)
	if err != nil {
		return nil, plugin.NewError("error", err)
	}
	return result, nil
}

func (p *Plugin) verifyBytes(arguments interface{}) (reply interface{}, err error) {
	args := arguments.(map[interface{}]interface{})

	result, err := p.instance.VerifyBytes(
		args["signature"].(string),
		args["message"].([]byte),
		args["publicKey"].(string),
	)
	if err != nil {
		return nil, plugin.NewError("error", err)
	}
	return result, nil
}

func (p *Plugin) generate(arguments interface{}) (reply interface{}, err error) {
	args := arguments.(map[interface{}]interface{})

	result, err := p.instance.Generate(getOptions(args))
	if err != nil {
		return nil, plugin.NewError("error", err)
	}
	return map[interface{}]interface{}{
		"privateKey": result.PrivateKey,
		"publicKey":  result.PublicKey,
	}, nil
}

func getKeyOptions(data map[interface{}]interface{}) *openPGPMobile.KeyOptions {

	options := &openPGPMobile.KeyOptions{}
	if data == nil {
		return options
	}

	if _, ok := data["hash"]; ok {
		options.Hash = data["hash"].(string)
	}
	if _, ok := data["cipher"]; ok {
		options.Cipher = data["cipher"].(string)
	}
	if _, ok := data["compression"]; ok {
		options.Compression = data["compression"].(string)
	}
	if _, ok := data["compressionLevel"]; ok {
		options.CompressionLevel = data["compressionLevel"].(int)
	}
	if _, ok := data["rsaBits"]; ok {
		options.RSABits = data["rsaBits"].(int)
	}

	return options

}

func getOptions(data map[interface{}]interface{}) *openPGPMobile.Options {

	options := &openPGPMobile.Options{}
	if data == nil {
		return options
	}

	if _, ok := data["name"]; ok {
		options.Name = data["name"].(string)
	}
	if _, ok := data["comment"]; ok {
		options.Comment = data["comment"].(string)
	}
	if _, ok := data["email"]; ok {
		options.Email = data["email"].(string)
	}
	if _, ok := data["passphrase"]; ok {
		options.Passphrase = data["passphrase"].(string)
	}
	if _, ok := data["keyOptions"]; ok {
		options.KeyOptions = getKeyOptions(data["keyOptions"].(map[interface{}]interface{}))
	}

	return options
}

func (p *Plugin) catchAllTest(methodCall interface{}) (reply interface{}, err error) {
	method := methodCall.(plugin.MethodCall)
	return method.Method, plugin.NewError("error", errors.New("not implemented"))
}
