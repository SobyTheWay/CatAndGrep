#!/bin/bash

comparison() {
    printf "ra" > pattern.txt
    touch empty.txt
    printf "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus fringilla justo vel\n\nipsum condimentum, ac volutpat lacus viverra. Sed placerat ultricies neque, sit\namet vulputate metus commodo eget. Cras hendrerit vehicula leo, nec luctus nulla\nconsectetur vitae. Donec vulputate justo at nunc euismod, quis sollicitudin libero\nrutrum."  > test1.txt
    printf "Sed non aliquet orci. Vivamus ac convallis lectus. Nam sed enim et diam\nullamcorper scelerisque. Vestibulum at est auctor, euismod ligula at, convallis\njusto. Quisque vehicula pulvinar ante, nec viverra risus pharetra vitae. Proin ac\nlacinia augue. Pellentesque habitant morbi tristique senectus et netus et\nmalesuada fames ac turpis egestas." > test2.txt
    printf "Quisque eget massa nec purus luctus tristique. Proin auctor, dolor in commodo\neleifend, enim urna dictum ipsum, sed scelerisque ex quam vel est. In hac\nhabitasse platea dictumst. Vivamus tempus mollis justo, sit amet convallis urna\ntempus nec. Etiam eros sapien, rutrum non odio quis, fringilla pharetra odio. Fusce\neuismod congue purus, at sodales massa." > test3.txt
    printf "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus fringilla justo vel\n\nipsum condimentum, ac volutpat lacus viverra. Sed placerat ultricies neque, sit\namet vulputate metus commodo eget. Cras hendrerit vehicula leo, nec luctus nulla\nconsectetur vitae. Donec vulputate justo at nunc euismod, quis sollicitudin libero\nrutrum."  > test4.txt
    Myres=$(.././s21_grep $1 2>/dev/null)
    Grepres=$(grep $1 2>/dev/null)
    if [ "$Myres" = "$Grepres" ]; then
        ((counter_success++))
    else
        ((counter_failed++))
        echo FAIL: $1
    fi
    ((counter++))
}

