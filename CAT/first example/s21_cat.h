#ifndef CAT_H
#define CAT_H

#include <getopt.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#define MAX_LINE_LENGTH 4096

struct cat_flags {
  int number_nonblank;
  int show_ends;
  int show_ctrl;
  int numbers;
  int show_tabs;
  int squeeze_blank;
};

struct cat_flags read_flags(int argc, char* argv[]);
void print_file(const char* filename, struct cat_flags flags, int* line_n,
                int* ends);
void print_line(const char* line, struct cat_flags flags, int* line_number,
                int is_blank, int add_line);
void print_file_error(const char* filename);

#endif