# 版本限定
cmake_minimum_required (VERSION 2.8)

# 项目名称设定
SET(PRJ_NAME Demo4)
PROJECT (${PRJ_NAME})

# 设置编译器选项：O3优化，显示所有警告
SET(CMAKE_C_FLAGS "$ENV{CFLAGS} -O3 -Wall") 

# 添加源文件路径下所有源文件存放到变量中(*.c && *.cpp)
AUX_SOURCE_DIRECTORY(${PROJECT_SOURCE_DIR} DIR_SRCS)

# 添加 math 子目录
ADD_SUBDIRECTORY(math)

# 指定生成的可执行文件路径
SET(EXECUTABLE_OUTPUT_PATH ${PROJECT_BINARY_DIR}/bin)

# 指定生成目标 
ADD_EXECUTABLE(${PRJ_NAME} ${DIR_SRCS})

# 添加链接库
TARGET_LINK_LIBRARIES(${PRJ_NAME} mymath)