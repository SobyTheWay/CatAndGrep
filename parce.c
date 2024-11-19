#include <parse.h>

#include <getopt.h>

int parse_params(int argc, char **argv, char *short_options,
                    struct option long_options[], config *conf) {

                    int res ;
                    int error = 0 ;    
                    int idx = 0 ;

while ((res = getopt_long(argc, argv, short_options, long_options, &idx)) != -1){
    switch (res) {
        case 'b':
            conf->b = 1;
        break;
        case 'e':
        conf->e = 1;
        conf->v = 1;
    break;
    case 'E':
    conf->e = 1;
    break;
    case 'n':
    conf->n = 1;
    break;
    case 's':
    conf->s = 1;
    break;
    case 't':
    conf->t = 1;
    conf->v = 1;
    break;
    case '?':
    error = 1 ;
    break;
    default:
    error = 1;
    break;
    }
}

if (error) {
    return 1;
}
    return 0 ;
                    }