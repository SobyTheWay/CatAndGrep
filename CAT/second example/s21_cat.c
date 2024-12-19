#include "s21_cat.h"

int main(int argc, char *argv[]) {
  options settings = {0};
  ERROR error = {0};
  set_flags(argc, argv, &settings, &error);
  print_err(&error);
  if (error.err_illegal_option == 0) cat_program(argc, argv, &settings, &error);
  return 0;
}

void set_flags(int argc, char *argv[], options *settings, ERROR *error) {
  int opt;
  struct option long_options[] = {{"number", no_argument, NULL, 'n'},
                                  {"number-nonblank", no_argument, NULL, 'b'},
                                  {"squeeze-blank", no_argument, NULL, 's'}};
  while (1) {
    int option_index = 0;
    opterr = 0;
    opt = getopt_long(argc, argv, "nbsvtTeEh", long_options, &option_index);
    if (opt == -1) break;
    switch (opt) {
      case 'n':
        if (settings->b != 1) settings->n = 1;
        break;
      case 'b':
        settings->b = 1;
        settings->n = 0;
        break;
      case 's':
        settings->s = 1;
        break;
      case 'v':
        settings->v = 1;
        break;
      case 't':
        settings->t = 1;
        settings->v = 1;
        break;
      case 'T':
        settings->t = 1;
        break;
      case 'e':
        settings->e = 1;
        settings->v = 1;
        break;
      case 'E':
        settings->e = 1;
        break;
      default:
        error->err_illegal_option = 1;
    }
  }
}

void cat_program(int argc, char *argv[], options *settings, ERROR *error) {
  unsigned char ch = '\n', prev_ch = '\n', prev_prev_ch = ' ';
  FILE *myfile;
  int count;
  int line_counter = 0;
  for (count = 1; count < argc; count++) {
    if ((myfile = fopen(argv[count], "r")) != NULL) {
      int flag_print = 0, flag_empty_line = 0, flag_print_tab = 0;
      while ((ch = fgetc(myfile)) != 255) {
        flag_print = (two_empty_line_detection(ch, prev_ch, prev_prev_ch) &&
                      settings->s) ||
                     !settings->s;
        flag_empty_line = empty_line_detection(ch, prev_ch);
        if ((flag_print && (prev_ch == '\n')) &&
            !(settings->b && !flag_empty_line)) {
          line_counter++;
          en_printf_line(line_counter, (settings->n || settings->b));
        }
        if (settings->e) add_cash(ch, flag_print);
        if (settings->t) flag_print_tab = add_tab(ch);
        if (settings->v) ch = M_notation(ch);
        en_printf_char(ch, (flag_print && !flag_print_tab));
        prev_prev_ch = prev_ch;
        prev_ch = ch;
        flag_print_tab = 0;
      }
      fclose(myfile);
      fflush(stdout);
    } else {
      if (argv[count][0] != '-') {
        error->err_open = 1;
      }
      print_err(error);
    }
  }
}

void en_printf_line(int line_counter, int enable) {
  if (enable) {
    printf("%6d\t", line_counter);
  }
}

void en_printf_char(char ch, int enable) {
  if (enable) {
    printf("%c", ch);
  }
}

int two_empty_line_detection(unsigned char ch, unsigned char prev_ch,
                             unsigned char prev_prev_ch) {
  int flag = !((prev_ch == '\n') && (prev_prev_ch == '\n') && (ch == '\n'));
  return flag;
}

int empty_line_detection(unsigned char ch, unsigned char prev_ch) {
  int flag = !((ch == prev_ch) && (prev_ch == '\n'));
  return flag;
}

void add_cash(unsigned char ch, int enable) {
  if ((ch == 10) && enable) {
    printf("$");
  }
}

int add_tab(unsigned char ch) {
  int flag = 0;
  if (ch == '\t') {
    printf("^I");
    flag = 1;
  }
  return flag;
}

unsigned char M_notation(unsigned char ch) {
  unsigned char new_ch = ch;
  if (ch < 32 && ch != 9 && ch != 10) {
    printf("^");
    new_ch = ch + 64;
  } else if (ch > 127 && ch < 160) {
    printf("M-^");
    new_ch = ch - 64;
  } else if (ch == 127) {
    printf("^");
    new_ch = ch - 64;
  } else if (ch >= 160 && ch < 255) {
    printf("M-");
    new_ch = ch - 128;
  }
  return new_ch;
}

void print_err(ERROR *error) {
  if (error->err_open != 0) {
    fprintf(stderr, "No such file or directory\n");
    error->err_open = 0;
  } else if (error->err_illegal_option != 0) {
    fprintf(stderr, "invalid option\n");
  }
}