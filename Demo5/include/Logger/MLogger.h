// Copyright 2020 MTRobot.
// Created by Martin on 6/20/2019

#ifndef INCLUDE_LOGGER_MLOGGER_H_
#define INCLUDE_LOGGER_MLOGGER_H_

#include <glog/logging.h>

#include <memory>
#include <mutex>
#include <string>

#define LOG_VERBOSE_HIGHEST 5
#define LOG_VERBOSE_HIGH 4
#define LOG_VERBOSE_NORMAL 3
#define LOG_VERBOSE_LOW 2
#define LOG_VERBOSE_LOWEST 1
#define LOG_VERBOSE_NONE 0

namespace Logger {

class MLogger {
 public:
  static MLogger *Instance();
  void Init(const std::string &logger_path = "./", int log_level = 1);
  static std::string GetCurrentAppPath(const char *argv0);

 public:
  ~MLogger();

  void set_logger_path(const std::string &path);
  void set_log_level(int level);

  const std::string &logger_path(void) const;
  const int log_level(void) const;

 private:
  MLogger();
  MLogger(const MLogger &) = delete;
  MLogger &operator=(const MLogger &) = delete;
  MLogger(MLogger &&) = delete;
  MLogger &operator=(MLogger &&) = delete;

  void Fini(void);
  void UpdateConfig(const std::string &logger_path, int log_level);

 private:
  static std::mutex mutex_instance_;
  static std::unique_ptr<MLogger> mlogger_;

  mutable std::mutex mutex_;
  std::string logger_path_;
  int log_level_;
  int inited_;
};

}  // namespace Logger

#endif  // INCLUDE_LOGGER_MLOGGER_H_
