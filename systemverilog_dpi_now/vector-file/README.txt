1. To run with Nim code

   make

2. To run with the C code

   make clibdpi nc


# Make a New test file by running.
#!/bin/csh -f
foreach a ( 0 1 2 3 4 5 6 7 8 9 )
  foreach b ( 0 1 2 3 4 5 6 7 8 9 )
    @ r = $a * $b
    echo $a $b $r
  end
end
