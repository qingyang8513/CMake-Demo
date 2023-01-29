cmake_minimum_required(VERSION 3.11)

include(FetchContent)

FetchContent_Declare(
  nlohmann_json
  GIT_REPOSITORY https://github.com/nlohmann/json.git
  GIT_TAG v3.11.2
  GIT_SHALLOW TRUE
  GIT_PROGRESS TRUE)

FetchContent_Declare(
  spdlog
  GIT_REPOSITORY https://github.com/gabime/spdlog.git
  GIT_TAG v1.10.0
  GIT_SHALLOW TRUE
  GIT_PROGRESS TRUE)
