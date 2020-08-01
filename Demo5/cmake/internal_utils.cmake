# ##############################################################################
# The minimum version is CMake 2.8.3
cmake_minimum_required(VERSION 2.8)


# ##############################################################################
# set property files
SET(PROPERTY_FILE "${CMAKE_CURRENT_SOURCE_DIR}/build.properties")
SET(PROPERTY_FILE_LOCAL "${CMAKE_CURRENT_BINARY_DIR}/build.properties.local")
SET(DEBUG_POSTFIX "d")

MESSAGE(STATUS "PROPERTY_FILE: ${PROPERTY_FILE}")
MESSAGE(STATUS "PROPERTY_FILE_LOCAL: ${PROPERTY_FILE_LOCAL}")


# ##############################################################################
# utils

# put key value to map
MACRO(MAP_PUT _MAP _KEY _VALUE)
  SET("MAP_${_MAP}_${_KEY}" ${_VALUE})
ENDMACRO(MAP_PUT)

# get value int map
MACRO(MAP_GET _MAP _KEY _OUTPUT)
  SET(KEY "MAP_${_MAP}_${_KEY}")
  set(${_OUTPUT} "undefined")
  if (${KEY})
    set(${_OUTPUT} ${${KEY}})
  endif ()
ENDMACRO(MAP_GET)

# get line contect
MACRO(GETLINES _LINES _FILENAME)
  FILE(READ ${_FILENAME} contents)
  STRING(REGEX REPLACE "\n" ";" ${_LINES} "${contents}")
ENDMACRO()

# load properties in file and put it into map
MACRO(LOAD_PROPERTY _MAP _FILENAME)
  FILE(READ ${_FILENAME} contents)
  STRING(REGEX REPLACE "\n" ";" lines "${contents}")
  foreach (line ${lines})
    if (NOT (${line} MATCHES "^(#|\t|\n| )"))
      STRING(REGEX REPLACE "\t+| +" ";" fields ${line})
      list(GET fields 0 KEY)
      list(GET fields 1 VALUE)
      MAP_PUT(${_MAP} ${KEY} ${VALUE})
    endif ()
  endforeach ()
ENDMACRO(LOAD_PROPERTY)

# load properties into ${PROPERTIES}
MACRO(READ_PROPERTIES PROPERTIES)
  if ((NOT (EXISTS ${PROPERTY_FILE})) AND (NOT (EXISTS ${PROPERTY_FILE_LOCAL})))
    message(FATAL_ERROR "CONFIG FILE `${PROPERTY_FILE}` and `${PROPERTY_FILE_LOCAL}` not EXISTS")
  endif ()
  if (EXISTS ${PROPERTY_FILE})
    message(STATUS "READ CONFIG FROM FILE:${PROPERTY_FILE}")
    LOAD_PROPERTY(${PROPERTIES} ${PROPERTY_FILE})
  endif ()
  if (EXISTS ${PROPERTY_FILE_LOCAL})
    message(STATUS "READ CONFIG FROM FILE:${PROPERTY_FILE_LOCAL}")
    LOAD_PROPERTY(${PROPERTIES} ${PROPERTY_FILE_LOCAL})
  endif ()
ENDMACRO(READ_PROPERTIES)

MACRO(PARSE_ARTIFACT_URI URI _GROUP _NAME _VERSION _EXTENSION)
  STRING(REGEX REPLACE ":" ";" fields ${URI})
  list(GET fields 0 ${_GROUP})
  list(GET fields 1 ${_NAME})
  list(GET fields 2 ${_VERSION})
  list(GET fields 3 ${_EXTENSION})
ENDMACRO()

# init build type
MACRO(INIT_TYPE PROPERTIES)
  MAP_GET(${PROPERTIES} build_type build_type)
  if (${build_type} STREQUAL "debug")
    set(CMAKE_BUILD_TYPE Debug)
    message(STATUS "BUILD TYPE: Debug")
  else ()
    set(CMAKE_BUILD_TYPE Release)
    message(STATUS "BUILD TYPE: Release")
  endif ()
ENDMACRO()

# Init platform info from ${PROPERTIES}
MACRO(INIT_PLATFORM_INFO PROPERTIES)
  MAP_GET(${PROPERTIES} platform platform)
  MAP_GET(${PROPERTIES} architecture architecture)
  MAP_GET(${PROPERTIES} architecture arch)
  MAP_GET(${PROPERTIES} vendor vendor)
  MAP_GET(${PROPERTIES} toolchain toolchain)
  if (${platform} STREQUAL "mac")
    set(PLATFORM_MAC TRUE)
  elseif (${platform} STREQUAL "linux")
    set(PLATFORM_LINUX TRUE)
    MAP_GET(${PROPERTIES} cmake_c_compiler C_COMPILER)
    MAP_GET(${PROPERTIES} cmake_cxx_compiler CXX_COMPILER)
    if (${C_COMPILER} STREQUAL "undefined")
    else ()
      SET(CMAKE_C_COMPILER ${C_COMPILER})
    endif ()
    if (${CXX_COMPILER} STREQUAL "undefined")
    else ()
      SET(CMAKE_CXX_COMPILER ${CXX_COMPILER})
    endif ()

  elseif (${platform} STREQUAL "win")
    set(PLATFORM_WIN TRUE)
  elseif (${platform} STREQUAL "android")
    set(PLATFORM_ANDROID TRUE)
    set(ANDROID_STL gnustl_static)
    set(CMAKE_VERBOSE_MAKEFILE ON)
    MAP_GET(${PROPERTIES} ANDROID_NDK ANDROID_NDK)
    if (${ANDROID_NDK} STREQUAL "undefined")
      message(FATAL_ERROR "ANDROID_NDK NOT SET")
    endif ()
    set(ANDROID_NDK ${ANDROID_NDK})
    set(CMAKE_TOOLCHAIN_FILE "${CMAKE_CURRENT_SOURCE_DIR}/cmake/android.toolchain.cmake")
    message(STATUS "CMAKE_TOOLCHAIN_FILE: ${CMAKE_TOOLCHAIN_FILE}")
    set(ANDROID_ABI armeabi-v7a)
    set(ANDROID_NATIVE_API_LEVEL android-21)
    message(STATUS "cmake -DPLATFORM_ANDROID=${PLATFORM_ANDROID} -DANDROID_STL=${ANDROID_STL} -DANDROID_NDK=${ANDROID_NDK} -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE} -DANDROID_ABI=${ANDROID_ABI} -DANDROID_NATIVE_API_LEVEL=${ANDROID_NATIVE_API_LEVEL} ..")
  else ()
    message(FATAL_ERROR "platform `${platform}` not suppored, choose from [linux | android | win | mac]")
  endif ()
