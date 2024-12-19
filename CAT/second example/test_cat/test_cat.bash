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
Myres=$(./s21_cat $1 2>/dev/null)
Grepres=$(cat $1 2>/dev/null)
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
comparison  "test1.txt test2.txt test3.txt test4.txt "   #Test 1
comparison  "-b test1.txt test2.txt test3.txt test4.txt "  #Test 2 
comparison  "-e test1.txt test2.txt test3.txt test4.txt "  #Test 3 
comparison  "-n test1.txt test2.txt test3.txt test4.txt "  #Test 4 
comparison  "-s test1.txt test2.txt test3.txt test4.txt "  #Test 5 
comparison  "-n test1.txt test2.txt test3.txt test4.txt "  #Test 6 
comparison  "-t test1.txt test2.txt test3.txt test4.txt "  #Test 7 
comparison  "-b -e test1.txt test2.txt test3.txt test4.txt "  #Test 8 
comparison  "-b -n test1.txt test2.txt test3.txt test4.txt "  #Test 9 
comparison  "-b -s test1.txt test2.txt test3.txt test4.txt "  #Test 10 
comparison  "-b -t test1.txt test2.txt test3.txt test4.txt "  #Test 11 
comparison  "-e -n test1.txt test2.txt test3.txt test4.txt "  #Test 12  
comparison  "-e -s test1.txt test2.txt test3.txt test4.txt "  #Test 13 
comparison  "-e -t test1.txt test2.txt test3.txt test4.txt "  #Test 14  
comparison  "-n -s test1.txt test2.txt test3.txt test4.txt "  #Test 15 
comparison  "-n -t test1.txt test2.txt test3.txt test4.txt "  #Test 16 
comparison  "-s -t test1.txt test2.txt test3.txt test4.txt "  #Test 17 
comparison  "empty_string.txt"   #Test 18
comparison  "-b empty_string.txt"  #Test 19 
comparison  "-e empty_string.txt"  #Test 20 
comparison  "-n empty_string.txt"  #Test 21 
comparison  "-s empty_string.txt"  #Test 22 
comparison  "-n empty_string.txt"  #Test 23 
comparison  "-t empty_string.txt"  #Test 24 
comparison  "space.txt"   #Test 25
comparison  "-b space.txt"  #Test 26 
comparison  "-e space.txt"  #Test 27 
comparison  "-n space.txt"  #Test 28 
comparison  "-s space.txt"  #Test 29
comparison  "-n space.txt"  #Test 30 
comparison  "-t space.txt"  #Test 31 
comparison  "tabl.txt"   #Test 32
comparison  "-b tabl.txt"  #Test 33 
comparison  "-e tabl.txt"  #Test 34 
comparison  "-n tabl.txt"  #Test 35 
comparison  "-s tabl.txt"  #Test 36 
comparison  "-n tabl.txt"  #Test 37 
comparison  "-t tabl.txt"  #Test 38 
comparison  "test1.txt"   #Test 39
comparison  "-b test1.txt"  #Test 40 
comparison  "-e test1.txt"  #Test 41 
comparison  "-n test1.txt"  #Test 42 
comparison  "-s test1.txt"  #Test 43 
comparison  "-n test1.txt"  #Test 44 
comparison  "-t test1.txt"    #Test 45 
comparison  "-b -e test1.txt"  #Test 46 
comparison  "-b -n test1.txt"  #Test 47 
comparison  "-b -s test1.txt"  #Test 48 
comparison  "-b -t test1.txt"  #Test 49 
comparison  "-e -n test1.txt"  #Test 50 
comparison  "-e -s test1.txt"  #Test 51  
comparison  "-e -t test1.txt"  #Test 52 
comparison  "-n -s test1.txt"  #Test 53 
comparison  "-n -t test1.txt"  #Test 54 
comparison  "-s -t test1.txt"  #Test 55 
comparison  "-v test1.txt test2.txt test3.txt test4.txt "  #Test 56 
comparison  "-v -b test1.txt test2.txt test3.txt test4.txt "  #Test 57 
comparison  "-v -e test1.txt test2.txt test3.txt test4.txt "  #Test 58 
comparison  "-v -n test1.txt test2.txt test3.txt test4.txt "  #Test 59 
comparison  "-v -s test1.txt test2.txt test3.txt test4.txt "  #Test 60 
comparison  "-v -t test1.txt test2.txt test3.txt test4.txt "  #Test 61 
comparison  "-v byetes.txt"  #Test 62 
comparison  "-v -b byetes.txt"  #Test 63 
comparison  "-v -e byetes.txt"  #Test 64 
comparison  "-v -n byetes.txt"  #Test 65 
comparison  "-v -s byetes.txt"  #Test 66 
comparison  "-v -t byetes.txt"  #Test 67 
# rm -f *.txt
echo ALL: $counter
echo SUCCESS: $counter_success
echo FAILED: $counter_failed