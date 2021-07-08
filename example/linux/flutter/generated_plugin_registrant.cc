//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <openpgp/openpgp_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) openpgp_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "OpenpgpPlugin");
  openpgp_plugin_register_with_registrar(openpgp_registrar);
}
