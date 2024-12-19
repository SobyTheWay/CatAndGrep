#define _GNU_SOURCE
#include "s21_grep.h"

int main(int argc, char *argv[]) {
  config flags = {0};
  LIST *patterns = NULL;
  int result_code = 1;
  if (argc > 2)
    result_code = parse_args(argc, argv, &flags, &patterns);
  else
    result_code = 1;
  if (result_code == 0)
    while (optind < argc) {
      char *filename = argv[optind++];
      grep_file(filename, flags, patterns);
    }
  if (result_code == 1) print_arg_error();
  free_list(patterns);
  return result_code;
}

int parse_args(int argc, char *argv[], config *flags, LIST **patterns) {
  int getopt_result = 0;
  int result_code = 0;
  struct option long_options[] = {0};
  while (getopt_result != -1 && result_code == 0) {
    getopt_result = getopt_long(argc, argv, "ivclnhsoe:f:", long_options, NULL);
    result_code = process_flags(flags, getopt_result, patterns);
  }
  if (result_code == 0 && *patterns == NULL)
    result_code = add_str_to_patterns(argv[optind++], patterns);
  if (argc - optind == 1) flags->single_file = 1;
  *patterns = reverse_list(*patterns);
  return result_code;
}

int process_flags(config *flags, int getopt_result, LIST **patterns) {
  int result_code = 0;
  if (getopt_result == 'i')
    flags->i = 1;
  else if (getopt_result == 'v')
    flags->v = 1;
  else if (getopt_result == 'c')
    flags->c = 1;
  else if (getopt_result == 'l')
    flags->l = 1;
  else if (getopt_result == 'n')
    flags->n = 1;
  else if (getopt_result == 'h')
    flags->h = 1;
  else if (getopt_result == 's')
    flags->s = 1;
  else if (getopt_result == 'o')
    flags->o = 1;
  else if (getopt_result == 'e')
    result_code = process_e_flag(optarg, patterns);
  else if (getopt_result == 'f')
    result_code = process_f_flag(optarg, patterns);
  else if (getopt_result == '?')
    result_code = 1;
  return result_code;
}

int process_e_flag(char *pattern_str, LIST **patterns) {
  return add_str_to_patterns(pattern_str, patterns);
}

int process_f_flag(char *filename, LIST **patterns) {
  int result_code = 0;
  FILE *file = fopen(filename, "r");
  if (file == NULL) {
    print_file_error(filename);
    result_code = 1;
  }
  if (!result_code) {
    char *pattern_str = NULL;
    size_t len = 0;
    ssize_t read;
    while ((read = getline(&pattern_str, &len, file)) != -1 &&
           result_code == 0) {
      if (pattern_str[read - 1] == '\n') pattern_str[read - 1] = '\0';
      result_code = add_str_to_patterns(pattern_str, patterns);
    }
    free(pattern_str);
    fclose(file);
  }
  return result_code;
}

int add_str_to_patterns(char *pattern_str, LIST **patterns) {
  int result_code = 0;
  char *pattern = strdup(pattern_str);
  if (pattern == NULL)
    result_code = 1;
  else
    *patterns = add_node(*patterns, pattern);
  return result_code;
}

void grep_file(char *filename, config flags, LIST *patterns) {
  int error = 0;
  FILE *file = fopen(filename, "r");
  if (file == NULL) {
    if (flags.s == 0) print_file_error(filename);
    error = 1;
  }
  if (!error) {
    int line_number = 0;
    int token_line_cnt = 0;  // число совпадений
    char *checked_line = NULL;
    size_t len = 0;

    ssize_t read;
    while ((read = getline(&checked_line, &len, file)) != -1) {
      if (checked_line[read - 1] == '\n') checked_line[read - 1] = '\0';
      line_number++;
      LIST *tokens = process_line(checked_line, flags, patterns);
      tokens = process_v_flag(flags, checked_line, tokens);
      token_line_cnt = process_l_flag(flags, token_line_cnt, tokens);
      print_tokens(filename, flags, line_number, tokens);
      free_list(tokens);
    }
    flag_lc_print(filename, token_line_cnt, flags);
    free(checked_line);
    fclose(file);
  }
}

LIST *process_line(char *checked_line, config flags, LIST *patterns) {
  LIST *founded_list = NULL;
  size_t line_length = strlen(checked_line);
  regmatch_t regmatch[1] = {0};
  int cflags = 0;
  if (flags.i == 1) cflags |= REG_ICASE;
  regex_t regex = {0};
  LIST *head_patterns = patterns;
  int match_res = REG_NOMATCH;

  size_t offset = 0;
  if (flags.o == 0) {
    while (head_patterns && match_res != 0) {
      if (regcomp(&regex, head_patterns->data, cflags) == 0) {
        match_res = regexec(&regex, checked_line, 1, regmatch, 0);
        regfree(&regex);
      }
      head_patterns = head_patterns->next;
    }
    if (match_res == 0) {
      char *founded_line = strdup(checked_line);
      founded_list = add_node(founded_list, founded_line);
    }
  } else {
    while (offset <= line_length)
      founded_list = process_o_flag(checked_line, patterns, regmatch, cflags,
                                    &regex, match_res, founded_list, &offset);
  }
  founded_list = reverse_list(founded_list);
  return founded_list;
}

