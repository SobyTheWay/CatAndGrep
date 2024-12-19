#ifndef GREP_H
#define GREP_H

#include <getopt.h>
#include <regex.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct nodes {
  char *data;
  struct nodes *next;
} LIST;

typedef struct {
  int e;
  int i;
  int v;
  int c;
  int l;
  int n;
  int h;
  int s;
  int f;
  int o;
  int single_file;
} config;

int parse_args(int argc, char *argv[], config *flags, LIST **patterns);
int process_flags(config *flags, int getopt_result, LIST **patterns);
int process_e_flag(char *pattern_str, LIST **patterns);
int process_f_flag(char *filename, LIST **patterns);
int add_str_to_patterns(char *pattern_str, LIST **patterns);
void grep_file(char *filename, config flags, LIST *patterns);
LIST *process_line(char *checked_line, config flags, LIST *patterns);
LIST *process_v_flag(config flags, const char *checked_line, LIST *tokens);
int process_l_flag(config flags, int token_line_cnt, const LIST *tokens);
LIST *process_o_flag(const char *checked_line, LIST *patterns,
                     regmatch_t *regmatch, int cflags, regex_t *regex,
                     int match_res, LIST *founded_list, size_t *offset);
LIST *reverse_list(LIST *head);
LIST *add_node(LIST *head, char *pattern);
void free_list(LIST *head);
void line_print(char const *filename, char *str, int cnt, config flags);
void flag_lc_print(char *str, int line_cnt, config flags);
void print_arg_error();
void print_file_error(char *filename);
void print_tokens(const char *filename, config flags, int line_number,
                  LIST *head_tokens);

#endif
