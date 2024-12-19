#!/bin/bash

comparison() {
    printf "ra" > pattern.txt
    touch empty.txt
    printf "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus fringilla justo vel\n\nipsum condimentum, ac volutpat lacus viverra. Sed placerat ultricies neque, sit\namet vulputate metus commodo eget. Cras hendrerit vehicula leo, nec luctus nulla\nconsectetur vitae. Donec vulputate justo at nunc euismod, quis sollicitudin libero\nrutrum."  > test1.txt
    printf "Sed non aliquet orci. Vivamus ac convallis lectus. Nam sed enim et diam\nullamcorper scelerisque. Vestibulum at est auctor, euismod ligula at, convallis\njusto. Quisque vehicula pulvinar ante, nec viverra risus pharetra vitae. Proin ac\nlacinia augue. Pellentesque habitant morbi tristique senectus et netus et\nmalesuada fames ac turpis egestas." > test2.txt
    printf "Quisque eget massa nec purus luctus tristique. Proin auctor, dolor in commodo\neleifend, enim urna dictum ipsum, sed scelerisque ex quam vel est. In hac\nhabitasse platea dictumst. Vivamus tempus mollis justo, sit amet convallis urna\ntempus nec. Etiam eros sapien, rutrum non odio quis, fringilla pharetra odio. Fusce\neuismod congue purus, at sodales massa." > test3.txt
    printf "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus fringilla justo vel\n\nipsum condimentum, ac volutpat lacus viverra. Sed placerat ultricies neque, sit\namet vulputate metus commodo eget. Cras hendrerit vehicula leo, nec luctus nulla\nconsectetur vitae. Donec vulputate justo at nunc euismod, quis sollicitudin libero\nrutrum."  > test4.txt
    Myres=$(./s21_grep $1 2>/dev/null)
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
comparison  "-e met -e eget test1.txt test2.txt test3.txt test4.txt"  #Test 8 -e
comparison  "-e met -eeget test1.txt test2.txt test3.txt test4.txt"  #Test 9 -e
comparison  "-emet -e eget test1.txt test2.txt test3.txt test4.txt"  #Test 10 -e
comparison  "-emet -eeget test1.txt test2.txt test3.txt test4.txt"  #Test 11 -e
comparison  "test nonexistent_file.txt"  #Test 12 non-file
comparison  "-e \"\" test1.txt"  #Test 13 emty result
comparison  "-e \"(\" test1.txt" #Test 14
comparison  "^pattern$ test1.txt" #Test 15
comparison  "ve test1.txt"   #Test 16
comparison  "Ve test1.txt"  #Test 17
comparison  "-i ve test1.txt"   #Test 18
comparison  "-i ve test2.txt"   #Test 19
comparison  "-i ve test3.txt"   #Test 20
comparison  "-i ve test4.txt"   #Test 21
comparison  "-v ve test1.txt"   #Test 22
comparison  "-v ve test2.txt"   #Test 23
comparison  "-v ve test3.txt"   #Test 24
comparison  "-v ve test4.txt"   #Test 25
comparison  "-c ve test1.txt"   #Test 26
comparison  "-c ve test2.txt"   #Test 27
comparison  "-c ve test3.txt"   #Test 28
comparison  "-c ve test4.txt"   #Test 29
comparison  "-n ve test1.txt"   #Test 30
comparison  "-n ve test2.txt"   #Test 31
comparison  "-n ve test3.txt"   #Test 32
comparison  "-n ve test4.txt"   #Test 33
comparison  "-l ve test4.txt"   #Test 34
comparison  "-l ve test4.txt"   #Test 35
comparison  "-l ve test4.txt"   #Test 36
comparison  "-l ve test4.txt"   #Test 37

rm -f test*.txt pattern.txt empty.txt
echo ALL: $counter
echo SUCCESS: $counter_success
echo FAILED: $counter_failed