#!/bin/bash
## graphtest.sh -- by Patsie
# Draw a graph using an ASCII graph function
# The graph will have a width equal to the number of data points
# and a height equal to the first argument
# Usage: graphtest.sh

## Should the graph move from right to left or vice versa
right_to_left=1

## include graphing function
. ./graph.fnc


## starting value, fill graph data
val=100000
data=$(for i in {1..60}; do echo $((val+=RANDOM%1000-500)); done)

i=0
clear

## repeat 500 times
for i in {1..500}; do
  ## Go to top left corner and print date
  echo -e "\e[H$(date)\n"

  ## Add new datapoint to graph
  ((val+=RANDOM%1000-500))
  if [ $right_to_left -eq 1 ]; then
    data=$(echo $data $val | cut -d' ' -f2-61)
  else
    data=$(echo $val $data | cut -d' ' -f1-60)
  fi

  ## Draw graph and wait
  graph 9 $data
  sleep 0.2
done

