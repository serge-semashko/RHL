cmake_minimum_required(VERSION 3.8)
project(untitled)

set(CMAKE_C_STANDARD 11)

set(SOURCE_FILES main.c mybcm2835.c)
add_executable(untitled ${SOURCE_FILES})