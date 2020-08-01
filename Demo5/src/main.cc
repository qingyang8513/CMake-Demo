// Copyright 2020 MTRobot.
// Created by Martin on 2020.0801

#include <glog/logging.h>

#include <iostream>

#include "Logger/MLogger.h"

int main(int argc, char *argv[]) {
  std::cout << "CMake-Demo5\n";

  Logger::MLogger::Instance()->Init();
  LOG(INFO) << "INFO: CMake-Demo5";
  LOG(ERROR) << "ERROR: CMake-Demo5";

  return 0;
}
