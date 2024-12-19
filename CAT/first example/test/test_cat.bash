#!/bin/bash

comparison() {
printf "ra" > pattern.txt
touch empty.txt
printf "\n" > empty_string.txt
printf "      " > space.txt
printf "\t\n\t\t" > tabl.txt
printf "Lorem ipsum dolor sit amet, consectetur ad\tipiscing elit. Phasellus fringilla justo vel\n\n\nipsum condimentum, ac volutpat lacus viverra. Sed placerat ultricies neque, sit\namet vulputate metus commodo eget. Cras hendrerit vehicula leo, nec luctus nulla\nconsectetur vitae. Donec vulputate justo at nunc euismod, quis sollicitudin libero\nrutrum."  > test1.txt
printf "Sed non aliquet orci. Vivamus ac convallis lectus. Nam sed \tenim et diam\n\nullamcorper scelerisque. Vestibulum at est auctor, euismod ligula at, convallis\njusto. Quisque vehicula pulvinar ante, nec viverra risus pharetra vitae. Proin ac\nlacinia augue. Pellentesque habitant morbi tristique senectus et netus et\nmalesuada fames ac turpis egestas." > test2.txt
printf "Quisque eget massa nec purus luc\ttus tristique. Proin auctor, dolor in commodo\neleifend, enim urna dictum ipsum, sed scelerisque ex quam vel est.\n\n\n\n\n\n\n\n\n\n\n In hac\nhabitasse platea dictumst. Vivamus tempus mollis justo, sit amet convallis urna\ntempus nec. Etiam eros sapien, rutrum non odio quis, fringilla pharetra odio. Fusce\neuismod congue purus, at sodales massa." > test3.txt
printf "Lorem ipsum dolor sit amet, consectetur adipi\tscing elit. Phasellus fringilla justo vel\n\n\n\nipsum condimentum, ac volutpat lacus viverra. Sed placerat ultricies neque, sit\namet vulputate metus commodo eget. Cras hendrerit vehicula leo, nec luctus nulla\nconsectetur vitae. Donec vulputate justo at nunc euismod, quis sollicitudin libero\nrutrum."  > test4.txt
Myres=$(.././s21_cat $1 2>/dev/null)
Cates=$(cat $1 2>/dev/null)
if [ "$Myres" = "$Cates" ]; then
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
comparison  "test1.txt test2.txt test3.txt test4.txt "   #Test 1
comparison  "-b test1.txt test2.txt test3.txt test4.txt "  #Test 2 -b
comparison  "-e  test1.txt test2.txt test3.txt test4.txt "   #Test 3 -e
comparison  "-n  test1.txt test2.txt test3.txt test4.txt "  #Test 4 -n
comparison  "-s  test1.txt test2.txt test3.txt test4.txt "  #Test 5 -s
comparison  "-n  test1.txt test2.txt test3.txt test4.txt "  #Test 6 -n
comparison  "-t  test1.txt test2.txt test3.txt test4.txt "    #Test 7 -t
comparison  "-b -e test1.txt test2.txt test3.txt test4.txt "   #Test 8 -b -e
comparison  "-b -n test1.txt test2.txt test3.txt test4.txt "   #Test 9 -b -n
comparison  "-b -s test1.txt test2.txt test3.txt test4.txt "    #Test 10 -b -s
comparison  "-b -t test1.txt test2.txt test3.txt test4.txt "    #Test 11 -b -t
comparison  "-e -n test1.txt test2.txt test3.txt test4.txt "    #Test 12 -e -n 
comparison  "-e -s test1.txt test2.txt test3.txt test4.txt "    #Test 13 -e -s 
comparison  "-e -t test1.txt test2.txt test3.txt test4.txt "  #Test 14 -e -t 
comparison  "-n -s test1.txt test2.txt test3.txt test4.txt "  #Test 15 -n -s
comparison  "-n -t test1.txt test2.txt test3.txt test4.txt "  #Test 16 -n -t
comparison  "-s -t test1.txt test2.txt test3.txt test4.txt "  #Test 17 -s -t
comparison  "empty_string.txt"   #Test 18
comparison  "-b empty_string.txt"  #Test 19 -b
comparison  "-e  empty_string.txt"   #Test 20 -e
comparison  "-n  empty_string.txt"  #Test 21 -n
comparison  "-s  empty_string.txt"  #Test 22 -s
comparison  "-n  empty_string.txt"  #Test 23 -n
comparison  "-t  empty_string.txt"    #Test 24 -t
comparison  "space.txt"   #Test 25
comparison  "-b space.txt"  #Test 26 -b
comparison  "-e  space.txt"   #Test 27 -e
comparison  "-n  space.txt"  #Test 28 -n
comparison  "-s  space.txt"  #Test 29 -s
comparison  "-n  space.txt"  #Test 30 -n
comparison  "-t  space.txt"    #Test 31 -t
comparison  "tabl.txt"   #Test 32
comparison  "-b tabl.txt"  #Test 33 -b
comparison  "-e  tabl.txt"   #Test 34 -e
comparison  "-n  tabl.txt"  #Test 35 -n
comparison  "-s  tabl.txt"  #Test 36 -s
comparison  "-n  tabl.txt"  #Test 37 -n
comparison  "-t  tabl.txt"    #Test 38 -t
comparison  "test1.txt"   #Test 39
comparison  "-b test1.txt"  #Test 40 -b
comparison  "-e  test1.txt"   #Test 41 -e
comparison  "-n  test1.txt"  #Test 42 -n
comparison  "-s  test1.txt"  #Test 43 -s
comparison  "-n  test1.txt"  #Test 44 -n
comparison  "-t  test1.txt"    #Test 45 -t
comparison  "-b -e test1.txt"   #Test 46 -b -e
comparison  "-b -n test1.txt"   #Test 47 -b -n
comparison  "-b -s test1.txt"    #Test 48 -b -s
comparison  "-b -t test1.txt"    #Test 49 -b -t
comparison  "-e -n test1.txt"    #Test 50 -e -n 
comparison  "-e -s test1.txt"    #Test 51 -e -s 
comparison  "-e -t test1.txt"  #Test 52 -e -t 
comparison  "-n -s test1.txt"  #Test 53 -n -s
comparison  "-n -t test1.txt"  #Test 54 -n -t
comparison  "-s -t test1.txt"  #Test 55 -s -t
comparison  "-v test1.txt test2.txt test3.txt test4.txt "  #Test 17 -v
comparison  "-v -b test1.txt test2.txt test3.txt test4.txt "  #Test 17 -v
comparison  "-v -e test1.txt test2.txt test3.txt test4.txt "  #Test 17 -v
comparison  "-v -n test1.txt test2.txt test3.txt test4.txt "  #Test 17 -v
comparison  "-v -s test1.txt test2.txt test3.txt test4.txt "  #Test 17 -v
comparison  "-v -t test1.txt test2.txt test3.txt test4.txt "  #Test 17 -v
rm -f *.txt
echo ALL: $counter
echo SUCCESS: $counter_success
echo FAILED: $counter_failed