#include "s21_grep.h"

int main(int argc, char *argv[]) {
  options settings = {0};
  arrays arrs = {0};
  ERROR error = {0};
  cmd_preprocess(argc, argv, &settings, &arrs, &error);
  set_flags(&settings, &arrs, &error);
  if (error.err_illegal_option == 0) grep_program(&settings, &arrs, &error);
  return 0;
}

void set_flags(options *settings, arrays *arrs, ERROR *error) {
  for (int i = 0; i < settings->flagc; i++) {
    if (arrs->argv_flags[i][0] == '-') {
      for (int j = 1; arrs->argv_flags[i][j] != '\0'; j++) {
        if (arrs->argv_flags[i][j] == 'e') {
          settings->e = 1;
        } else if (arrs->argv_flags[i][j] == 'i') {
          settings->i = 1;
        } else if (arrs->argv_flags[i][j] == 'v') {
          settings->v = 1;
        } else if ((arrs->argv_flags[i][j] == 'c') && (settings->l == 0)) {
          settings->c = 1;
        } else if (arrs->argv_flags[i][j] == 'l') {
          settings->l = 1;
          settings->n = 0;
          settings->c = 0;
        } else if ((arrs->argv_flags[i][j] == 'n') && (settings->l == 0)) {
          settings->n = 1;
        } else {
          error->err_illegal_option = 1;
        }
      }
    }
  }
  print_err(error);
}

void grep_program(options *settings, arrays *arrs, ERROR *error) {
  for (int j = 0; j < settings->filesc; j++) {
    FILE *myfile;
    if ((myfile = fopen(arrs->argv_files[j], "r")) != NULL) {
      regex_t preg;
      regmatch_t pm;
      char *line = NULL;
      size_t len = 0;
      int line_counter_n = 0, line_counter = 0, line_counter_v = 0;
      while (getline(&line, &len, myfile) != -1) {
        line_counter_n++;
        char *text = line;
        int skip_print = 0;
        for (int i = 0; i < settings->argsc; i++) {
          char *pattern = arrs->argv_args[i];
          int registr = settings->i ? REG_ICASE : 0;
          if (regcomp(&preg, pattern, registr) != 0) error->err_regcomp = 1;
          int regerr = regexec(&preg, text, 1, &pm, 0);
          if ((regerr == 0) && (settings->v != 1))
            line_counter++;
          else if ((regerr != 0) && (settings->v == 1))
            line_counter_v++;
          if ((((regerr == 0) && (settings->v != 1)) ||
               ((settings->v == 1) && (regerr != 0))) &&
              skip_print != 1 && settings->c != 1 && settings->l != 1) {
            printf_fname(settings, arrs->argv_files[j]);
            en_printf_num(line_counter_n, settings->n);
            en_printf_line(line, *&settings);
            skip_print = 1;
          }
          regfree(&preg);
        }
      }
      free(line);
      fclose(myfile);
      if ((settings->c == 1) && (settings->v != 1)) {
        printf_fname(settings, arrs->argv_files[j]);
        printf("%d\n", line_counter);
      } else if ((settings->c == 1) && (settings->v == 1)) {
        printf_fname(settings, arrs->argv_files[j]);
        printf("%d\n", line_counter_v);
      }
      if (((settings->l == 1) && (line_counter > 0) && (settings->v != 1)) ||
          ((settings->l == 1) && (line_counter_v > 0) && (settings->v == 1)))
        printf("%s\n", arrs->argv_files[j]);
    } else
      error->err_open = 1;
    print_err(error);
  }
  malloc_free(settings, arrs);
}

void malloc_free(options *settings, arrays *arrs) {
  for (int i = 0; i < settings->argsc; i++) free(arrs->argv_args[i]);
  for (int i = 0; i < settings->filesc; i++) free(arrs->argv_files[i]);
  for (int i = 0; i < settings->flagc; i++) free(arrs->argv_flags[i]);

  free(arrs->argv_flags);
  free(arrs->argv_args);
  free(arrs->argv_files);
}

