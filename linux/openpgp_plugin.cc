#include "openpgp_plugin.h"

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_glfw.h>
#include <flutter/standard_method_codec.h>
#include <sys/utsname.h>
#include "openpgp.h"

#include <map>
#include <memory>
#include <sstream>
#include <iostream>
#include <string.h>
#include <stdio.h>
#include <inttypes.h>

namespace
{

using flutter::EncodableList;
using flutter::EncodableMap;
using flutter::EncodableValue;

const EncodableValue &ValueOrNull(const EncodableMap &map, const char *key)
{
  static EncodableValue null_value;
  auto it = map.find(EncodableValue(key));
  if (it == map.end())
  {
    return null_value;
  }
  return it->second;
}

char *WriteableChar(const std::string &str)
{
  char *writable = new char[str.size() + 1];
  std::copy(str.begin(), str.end(), writable);
  writable[str.size()] = '\0';
  return writable;
}

KeyOptions GetKeyOptions(const EncodableMap &args)
{
  KeyOptions options = {};
  /* options.hash = WriteableChar(ValueOrNull(args, "hash").StringValue());
  options.cipher = WriteableChar(ValueOrNull(args, "cipher").StringValue());
  options.compression = WriteableChar(ValueOrNull(args, "compression").StringValue());
  options.compressionLevel = WriteableChar(std::to_string(ValueOrNull(args, "compressionLevel").IntValue()));
  options.rsaBits = WriteableChar(std::to_string(ValueOrNull(args, "rsaBits").IntValue()));
 */
  return options;
}

Options GetOptions(const EncodableMap &args)
{
  Options options = {};
  /* options.name = WriteableChar(ValueOrNull(args, "name").StringValue());
  options.comment = WriteableChar(ValueOrNull(args, "comment").StringValue());
  options.email = WriteableChar(ValueOrNull(args, "email").StringValue());
  options.passphrase = WriteableChar(ValueOrNull(args, "passphrase").StringValue());
  options.keyOptions = GetKeyOptions(args);
*/
  return options;
}

void encrypt(
    char *message,
    char *publicKey,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result)
{

  try
  {
    char *output = Encrypt(
        message,
        publicKey);
    if (output == NULL)
    {
      result->Error("error", "null pointer");
      return;
    }
    flutter::EncodableValue response(output);
    result->Success(&response);
  }
  catch (const std::exception &e)
  {
    result->Error("error", e.what());
  }
}

void decrypt(
    char *message,
    char *privateKey,
    char *passphrase,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result)
{

  try
  {
    char *output = Decrypt(
        message,
        privateKey,
        passphrase);
    if (output == NULL)
    {
      result->Error("error", "null pointer");
      return;
    }
    flutter::EncodableValue response(output);
    result->Success(&response);
  }
  catch (const std::exception &e)
  {
    result->Error("error", e.what());
  }
}

void encryptSymmetric(
    char *message,
    char *passphrase,
    KeyOptions options,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result)
{

  try
  {
    char *output = EncryptSymmetric(
        message,
        passphrase,
        options);
    if (output == NULL)
    {
      result->Error("error", "null pointer");
      return;
    }
    flutter::EncodableValue response(output);
    result->Success(&response);
  }
  catch (const std::exception &e)
  {
    result->Error("error", e.what());
  }
}

void decryptSymmetric(
    char *message,
    char *passphrase,
    KeyOptions options,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result)
{

  try
  {
    char *output = DecryptSymmetric(
        message,
        passphrase,
        options);
    if (output == NULL)
    {
      result->Error("error", "null pointer");
      return;
    }
    flutter::EncodableValue response(output);
    result->Success(&response);
  }
  catch (const std::exception &e)
  {
    result->Error("error", e.what());
  }
}

void sign(
    char *message,
    char *publicKey,
    char *privateKey,
    char *passphrase,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result)
{

  try
  {
    char *output = Sign(
        message,
        publicKey,
        privateKey,
        passphrase);
    if (output == NULL)
    {
      result->Error("error", "null pointer");
      return;
    }
    flutter::EncodableValue response(output);
    result->Success(&response);
  }
  catch (const std::exception &e)
  {
    result->Error("error", e.what());
  }
}

void verify(
    char *signature,
    char *message,
    char *publicKey,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result)
{

  try
  {
    char *output = Verify(
        signature,
        message,
        publicKey);
    if (output == NULL)
    {
      result->Error("error", "null pointer");
      return;
    }
    flutter::EncodableValue response(strcmp(output, "1") == 0);
    result->Success(&response);
  }
  catch (const std::exception &e)
  {
    result->Error("error", e.what());
  }
}

void generate(
    Options options,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result)
{

  try
  {
    KeyPair output = Generate(options);
    // printf("privateKey: %s\n", output.privateKey);
    // printf("publicKey: %s\n", output.publicKey);

    flutter::EncodableValue response(flutter::EncodableMap{
        {flutter::EncodableValue("publicKey"), flutter::EncodableValue(output.publicKey)},
        {flutter::EncodableValue("privateKey"), flutter::EncodableValue(output.privateKey)}});

    result->Success(&response);
  }
  catch (const std::exception &e)
  {
    result->Error("error", e.what());
  }
}

class OpenpgpPlugin : public flutter::Plugin
{
public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarGlfw *registrar);

