# CMake-Demo
This demos show the usage of cmake.

# Usage
```  
cd Demo1
cmake .
make
./Demo1
```  

# Brief Informatino
## Demo1
One simple single source file.  
Struct:  
.  
├── CMakeLists.txt  
└── main.cpp  

## Demo2
Create shared lib and static lib.  
Struct:  
.  
├── CMakeLists.txt  
├── include  
│   └── mymathi.h  
└── src  
    └── mymath.c  

## Demo3
Create exe using shared lib or static lib.  
Struct:  
.  
├── CMakeLists.txt  
├── include  
│   └── mymath.h  
├── lib  
│   ├── libmymath.a  
│   └── libmymath.so  
└── src  
    └── main.cpp  

## Demo4
Including subdirectory.  
Struct:  
.  
├── CMakeLists.txt  
├── main.cpp  
└── math  
    ├── CMakeLists.txt  
    ├── include  
    │   └── mymath.h  
    └── src  
        └── mymath.c  