void en_printf_num(int line_counter_n, int enable) {
  if (enable) {
    printf("%d:", line_counter_n);
  }
}

void en_printf_line(char *line, options *settings) {
  if (!(settings->c == 1 || settings->l == 1)) printf("%s", line);
  if (line[strlen(line) - 1] != '\n') printf("\n");
}

void printf_fname(options *settings, char *fname) {
  if (settings->filesc > 1) {
    printf("%s:", fname);
  }
}

void malloc_create(int argc, arrays *arrs, ERROR *error) {
  arrs->argv_flags = (char **)malloc(argc * sizeof(char *));
  arrs->argv_args = (char **)malloc(argc * sizeof(char *));
  arrs->argv_files = (char **)malloc(argc * sizeof(char *));

  if (arrs->argv_flags == NULL || arrs->argv_args == NULL ||
      arrs->argv_files == NULL)
    error->err_mem = 1;
}

void cmd_preprocess(int argc, char *argv[], options *settings, arrays *arrs,
                    ERROR *error) {
  int flag_e = 0, flag_e_global = 0;
  int filesc = 0, flagc = 0, argsc = 0;
  malloc_create(argc, arrs, error);
  for (int i = 0; i < argc; i++) {
    if (argv[i][0] == '-') {
      if (argv[i][1] == 'e') {
        arrs->argv_flags[flagc] = (char *)malloc(2 * sizeof(char));
        strcpy(arrs->argv_flags[flagc], "-e");
        if (argv[i][2] != '\0') {
          arrs->argv_args[argsc] =
              (char *)malloc((strlen(argv[i]) + 1) * sizeof(char));
          strcpy(arrs->argv_args[argsc], argv[i]);
          remove_prefix_e(arrs->argv_args[argsc]);
          argsc++;
        } else {
          flag_e = 1;
        }
        flag_e_global = 1;
      } else {
        arrs->argv_flags[flagc] =
            (char *)malloc((strlen(argv[i]) + 1) * sizeof(char));
        strcpy(arrs->argv_flags[flagc], argv[i]);
      }
      flagc++;
    } else {
      if (flag_e == 1) {
        arrs->argv_args[argsc] =
            (char *)malloc((strlen(argv[i]) + 1) * sizeof(char));
        strcpy(arrs->argv_args[argsc], argv[i]);
        flag_e = 0;
        argsc++;
      } else {
        if (i > 0) {
          arrs->argv_files[filesc] =
              (char *)malloc((strlen(argv[i]) + 1) * sizeof(char));
          strcpy(arrs->argv_files[filesc], argv[i]);
          filesc++;
        }
      }
    }
  }
  if (flag_e_global == 0) {
    arrs->argv_args[argsc] =
        (char *)malloc((strlen(arrs->argv_files[0]) + 1) * sizeof(char));
    strcpy(arrs->argv_args[0], arrs->argv_files[0]);
    argsc++;
    for (int l = 1; l < filesc; l++) {
      free(arrs->argv_files[l - 1]);
      arrs->argv_files[l - 1] =
          (char *)malloc((strlen(arrs->argv_files[l]) + 1) * sizeof(char));
      strcpy(arrs->argv_files[l - 1], arrs->argv_files[l]);
    }
    free(arrs->argv_files[filesc - 1]);
    filesc--;
  }
  settings->filesc = filesc;
  settings->flagc = flagc;
  settings->argsc = argsc;
  print_err(error);
}

void remove_prefix_e(char *arr) {
  if (arr[0] == '-' && arr[1] == 'e') {
    memmove(arr, arr + 2, strlen(arr) - 1);
  }
}

void print_err(ERROR *error) {
  if (error->err_open != 0) {
    fprintf(stderr, "No such file or directory\n");
    error->err_open = 0;
  } else if (error->err_regcomp != 0)
    fprintf(stderr, "Error compiling regular expression");
  else if (error->err_mem != 0)
    fprintf(stderr, "Error allocating memory");
  else if (error->err_illegal_option != 0)
    fprintf(stderr, "ilnvalid option\n");
}