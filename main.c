#include "getopt.h" // содержит в себе две функции , собирает короткие флаги(-) , а так же может собирать длинные(--)
#include "stdio.h"
#include "parce.h"

int main(int argc, char **argv) { // создаем число argc будет показывать нам кол-во строк, затем обращаемся к массиву argv , char** означает, что массив содержит в себе строки 
    config conf = {0}; // присваеваем всем флагам 0
char *short_options = "eEnsTtbv";
 struct option long_options[] = 
    {{"number-nonblank", no_argument, NULL, 'b'},
    {"number", no_argument, NULL, 'n'},
    {"squeeze-blank", no_argument, NULL, 's'}};
    int error = parse_params(argc, argv, short_options, long_options, &conf);
    if (error) {
        return 1;
    }
	return 0;
}