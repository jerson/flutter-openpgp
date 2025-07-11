cmake_minimum_required(VERSION 3.15)
set(PROJECT_NAME "openpgp")
project(${PROJECT_NAME} LANGUAGES CXX)

set(PLUGIN_NAME "${PROJECT_NAME}_plugin")

add_library(${PLUGIN_NAME} SHARED
  "${PLUGIN_NAME}.cpp"
)
apply_standard_settings(${PLUGIN_NAME})
set_target_properties(${PLUGIN_NAME} PROPERTIES
  CXX_VISIBILITY_PRESET hidden)
target_compile_definitions(${PLUGIN_NAME} PRIVATE FLUTTER_PLUGIN_IMPL)
target_include_directories(${PLUGIN_NAME} INTERFACE
  "${CMAKE_CURRENT_SOURCE_DIR}/include")
target_link_libraries(${PLUGIN_NAME} PRIVATE flutter flutter_wrapper_plugin)

set(BUILD_BUNDLE_DIR "$<TARGET_FILE_DIR:${BINARY_NAME}>")

set(LIBOPENPGP_BRIDGE "libopenpgp_bridge.dll")
set(LIBOPENPGP_BRIDGE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/shared/${LIBOPENPGP_BRIDGE}")

# List of absolute paths to libraries that should be bundled with the plugin
set(openpgp_bundled_libraries
  ${LIBOPENPGP_BRIDGE_PATH}
  PARENT_SCOPE
)
