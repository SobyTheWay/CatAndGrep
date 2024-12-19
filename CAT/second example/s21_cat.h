#ifndef S21_CAT_H
#define S21_CAT_H

#include <getopt.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

// #include "error.h"

typedef struct {
  int n;
  int b;
  int s;
  int v;
  int e;
  int t;
} options;

typedef struct {
  int err_open;
  int err_illegal_option;
  int sum_err;
} ERROR;

void cat_program(int argc, char *argv[], options *settings, ERROR *error);
void set_flags(int argc, char *argv[], options *settings, ERROR *error);
void en_printf_line(int line_counter, int enable);
void en_printf_char(char ch, int enable);
unsigned char M_notation(unsigned char ch);
void add_cash(unsigned char ch, int enable);
int empty_line_detection(unsigned char ch, unsigned char prev_ch);
int two_empty_line_detection(unsigned char ch, unsigned char prev_ch,
                             unsigned char prev_prev_ch);
int add_tab(unsigned char ch);
void print_err(ERROR *error);

#endif