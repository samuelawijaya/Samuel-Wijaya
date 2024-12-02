
#ifndef UTIL_H
#define UTIL_H

#include <sys/ioctl.h>  // For FIONREAD
#include <termios.h>
#include <chrono>
#include <cstdio>
#include <iostream>
#include <string>
using namespace std;
#include <ctype.h>
#include <sstream>
#include "Globals.h"

// Function declarations
// int kbhit(void);
char get_input(void);
void eraseLines(int count);
// void clear(void);
// std::string colored_string(const std::string text);
// std::string colored_string(const std::string text, const int rgb[3]);
std::string get_past_inputs();

#endif  // UTIL_H