counter=0
counter_success=0
counter_failed=0
comparison  "ve test1.txt test2.txt test3.txt test4.txt"   #Test 1
comparison  "Ve test1.txt test2.txt test3.txt test4.txt"  #Test 2
comparison  "-i ve test1.txt test2.txt test3.txt test4.txt"   #Test 3 -i
comparison  "-v as test1.txt test2.txt test3.txt test4.txt"  #Test 4 -v
comparison  "-c massa test1.txt test2.txt test3.txt test4.txt"  #Test 5 -c
comparison  "-n massa test1.txt test2.txt test3.txt test4.txt"  #Test 6 -n
comparison  "-l ipsum  test1.txt test2.txt test3.txt test4.txt"    #Test 7 -l
comparison  "-h ac test1.txt test2.txt test3.txt test4.txt"   #Test 8 -h
comparison  "-s hello nonexistent_file.txt"  #Test 9 -s
comparison  "-o jus test1.txt test2.txt test3.txt test4.txt"  #Test 10 -o
comparison  "-e met -e eget test1.txt test2.txt test3.txt test4.txt"  #Test 11 -e
#comparison  "test nonexistent_file.txt"  #Test 12 non-file
comparison  "-f pattern.txt test1.txt test2.txt test3.txt test4.txt"  #Test 13 -f
comparison  "-o -f pattern.txt test1.txt test2.txt test3.txt test4.txt"  #Test 14 -f -o
comparison  "-i -v ve test1.txt test2.txt test3.txt test4.txt"  #Test 15 -i -v
comparison  "-i -c ve test1.txt test2.txt test3.txt test4.txt"  #Test 16 -i -c
comparison  "-i -e ve -e Rr test1.txt test2.txt test3.txt test4.txt"  #Test 17 -i -e
comparison  "-i -l ve  test1.txt test2.txt test3.txt test4.txt"  #Test 18 -i -l
comparison  "-i -n ve  test1.txt test2.txt test3.txt test4.txt"  #Test 19 -i -n
comparison  "-i -s ve  test1.txt test2.txt test3.txt test4.txt"  #Test 20 -i -s
comparison  "-i -h ve  test1.txt test2.txt test3.txt test4.txt"  #Test 21 -i -h
comparison  "-i -f pattern.txt  test1.txt test2.txt test3.txt test4.txt"  #Test 22 -i -f
comparison  "-i -o ve  test1.txt test2.txt test3.txt test4.txt"  #Test 23 -i -o
comparison  "-e ve -e rr -v test1.txt test2.txt test3.txt test4.txt"  #Test 24 -e -v
comparison  "-e ve -e rr -c test1.txt test2.txt test3.txt test4.txt"  #Test 25 -e -c
comparison  "-e ve -e rr -l test1.txt test2.txt test3.txt test4.txt"  #Test 26 -e -l
comparison  "-e ve -e rr -n test1.txt test2.txt test3.txt test4.txt"  #Test 27 -e -n
comparison  "-e ve -e rr -s test1.txt test2.txt test3.txt test4.txt"  #Test 28 -e -s
comparison  "-e ve -e rr -h test1.txt test2.txt test3.txt test4.txt"  #Test 29 -e -h
comparison  "-e ve -e rr -f pattern.txt test1.txt test2.txt test3.txt test4.txt"  #Test 30 -e -f
comparison  "-e ve -e rr -o test1.txt test2.txt test3.txt test4.txt"  #Test 31 -e -o
comparison  "-v -c ve test1.txt test2.txt test3.txt test4.txt"  #Test 32 -v -c
comparison  "-v -l ve test1.txt test2.txt test3.txt test4.txt"  #Test 33 -v -l
comparison  "-v -n ve test1.txt test2.txt test3.txt test4.txt"  #Test 34 -v -n
comparison  "-v -s ve test1.txt test2.txt test3.txt test4.txt"  #Test 35 -v -s
comparison  "-v -h ve test1.txt test2.txt test3.txt test4.txt"  #Test 36 -v -h
comparison  "-v -f pattern.txt test1.txt test2.txt test3.txt test4.txt"  #Test 37 -v -f
comparison  "-c -l ve test1.txt test2.txt test3.txt test4.txt"  #Test 39 -c -l
comparison  "-c -n ve test1.txt test2.txt test3.txt test4.txt"  #Test 40 -c -n
comparison  "-c -s ve test1.txt test2.txt test3.txt test4.txt"  #Test 41 -c -s
comparison  "-c -h ve test1.txt test2.txt test3.txt test4.txt"  #Test 42 -c -h
comparison  "-c -f pattern.txt test1.txt test2.txt test3.txt test4.txt"  #Test 43 -c -f
comparison  "-c -o ve test1.txt test2.txt test3.txt test4.txt"  #Test 44 -c -o
comparison  "-l -n ve test1.txt test2.txt test3.txt test4.txt"  #Test 45 -l -n
comparison  "-l -s ve test1.txt test2.txt test3.txt test4.txt"  #Test 46 -l -s
comparison  "-l -h ve test1.txt test2.txt test3.txt test4.txt"  #Test 47 -l -h
comparison  "-l -f pattern.txt test1.txt test2.txt test3.txt test4.txt"  #Test 48 -l -f
comparison  "-l -o ve test1.txt test2.txt test3.txt test4.txt"  #Test 49 -l -o
comparison  "-n -s ve test1.txt test2.txt test3.txt test4.txt"  #Test 50 -n -s
comparison  "-n -h ve test1.txt test2.txt test3.txt test4.txt"  #Test 51 -n -h
comparison  "-n -f pattern.txt test1.txt test2.txt test3.txt test4.txt"  #Test 52 -n -f
comparison  "-n -o ve test1.txt test2.txt test3.txt test4.txt"  #Test 53 -n -o
comparison  "-s -h ve test1.txt test2.txt test3.txt test4.txt"  #Test 54 -s -h
comparison  "-s -f pattern.txt test1.txt test2.txt test3.txt test4.txt"  #Test 55 -s -f
comparison  "-s -o ve test1.txt test2.txt test3.txt test4.txt"  #Test 56 -s -o
comparison  "-h -f pattern.txt test1.txt test2.txt test3.txt test4.txt"  #Test 57 -h -f
comparison  "-h -o ve test1.txt test2.txt test3.txt test4.txt"  #Test 58 -h -o
comparison  "-o -f pattern.txt test1.txt test2.txt test3.txt test4.txt"  #Test 59 -f -o
comparison  "Rr test1.txt test2.txt test3.txt test4.txt"  #Test 60 empty result
comparison  "-e \"\" test1.txt"  #Test 61 emty result
comparison  "-f empty.txt test1.txt test2.txt test3.txt test4.txt"  #Test 62 empty pattern file
#comparison  "-f non_existent_patterns_file.txt test1.txt" #Test 63 non pattern file
comparison  "-e \"(\" test1.txt" #Test 64
comparison  "-o "nonexistent_pattern" test1.txt" #Test 65 empty result wih -o flag
comparison  "^pattern$ test1.txt" #Test 66 
comparison  "ve test1.txt"   #Test 67
comparison  "Ve test1.txt"  #Test 68
comparison  "-i ve test1.txt"   #Test 69 -i
comparison  "-v as test1.txt"  #Test 70 -v
comparison  "-c massa test3.txt"  #Test 71 -c
comparison  "-n massa test3.txt"  #Test 72 -n
comparison  "-l ipsum  test1.txt"    #Test 73 -l
comparison  "-h ac test1.txt"   #Test 74 -h
comparison  "-o jus test1.txt"  #Test 75 -o
comparison  "-e met -e eget test1.txt"  #Test 76 -e
comparison  "-f pattern.txt test1.txt"  #Test 77 -f
comparison  "-o -f pattern.txt test1.txt"  #Test 78 -f -o
comparison  "-i -v ve test1.txt"  #Test 79 -i -v
comparison  "-i -c ve test1.txt"  #Test 80 -i -c
comparison  "-i -e ve -e Rr test1.txt"  #Test 81 -i -e
comparison  "-i -l ve  test1.txt"  #Test 82 -i -l
comparison  "-i -n ve  test1.txt"  #Test 83 -i -n
comparison  "-i -s ve  test1.txt"  #Test 84 -i -s
comparison  "-i -h ve  test1.txt"  #Test 85 -i -h
comparison  "-i -f pattern.txt  test1.txt"  #Test 86 -i -f
comparison  "-i -o ve  test1.txt"  #Test 87 -i -o
comparison  "-e ve -e rr -v test1.txt"  #Test 88 -e -v
comparison  "-e ve -e rr -c test1.txt"  #Test 89 -e -c
comparison  "-e ve -e rr -l test1.txt"  #Test 90 -e -l
comparison  "-e ve -e rr -n test1.txt"  #Test 91 -e -n
comparison  "-e ve -e rr -s test1.txt"  #Test 92 -e -s
comparison  "-e ve -e rr -h test1.txt"  #Test 93 -e -h
comparison  "-e ve -e rr -f pattern.txt test1.txt"  #Test 94 -e -f
comparison  "-e ve -e rr -o test1.txt"  #Test 95 -e -o
comparison  "-v -c ve test1.txt"  #Test 96 -v -c
comparison  "-v -l ve test1.txt "  #Test 97 -v -l
comparison  "-v -n ve test1.txt"  #Test 98 -v -n
comparison  "-v -s ve test1.txt"  #Test 99 -v -s
comparison  "-v -h ve test1.txt"  #Test 100 -v -h
comparison  "-v -f pattern.txt test1.txt"  #Test 101 -v -f
comparison  "-c -l ve test1.txt"  #Test 103 -c -l
comparison  "-c -n ve test1.txt"  #Test 104 -c -n
comparison  "-c -s ve test1.txt"  #Test 105 -c -s
comparison  "-c -h ve test1.txt"  #Test 106 -c -h
comparison  "-c -f pattern.txt test1.txt"  #Test 107 -c -f
comparison  "-c -o ve test1.txt "  #Test 108 -c -o
comparison  "-l -n ve test1.txt "  #Test 109 -l -n
comparison  "-l -s ve test1.txt "  #Test 110 -l -s
comparison  "-l -h ve test1.txt "  #Test 111 -l -h
comparison  "-l -f pattern.txt test1.txt "  #Test 112 -l -f
comparison  "-l -o ve test1.txt"  #Test 113 -l -o
comparison  "-n -s ve test1.txt "  #Test 114 -n -s
comparison  "-n -h ve test1.txt "  #Test 115 -n -h
comparison  "-n -f pattern.txt test1.txt "  #Test 116 -n -f
comparison  "-n -o ve test1.txt "  #Test 117 -n -o
comparison  "-s -h ve test1.txt "  #Test 118 -s -h
comparison  "-s -f pattern.txt test1.txt "  #Test 119 -s -f
comparison  "-s -o ve test1.txt "  #Test 120 -s -o
comparison  "-h -f pattern.txt test1.txt "  #Test 121 -h -f
comparison  "-h -o ve test1.txt "  #Test 122 -h -o
comparison  "-o -f pattern.txt test1.txt "  #Test 123 -f -o
rm -f test*.txt pattern.txt empty.txt
echo ALL: $counter
echo SUCCESS: $counter_success
echo FAILED: $counter_failed