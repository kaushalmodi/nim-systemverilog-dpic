# -------------------------------------------------------
# ZLIB Source code
http://www.gzip.org/zlib/

# -------------------------------------------------------
# Setup

# Point at the MTI_HOME installation area.
setenv MTI_HOME  ....

# Add vco, vsim, vlog, etc to the path
set path = ( $MTI_HOME/modeltech $path )

# -------------------------------------------------------
# Configure and build

# We need to build a libz.so that we'll load.
make tools

make

make clean



# Make a New test file by running.
#!/bin/csh -f
foreach a ( 0 1 2 3 4 5 6 7 8 9 )
  foreach b ( 0 1 2 3 4 5 6 7 8 9 )
    @ r = $a * $b
    echo $a $b $r
  end
end

