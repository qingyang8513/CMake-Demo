# ##############################################################################
# The minimum version required is CMake 2.8.3
cmake_minimum_required(VERSION 2.8.3)
project(CMake_Demo5)


# ##############################################################################
# load and run external cmake codes
include(cmake/internal_utils.cmake)


##############################################################################
# build version
set(VERSION_MAJOR 0)
set(VERSION_MINOR 1)


# ##############################################################################
# compile options
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")

add_definitions(-DGOOGLE_GLOG_DLL_DECL=)
#add_definitions(-DGLOG_NO_ABBREVIATED_SEVERITIES=)
if (${PLATFORM_WIN})
  if (${architecture} STREQUAL "x64")
    set(THIRD_PARTY_ROOT ${CMAKE_CURRENT_SOURCE_DIR}/third_party/win64)
  else ()
    set(THIRD_PARTY_ROOT ${CMAKE_CURRENT_SOURCE_DIR}/third_party/win32)
  endif ()
elseif (${PLATFORM_LINUX})
  set(THIRD_PARTY_ROOT ${CMAKE_CURRENT_SOURCE_DIR}/third_party/linux)
else ()
  message(FATAL_ERROR "invoke cmake with -DPLATFORM_LINUX=TRUE|-DPLATFORM_WIN=TRUE")
  return()
endif ()


##############################################################################
# Set output dir
set(OUTPUT_ROOT ${PROJECT_SOURCE_DIR}/output)
message(STATUS "Output path :  ${OUTPUT_ROOT}")
message(STATUS "Config types : ${CMAKE_CONFIGURATION_TYPES}")
message(STATUS "Build types :  ${CMAKE_CONFIGURATION_TYPES}")


##############################################################################
# include path
include_directories(include src)


##############################################################################
# Third parties settings
message(STATUS "The root path of third party:  ${THIRD_PARTY_ROOT}")

set(TP_PATH_GLOG ${THIRD_PARTY_ROOT}/glog)
include_directories(
  ${TP_PATH_GLOG}/include
)

link_directories(
  ${TP_PATH_GLOG}/lib
)

set(GLOG_LIBS glog)

##############################################################################
# Add sub-projects
add_subdirectory(src)
