#include "s21_cat.h"

struct cat_flags read_flags(int argc, char* argv[]) {
  struct cat_flags flags = {0};
  struct option long_options[] = {{"number-nonblank", no_argument, NULL, 'b'},
                                  {"number", no_argument, NULL, 'n'},
                                  {"squeeze-blank", no_argument, NULL, 's'},
                                  {0, 0, 0, 0}};
  int opt;
  while ((opt = getopt_long(argc, argv, "beEnstTv", long_options, NULL)) !=
         -1) {
    switch (opt) {
      case 'b':
        flags.number_nonblank = 1;
        flags.numbers = 0;
        break;
      case 'e':
        flags.show_ends = 1;
        flags.show_ctrl = 1;
        break;
      case 'E':
        flags.show_ends = 1;
        break;
      case 'n':
        if (!flags.number_nonblank) flags.numbers = 1;
        break;
      case 's':
        flags.squeeze_blank = 1;
        break;
      case 't':
        flags.show_tabs = 1;
        flags.show_ctrl = 1;
        break;
      case 'T':
        flags.show_tabs = 1;
        break;
      case 'v':
        flags.show_ctrl = 1;
        break;
      default:
        fprintf(stderr, "Usage: s21_cat [-benst] [file...]");
        exit(EXIT_FAILURE);
    }
  }
  return flags;
}

int main(int argc, char* argv[]) {
  struct cat_flags flags = read_flags(argc, argv);

  if (optind == argc) {
    fprintf(stderr, "Usage: s21_cat [-benstTv] [file...]\n");
    return EXIT_FAILURE;
  }

  int line_n = 1;
  int ends = 1;

  for (int i = optind; i < argc; i++) {
    print_file(argv[i], flags, &line_n, &ends);
  }
  return 0;
}

void print_file(const char* filename, struct cat_flags flags, int* line_n,
                int* ends) {
  int error = 0;
  FILE* file = fopen(filename, "r");
  if (file == NULL) {
    print_file_error(filename);
    error = 1;
  }

  if (!error) {
    char line[MAX_LINE_LENGTH];
    int temp = 0;
    int is_blank = 0, add_line = !*ends;

    while (fgets(line, sizeof(line), file)) {
      is_blank = (line[0] == '\n');

      if (flags.squeeze_blank) {
        if (is_blank) {
          temp++;
          if (temp >= 2) continue;
        } else {
          temp = 0;
        }
      }
      print_line(line, flags, line_n, is_blank, add_line);

      size_t len = strlen(line);
      *ends = (len > 0 && line[len - 1] == '\n');
      add_line = 0;
    }

    fclose(file);
  }
}

void format_with_ctrl(char c, struct cat_flags flags) {
  if (c == 9 && flags.show_tabs) {
    printf("^I");
  } else if (c == 10 && flags.show_ends) {
    printf("$\n");
  } else if (c >= 0 && c <= 31 && c != 9 && c != 10 && flags.show_ctrl) {
    printf("^%c", c + 64);
  } else if (c == 127 && flags.show_ctrl) {
    printf("^?");
  } else {
    putchar(c);
  }
}

void print_line(const char* line, struct cat_flags flags, int* line_n,
                int is_blank, int add_line) {
  if (!add_line) {
    if ((flags.number_nonblank && !is_blank) ||
        (flags.numbers && !flags.number_nonblank)) {
      printf("%6d\t", (*line_n)++);
    }
  }

  size_t len = strlen(line);
  for (size_t i = 0; i < len; i++) {
    format_with_ctrl(line[i], flags);
  }
}

void print_file_error(const char* filename) {
  printf("s21_cat: %s: No such file or directory\n", filename);
}
