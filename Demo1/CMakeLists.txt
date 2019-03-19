# 版本限定
CMAKE_MINIMUM_REQUIRED (VERSION 2.8)

# 项目名称设定
SET(PRJ_NAME Demo1)
PROJECT (${PRJ_NAME})

# 添加源文件列表变量
SET(DIR_SRCS main.cpp)

# 打印编译目录和项目目录路径
MESSAGE(STATUS "This is BINARY dir: " ${PROJECT_BINARY_DIR})
MESSAGE(STATUS "This is SOURCE dir: " ${PROJECT_SOURCE_DIR})

# 生成可执行文件
ADD_EXECUTABLE(${PRJ_NAME} ${DIR_SRCS})