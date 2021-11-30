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
  ""
  PARENT_SCOPE
)

set(BUILD_BUNDLE_DIR "${PROJECT_BINARY_DIR}/../../bundle")
if(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
    set(CMAKE_INSTALL_PREFIX "${BUILD_BUNDLE_DIR}" CACHE PATH "..." FORCE)
endif()
set(INSTALL_BUNDLE_LIB_DIR "${CMAKE_INSTALL_PREFIX}/lib")
set(LIBOPENPGP_BRIDGE "libopenpgp_bridge.so")
set(LIBOPENPGP_BRIDGE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/shared/${LIBOPENPGP_BRIDGE}")
install(CODE "file(REMOVE_RECURSE \"${INSTALL_BUNDLE_LIB_DIR}/${LIBOPENPGP_BRIDGE}\")" COMPONENT Runtime)
install(FILES "${LIBOPENPGP_BRIDGE_PATH}" DESTINATION "${INSTALL_BUNDLE_LIB_DIR}" COMPONENT Runtime)

