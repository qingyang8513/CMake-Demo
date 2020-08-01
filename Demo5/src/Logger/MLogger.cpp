// Copyright 2020 MTRobot.
// Created by Martin on 6/20/2019

#include "logger/MLogger.h"

namespace {
const char kPrefixExtensionName[] = "log_";
}  // namespace

namespace Logger {

std::mutex MLogger::mutex_instance_;
std::unique_ptr<MLogger> MLogger::mlogger_;

MLogger *MLogger::Instance() {
  std::lock_guard<std::mutex> lk(MLogger::mutex_instance_);
  if (!mlogger_) {
    mlogger_.reset(new MLogger());
    mlogger_->Init();
  }
  return mlogger_.get();
}

MLogger::MLogger() : log_level_(1), inited_(0) {}

MLogger::~MLogger() { Fini(); }

void MLogger::Init(const std::string &logger_path, int log_level) {
  std::unique_lock<std::mutex> lk(mutex_);
  if (inited_) {
    UpdateConfig(logger_path, log_level);
    inited_++;
    return;
  }

  logger_path_ = logger_path;
  log_level_ = log_level;
  {
    // FLAGS_log_dir = m_logger_path_; // Set log dir, you can delete this
    FLAGS_colorlogtostderr = true;           // Set log color
    FLAGS_logbufsecs = 0;                    // Set log output speed(s)
    FLAGS_max_log_size = 1024;               // Set max log file size, MB
    FLAGS_stop_logging_if_full_disk = true;  // If disk is full
    FLAGS_v = log_level_;
    FLAGS_minloglevel = google::GLOG_INFO;
    FLAGS_alsologtostderr = 0;
    FLAGS_logtostderr = 0;
    FLAGS_stderrthreshold = 0;

    google::SetLogDestination(google::GLOG_INFO, logger_path_.c_str());
    google::SetLogSymlink(google::GLOG_INFO, "");
    google::SetLogFilenameExtension(kPrefixExtensionName);
    google::SetStderrLogging(google::GLOG_INFO);  //
    google::FlushLogFiles(google::GLOG_ERROR);
    google::FlushLogFilesUnsafe(google::GLOG_FATAL);
    google::InitGoogleLogging("MLogger");
  }
  inited_++;
}

std::string MLogger::GetCurrentAppPath(const char *argv0) {
  std::string fullPath(argv0);
  auto pos = fullPath.find_last_of('/');
  if (pos == std::string::npos) {
    pos = fullPath.find_last_of('\\');
  }
  if (pos == std::string::npos) {
    fullPath = "./";
  } else {
    fullPath = fullPath.substr(0, pos);
  }

  return fullPath;
}

void MLogger::set_logger_path(const std::string &path) {
  std::unique_lock<std::mutex> lk(mutex_);
  if (inited_) {
    logger_path_ = path;
    google::SetLogDestination(google::GLOG_INFO, logger_path_.c_str());
  } else {
    lk.unlock();
    Init(path, log_level_);
  }
}

void MLogger::set_log_level(int level) {
  std::unique_lock<std::mutex> lk(mutex_);
  if (!inited_) {
    log_level_ = level;
    FLAGS_v = level;
  } else {
    lk.unlock();
    Init(logger_path_, level);
  }
}

const std::string &MLogger::logger_path(void) const {
  std::unique_lock<std::mutex> lk(mutex_);
  return logger_path_;
}

const int MLogger::log_level(void) const {
  std::unique_lock<std::mutex> lk(mutex_);
  return log_level_;
}

void MLogger::Fini(void) {
  inited_ = 0;
  logger_path_.clear();
  log_level_ = 1;
  // google::FlushLogFiles(google::GLOG_INFO);
  // google::ShutdownGoogleLogging();
}

void MLogger::UpdateConfig(const std::string &logger_path, int log_level) {
  logger_path_ = logger_path;
  log_level_ = log_level;

  FLAGS_v = log_level_;
  google::SetLogDestination(google::GLOG_INFO, logger_path_.c_str());
}

}  // namespace Logger