ENDMACRO(INIT_PLATFORM_INFO)

MACRO(INIT_DEPENDENCY_INFO)
  set(CMAKE_DEBUG_POSTFIX ${DEBUG_POSTFIX})
  set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
  set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
  set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
  if (${PLATFORM_WIN})
    set(RUNTIME_DEPS "${CMAKE_BINARY_DIR}/bin/$(Configuration)")
    link_directories(${CMAKE_BINARY_DIR}/lib/$(Configuration))
  else ()
    set(RUNTIME_DEPS "${CMAKE_BINARY_DIR}/bin/")
    link_directories(${CMAKE_BINARY_DIR}/lib)
  endif ()
ENDMACRO()

#
MACRO(SOURCE_GROUP_BY_DIR all_files strip_path)
    #message("strip_path: ${strip_path}")
    if(MSVC)    
        foreach(single_file ${${all_files}})
            #message("single_file: ${single_file}")
            string(REGEX REPLACE "(${strip_path})/(.*)$" \\2 relative_fpath ${single_file})
            string(REGEX MATCH "^(.*)/(.*)\\.[^.]*$" dummy ${relative_fpath})
            set(file_path ${CMAKE_MATCH_1})
            #message("file_path: ${file_path}")
            if ("${file_path}" STREQUAL "")
              continue()
            endif ()   
            string(REPLACE "/" "\\" file_group_name ${file_path})
            #message("group name: ${file_group_name}")
            source_group(${file_group_name} FILES ${single_file})
        endforeach(single_file)
    endif(MSVC)
ENDMACRO(SOURCE_GROUP_BY_DIR)

MACRO(CREATE_LANCH_SCRIPT)
  if(${PLATFORM_LINUX})
    # Create ${EXE_MAIN}.sh
	  set(lanch_file ${EXE_MAIN}.sh)
    message(STATUS "Create: ${lanch_file}")
    file(WRITE "${MY_INSTALL_PATH}/${lanch_file}" "#!/bin/bash\n")
    file(APPEND "${MY_INSTALL_PATH}/${lanch_file}" "export LD_LIBRARY_PATH=\"`pwd`\"\n")
    file(APPEND "${MY_INSTALL_PATH}/${lanch_file}" "chmod +x ${EXE_MAIN}\n")
    file(APPEND "${MY_INSTALL_PATH}/${lanch_file}" "./${EXE_MAIN}\n")
  
    # Create qt.conf
	  set(qt_conf qt.conf)
    message(STATUS "Create: ${qt_conf}")
    file(WRITE "${MY_INSTALL_PATH}/${qt_conf}" "[Paths]\n")
    file(APPEND "${MY_INSTALL_PATH}/${qt_conf}" "Prefix = .\n")
    file(APPEND "${MY_INSTALL_PATH}/${qt_conf}" "Plugins = ./plugins\n")
  endif()
ENDMACRO(CREATE_LANCH_SCRIPT)

# first argument must be target folder.
function(copy_files TARGET)
  foreach(file_i ${ARGN})
    string(REGEX
           REPLACE "/"
           ";"
           ITEMS
           "${file_i}")
    set(target_name "")
    foreach(name ${ITEMS})
      set(target_name ${name})
    endforeach(name)
    message(STATUS "===>${target_name}")
    add_custom_command(TARGET ${EXE_MAIN} POST_BUILD
                       COMMAND ${CMAKE_COMMAND} -E copy_if_different ${file_i}
                       ${RUNTIME_DEPS}/${ARGV0}${target_name})
  endforeach(file_i)
endfunction()

function(mtrobot_link_libraries)
  foreach (lib ${ARGN})
    link_libraries(debug "${lib}${DEBUG_POSTFIX}" optimized ${lib})
  endforeach ()
endfunction()

function(mtrobot_target_link_libraries target)
  foreach (lib ${ARGN})
    target_link_libraries(${target} debug "${lib}${DEBUG_POSTFIX}" optimized ${lib})
  endforeach ()
endfunction()


# ##############################################################################
# init settings
READ_PROPERTIES(properties)
INIT_TYPE(properties)
INIT_PLATFORM_INFO(properties)
INIT_DEPENDENCY_INFO()

MESSAGE(STATUS "Platform : ${platform}")
MESSAGE(STATUS "Architecture : ${architecture}")