void print_tokens(const char *filename, config flags, int line_number,
                  LIST *head_tokens) {
  while (head_tokens) {
    if (!flags.v || !flags.o)
      line_print(filename, head_tokens->data, line_number, flags);
    head_tokens = head_tokens->next;
  }
}

int process_l_flag(config flags, int token_line_cnt, const LIST *tokens) {
  if (tokens) {
    if (flags.l == 1 && token_line_cnt == 0)
      token_line_cnt = 1;
    else if (flags.l == 0)
      token_line_cnt += 1;
  }
  return token_line_cnt;
}

LIST *process_v_flag(config flags, const char *checked_line, LIST *tokens) {
  if (flags.v == 1 && !tokens) {
    char *fnd_line = strdup(checked_line);
    tokens = add_node(tokens, fnd_line);
  } else if (flags.v == 1 && tokens) {
    free_list(tokens);
    tokens = NULL;
  }
  return tokens;
}

LIST *process_o_flag(const char *checked_line, LIST *patterns,
                     regmatch_t *regmatch, int cflags, regex_t *regex,
                     int match_res, LIST *founded_list, size_t *offset) {
  LIST *start_patterns = patterns;
  size_t max_res_len = 0;
  long long min_start_pos = 0;
  char *fnd_token = NULL;
  while (start_patterns) {
    int oflags = 0;
    if ((*offset) > 0) oflags |= REG_NOTBOL;
    if (regcomp(regex, start_patterns->data, cflags) == 0) {
      match_res = regexec(regex, checked_line + (*offset), 1, regmatch, oflags);
      regfree(regex);
      if (match_res == 0) {
        size_t res_len = regmatch->rm_eo - regmatch->rm_so;
        if ((regmatch->rm_so <= min_start_pos) && (res_len > max_res_len)) {
          min_start_pos = regmatch->rm_so;
          max_res_len = res_len;
          free(fnd_token);
          fnd_token = calloc(res_len + 1, sizeof(char));
          if (fnd_token)
            strncpy(fnd_token, checked_line + (*offset) + regmatch->rm_so,
                    res_len);
        }
      }
    }
    start_patterns = start_patterns->next;
  }
  if (max_res_len == 0)
    (*offset) += 1;
  else {
    (*offset) += max_res_len;
    founded_list = add_node(founded_list, fnd_token);
  }
  return founded_list;
}

LIST *reverse_list(LIST *head) {
  LIST *tail = head;
  while (tail) tail = tail->next;
  while (head) {
    LIST *node = NULL;
    node = head;
    head = head->next;
    node->next = tail;
    tail = node;
  }
  return tail;
}

LIST *add_node(LIST *head, char *pattern) {
  LIST *node = malloc(sizeof(LIST));
  node->next = head;
  node->data = pattern;
  return node;
}

void free_list(LIST *head) {
  while (head) {
    LIST *node = head;
    head = head->next;
    free(node->data);
    free(node);
  }
}

void print_arg_error() {
  printf("usage: s21_grep [-eivclnhsfo] [pattern] [file ...]\n");
}

void print_file_error(char *filename) {
  printf("s21_grep: %s: No such file or directory\n", filename);
}

void flag_lc_print(char *str, int line_cnt, config flags) {
  if (flags.c == 1 && flags.l == 1) {
    if (line_cnt > 0) {
      if (flags.single_file == 1)
        printf("%d\n%s\n", line_cnt, str);
      else {
        if (flags.h == 0)
          printf("%s:%d\n%s\n", str, line_cnt, str);
        else
          printf("%d\n%s\n", line_cnt, str);
      }
    }
  } else {
    if (flags.c == 1 && !flags.l) {
      if (flags.single_file == 1)
        printf("%d\n", line_cnt);
      else {
        if (flags.h == 0)
          printf("%s:%d\n", str, line_cnt);
        else
          printf("%d\n", line_cnt);
      }
    }
    if (flags.l == 1 && line_cnt > 0) printf("%s\n", str);
  }
}

void line_print(char const *filename, char *str, int cnt, config flags) {
  if (!flags.c && !flags.l) {
    if (!flags.single_file && flags.n)
      if (!flags.h)
        printf("%s:%d:%s\n", filename, cnt, str);
      else
        printf("%d:%s\n", cnt, str);
    else if (!flags.single_file && !flags.n)
      if (!flags.h)
        printf("%s:%s\n", filename, str);
      else
        printf("%s\n", str);
    else if (flags.single_file && flags.n)
      printf("%d:%s\n", cnt, str);
    else if (flags.single_file && !flags.n)
      printf("%s\n", str);
  }
}