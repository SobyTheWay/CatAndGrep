#ifndef S21_GREP_H
#define S21_GREP_H
#define _GNU_SOURCE

#include <regex.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct {
  int e;
  int i;
  int v;
  int c;
  int l;
  int n;
  int filesc;
  int flagc;
  int argsc;
} options;

typedef struct {
  int err_open;
  int err_regcomp;
  int err_mem;
  int sum_err;
  int err_hello;
  int err_file;
  int err_illegal_option;
} ERROR;

typedef struct {
  char **argv_flags;
  char **argv_args;
  char **argv_files;
} arrays;

void set_flags(options *settings, arrays *arrs, ERROR *error);
void grep_program(options *settings, arrays *arrs, ERROR *error);
void en_printf_num(int line_counter_n, int enable);
void en_printf_line(char *line, options *settings);
void cmd_preprocess(int argc, char *argv[], options *settings, arrays *arrs,
                    ERROR *error);
void remove_prefix_e(char *arr);
void printf_fname(options *settings, char *fname);
void print_err(ERROR *error);
void malloc_free(options *settings, arrays *arrs);
void malloc_create(int argc, arrays *arrs, ERROR *error);

#endif