#!/bin/sh

file="inputs/input.txt"

make all

cat "$file" | ./part_one
cat "$file" | ./part_two
