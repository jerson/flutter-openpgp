# Install script for directory: /home/usuario/Proyectos/flutter/flutter-openpgp/example/linux

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "/home/usuario/Proyectos/flutter/flutter-openpgp/example/linux/cmake-build-debug/bundle")
endif()
string(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
if(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  if(BUILD_TYPE)
    string(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  else()
    set(CMAKE_INSTALL_CONFIG_NAME "Debug")
  endif()
  message(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
endif()

# Set the component getting installed.
if(NOT CMAKE_INSTALL_COMPONENT)
  if(COMPONENT)
    message(STATUS "Install component: \"${COMPONENT}\"")
    set(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  else()
    set(CMAKE_INSTALL_COMPONENT)
  endif()
endif()

# Install shared libraries without execute permission?
if(NOT DEFINED CMAKE_INSTALL_SO_NO_EXE)
  set(CMAKE_INSTALL_SO_NO_EXE "1")
endif()

# Is this installation the result of a crosscompile?
if(NOT DEFINED CMAKE_CROSSCOMPILING)
  set(CMAKE_CROSSCOMPILING "FALSE")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xRuntimex" OR NOT CMAKE_INSTALL_COMPONENT)
  
  file(REMOVE_RECURSE "/home/usuario/Proyectos/flutter/flutter-openpgp/example/linux/cmake-build-debug/bundle/")
  
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xRuntimex" OR NOT CMAKE_INSTALL_COMPONENT)
  if(EXISTS "$ENV{DESTDIR}/home/usuario/Proyectos/flutter/flutter-openpgp/example/linux/cmake-build-debug/bundle/openpgp_example" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}/home/usuario/Proyectos/flutter/flutter-openpgp/example/linux/cmake-build-debug/bundle/openpgp_example")
    file(RPATH_CHECK
         FILE "$ENV{DESTDIR}/home/usuario/Proyectos/flutter/flutter-openpgp/example/linux/cmake-build-debug/bundle/openpgp_example"
         RPATH "$ORIGIN/lib")
  endif()
  list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
   "/home/usuario/Proyectos/flutter/flutter-openpgp/example/linux/cmake-build-debug/bundle/openpgp_example")
  if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
file(INSTALL DESTINATION "/home/usuario/Proyectos/flutter/flutter-openpgp/example/linux/cmake-build-debug/bundle" TYPE EXECUTABLE FILES "/home/usuario/Proyectos/flutter/flutter-openpgp/example/linux/cmake-build-debug/intermediates_do_not_run/openpgp_example")
  if(EXISTS "$ENV{DESTDIR}/home/usuario/Proyectos/flutter/flutter-openpgp/example/linux/cmake-build-debug/bundle/openpgp_example" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}/home/usuario/Proyectos/flutter/flutter-openpgp/example/linux/cmake-build-debug/bundle/openpgp_example")
    file(RPATH_CHANGE
         FILE "$ENV{DESTDIR}/home/usuario/Proyectos/flutter/flutter-openpgp/example/linux/cmake-build-debug/bundle/openpgp_example"
         OLD_RPATH "/home/usuario/Proyectos/flutter/flutter-openpgp/example/linux/cmake-build-debug/plugins/openpgp:/home/usuario/Proyectos/flutter/flutter-openpgp/example/linux/flutter/ephemeral:"
         NEW_RPATH "$ORIGIN/lib")
    if(CMAKE_INSTALL_DO_STRIP)
      execute_process(COMMAND "/usr/bin/strip" "$ENV{DESTDIR}/home/usuario/Proyectos/flutter/flutter-openpgp/example/linux/cmake-build-debug/bundle/openpgp_example")
    endif()
  endif()
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xRuntimex" OR NOT CMAKE_INSTALL_COMPONENT)
  list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
   "/home/usuario/Proyectos/flutter/flutter-openpgp/example/linux/cmake-build-debug/bundle/data/icudtl.dat")
  if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
file(INSTALL DESTINATION "/home/usuario/Proyectos/flutter/flutter-openpgp/example/linux/cmake-build-debug/bundle/data" TYPE FILE FILES "/home/usuario/Proyectos/flutter/flutter-openpgp/example/linux/flutter/ephemeral/icudtl.dat")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xRuntimex" OR NOT CMAKE_INSTALL_COMPONENT)
  list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
   "/home/usuario/Proyectos/flutter/flutter-openpgp/example/linux/cmake-build-debug/bundle/lib/libflutter_linux_gtk.so")
  if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
file(INSTALL DESTINATION "/home/usuario/Proyectos/flutter/flutter-openpgp/example/linux/cmake-build-debug/bundle/lib" TYPE FILE FILES "/home/usuario/Proyectos/flutter/flutter-openpgp/example/linux/flutter/ephemeral/libflutter_linux_gtk.so")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xRuntimex" OR NOT CMAKE_INSTALL_COMPONENT)
  list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
   "/home/usuario/Proyectos/flutter/flutter-openpgp/example/linux/cmake-build-debug/bundle/lib/libopenpgp_plugin.so;/home/usuario/Proyectos/flutter/flutter-openpgp/example/linux/cmake-build-debug/bundle/lib/libopenpgp_bridge.so")
  if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
file(INSTALL DESTINATION "/home/usuario/Proyectos/flutter/flutter-openpgp/example/linux/cmake-build-debug/bundle/lib" TYPE FILE FILES
    "/home/usuario/Proyectos/flutter/flutter-openpgp/example/linux/cmake-build-debug/plugins/openpgp/libopenpgp_plugin.so"
    "/home/usuario/Proyectos/flutter/flutter-openpgp/example/linux/flutter/ephemeral/.plugin_symlinks/openpgp/linux/libopenpgp_bridge.so"
    )
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xRuntimex" OR NOT CMAKE_INSTALL_COMPONENT)
  
  file(REMOVE_RECURSE "/home/usuario/Proyectos/flutter/flutter-openpgp/example/linux/cmake-build-debug/bundle/data/flutter_assets")
  
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xRuntimex" OR NOT CMAKE_INSTALL_COMPONENT)
  list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
   "/home/usuario/Proyectos/flutter/flutter-openpgp/example/linux/cmake-build-debug/bundle/data/flutter_assets")
  if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
file(INSTALL DESTINATION "/home/usuario/Proyectos/flutter/flutter-openpgp/example/linux/cmake-build-debug/bundle/data" TYPE DIRECTORY FILES "/home/usuario/Proyectos/flutter/flutter-openpgp/example/build//flutter_assets")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for each subdirectory.
  include("/home/usuario/Proyectos/flutter/flutter-openpgp/example/linux/cmake-build-debug/flutter/cmake_install.cmake")
  include("/home/usuario/Proyectos/flutter/flutter-openpgp/example/linux/cmake-build-debug/plugins/openpgp/cmake_install.cmake")

endif()

if(CMAKE_INSTALL_COMPONENT)
  set(CMAKE_INSTALL_MANIFEST "install_manifest_${CMAKE_INSTALL_COMPONENT}.txt")
else()
  set(CMAKE_INSTALL_MANIFEST "install_manifest.txt")
endif()

string(REPLACE ";" "\n" CMAKE_INSTALL_MANIFEST_CONTENT
       "${CMAKE_INSTALL_MANIFEST_FILES}")
file(WRITE "/home/usuario/Proyectos/flutter/flutter-openpgp/example/linux/cmake-build-debug/${CMAKE_INSTALL_MANIFEST}"
     "${CMAKE_INSTALL_MANIFEST_CONTENT}")
