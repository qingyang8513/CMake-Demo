cmake_minimum_required(VERSION 3.17)
project(MJsonTest)

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_CURRENT_LIST_DIR}/cmake")
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_DEBUG_POSTFIX d)
set(CMAKE_VERBOSE_MAKEFILE ON)
set(CMAKE_INSTALL_PREFIX output)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

if(MSVC)
  set(RUNTIME_DEPS "${CMAKE_BINARY_DIR}/bin/$(Configuration)")
  link_directories(${CMAKE_BINARY_DIR}/lib/$(Configuration))
  add_compile_options($<$<COMPILE_LANGUAGE:CXX>:/MP>)
else()
  set(RUNTIME_DEPS "${CMAKE_BINARY_DIR}/bin/")
  link_directories(${CMAKE_BINARY_DIR}/lib)
endif()

include(libraries)
message("Fetching nlohmann_json")
FetchContent_MakeAvailable(nlohmann_json)

message("Fetching spdlog")
# Check if population has already been performed
FetchContent_GetProperties(spdlog)
if(NOT spdlog_POPULATED)
  # Fetch the content using previously declared details
  FetchContent_Populate(spdlog)
  # Set custom variables, policies, etc if in need. Bring the populated content
  # into the build
  add_subdirectory(${spdlog_SOURCE_DIR} ${spdlog_BINARY_DIR})
endif()

file(GLOB SOURCES_AND_HEADERS "*.cpp" "include/*.h")

add_executable(${PROJECT_NAME} main.cc ${SOURCES_AND_HEADERS})
target_include_directories(${PROJECT_NAME} PUBLIC ${PROJECT_SOURCE_DIR}/include)

target_link_libraries(${PROJECT_NAME} PRIVATE nlohmann_json::nlohmann_json)
target_link_libraries(${PROJECT_NAME} PRIVATE spdlog::spdlog)
