#ifndef PARSE_H
#define PARSE_H // Обе строки нужны от множественного включения одних и тех же заголов. файлов 

typedef struct {
  int b;
  int e;
  int n;
  int s;
  int t;
  int v;
} config;

int parse_params(int argc, char **argv, char *short_options,
                 struct option long_options[], config *conf);

#endif