  OpenpgpPlugin();

  virtual ~OpenpgpPlugin();

private:
  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

// static
void OpenpgpPlugin::RegisterWithRegistrar(
    flutter::PluginRegistrarGlfw *registrar)
{
  auto channel =
      std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
          registrar->messenger(), "openpgp",
          &flutter::StandardMethodCodec::GetInstance());
  auto plugin = std::make_unique<OpenpgpPlugin>();

  channel->SetMethodCallHandler(
      [plugin_pointer = plugin.get()](const auto &call, auto result) {
        plugin_pointer->HandleMethodCall(call, std::move(result));
      });

  registrar->AddPlugin(std::move(plugin));
}

OpenpgpPlugin::OpenpgpPlugin() {}

OpenpgpPlugin::~OpenpgpPlugin() {}

void OpenpgpPlugin::HandleMethodCall(
    const flutter::MethodCall<flutter::EncodableValue> &method_call,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result)
{
  if (method_call.method_name().compare("encrypt") == 0)
  {
    const EncodableMap &args = method_call.arguments()->MapValue();
    encrypt(
        WriteableChar(ValueOrNull(args, "message").StringValue()),
        WriteableChar(ValueOrNull(args, "publicKey").StringValue()),
        move(result));
  }
  else if (method_call.method_name().compare("decrypt") == 0)
  {
    const EncodableMap &args = method_call.arguments()->MapValue();
    decrypt(
        WriteableChar(ValueOrNull(args, "message").StringValue()),
        WriteableChar(ValueOrNull(args, "privateKey").StringValue()),
        WriteableChar(ValueOrNull(args, "passphrase").StringValue()),
        move(result));
  }
  else if (method_call.method_name().compare("encryptSymmetric") == 0)
  {
    const EncodableMap &args = method_call.arguments()->MapValue();
    encryptSymmetric(
        WriteableChar(ValueOrNull(args, "message").StringValue()),
        WriteableChar(ValueOrNull(args, "passphrase").StringValue()),
        GetKeyOptions(ValueOrNull(args, "options").MapValue()),
        move(result));
  }
  else if (method_call.method_name().compare("decryptSymmetric") == 0)
  {
    const EncodableMap &args = method_call.arguments()->MapValue();
    decryptSymmetric(
        WriteableChar(ValueOrNull(args, "message").StringValue()),
        WriteableChar(ValueOrNull(args, "passphrase").StringValue()),
        GetKeyOptions(ValueOrNull(args, "options").MapValue()),
        move(result));
  }
  else if (method_call.method_name().compare("sign") == 0)
  {
    const EncodableMap &args = method_call.arguments()->MapValue();
    sign(
        WriteableChar(ValueOrNull(args, "message").StringValue()),
        WriteableChar(ValueOrNull(args, "publicKey").StringValue()),
        WriteableChar(ValueOrNull(args, "privateKey").StringValue()),
        WriteableChar(ValueOrNull(args, "passphrase").StringValue()),
        move(result));
  }
  else if (method_call.method_name().compare("verify") == 0)
  {
    const EncodableMap &args = method_call.arguments()->MapValue();
    verify(
        WriteableChar(ValueOrNull(args, "signature").StringValue()),
        WriteableChar(ValueOrNull(args, "message").StringValue()),
        WriteableChar(ValueOrNull(args, "publicKey").StringValue()),
        move(result));
  }
  else if (method_call.method_name().compare("generate") == 0)
  {
    const EncodableMap &args = method_call.arguments()->MapValue();
    generate(
        GetOptions(args),
        move(result));
  }
  else
  {
    result->NotImplemented();
  }
}

} // namespace

void OpenpgpPluginRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar)
{
  // The plugin registrar wrappers owns the plugins, registered callbacks, etc.,
  // so must remain valid for the life of the application.
  static auto *plugin_registrars =
      new std::map<FlutterDesktopPluginRegistrarRef,
                   std::unique_ptr<flutter::PluginRegistrarGlfw>>;
  auto insert_result = plugin_registrars->emplace(
      registrar, std::make_unique<flutter::PluginRegistrarGlfw>(registrar));

  OpenpgpPlugin::RegisterWithRegistrar(insert_result.first->second.get());
}
