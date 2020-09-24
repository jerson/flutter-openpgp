cmake_minimum_required(VERSION 3.10)
set(PROJECT_NAME "openpgp")
project(${PROJECT_NAME} LANGUAGES CXX)

set(PLUGIN_NAME "${PROJECT_NAME}_plugin")

add_library(${PLUGIN_NAME} SHARED
  "${PLUGIN_NAME}.cc"
)
apply_standard_settings(${PLUGIN_NAME})
set_target_properties(${PLUGIN_NAME} PROPERTIES
  CXX_VISIBILITY_PRESET hidden)
target_compile_definitions(${PLUGIN_NAME} PRIVATE FLUTTER_PLUGIN_IMPL)
target_include_directories(${PLUGIN_NAME} INTERFACE
  "${CMAKE_CURRENT_SOURCE_DIR}/include")
target_link_libraries(${PLUGIN_NAME} PRIVATE flutter)
target_link_libraries(${PLUGIN_NAME} PRIVATE PkgConfig::GTK)

# List of absolute paths to libraries that should be bundled with the plugin
set(openpgp_bundled_libraries
  "${CMAKE_CURRENT_SOURCE_DIR}/libopenpgp_bridge.so"
  PARENT_SCOPE
)

set(OPENPGP_BRIDGE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/lib/amd64")
set(OPENPGP_BRIDGE_LIBRARY "${OPENPGP_BRIDGE_DIR}/libopenpgp_bridge.so")

LINK_DIRECTORIES("${OPENPGP_BRIDGE_DIR}")

#target_include_directories(${PLUGIN_NAME} INTERFACE ${OPENPGP_BRIDGE_DIR})
#target_link_libraries(${PLUGIN_NAME} INTERFACE ${OPENPGP_BRIDGE_LIBRARY})

#target_link_libraries(${PLUGIN_NAME} INTERFACE "${OPENPGP_BRIDGE_LIBRARY}")
#
#target_link_libraries(${PLUGIN_NAME} INTERFACE "openpgp_bridge")

