#!/bin/bash
## graph.fnc -- by Patsie
# Shell function that draws a graph with average line in ASCII
# The graph will have a width equal to the number of data points
# and a height equal to the first argument
# Usage: graph <height> <val1> [<val2> [<...>]]

function graph {
  height="$1"; shift

  echo "$@" | awk -v height="$height" 'BEGIN {
#    bar = ".oO"
    bar = "▁▂▃▄▅▆▇█"
    barlen = length(bar)
  }
    ## convert big numbers to short kilo/mega/giga etc numbers
    function pow1k(bignum) {
      metric = 1;
      num = bignum;

      # devide by 1000 until we have got a small enough number
      while (num >= 1000) { metric++; num /= 1000; }
      num = int(num);

      # get SI prefix (kilo, mega, giga, tera, peta, exa, zotta, yotta)
      si = substr(" KMGTPEZY", metric, 1);

      # get a division remainder to total our number of characters to a maximum of 4
      division = substr(bignum, length(num)+1, 3-length(num));

      # right align the output
      str = sprintf("%s%c%s", num, si, division);
      return(sprintf("% 4s", str));
    }
  {
    # get smallest, largest and total of all numbers
    min = max = tot = $1;
    for (x=2; x<=NF; x++) { tot += $x; if ($x>max) max = $x; if ($x<min) min = $x; }

    # the difference between largest and smallest number is out working area
    diff = max-min;
    if (diff == 0) diff = 1;                            # all numbers are the same?!

    # some math to get the average of all numbers
    avg = (tot/NF);
    avgfull = int(((avg-min)*height/diff));             # average full
    avghalf = int(((avg-min)*height/diff)%1+0.5);       # average half

    # fill arrays bars
    for (x=1; x<=NF; x++) {
      v = $x-min;                                       # our value
      i = 0; array[x] = "";                             # blank the array
      full = int((v*height/diff));                      # full bars
      while (i<full) { array[x] = array[x]substr(bar,barlen,1); i++; } # fill fulls
      rest = int((v*height/diff)%1*barlen)              # plus rest
      if (rest>0) { array[x] = array[x]substr(bar,rest,1); i++; }

      # average line or blank
      while (i < height) {                              # fill to the top
        if (i == avgfull)                               # with average line
          if (avghalf > 0) array[x] = array[x]"─";
          else array[x] = array[x]"_";
        else array[x] = array[x]" ";                    # or mostly blanks
        i++;
      }
    }

    # display output
    for (y=height; y>0; y--) {
      line = ""; num = "    ";                          # blank line and number
      if (y == avgfull+1) num = pow1k(int(avg));        # show average number
      if (y == height)    num = pow1k(max);             # show maximum number
      if (y == 1)         num = pow1k(min);             # show minimum number

      for (x=1; x<=NF; x++)                             # do for all data values
        line = line""substr(array[x],y,1);              # create line from arrays
      printf(" %s | %s | %s\n", num, line, num);        # display 1 line
    }
  }'
}

