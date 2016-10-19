#!/bin/bash
#script collects data from iostat

#folder that contains collected data
SOURCE_DATA=/tmp/iostat/iostat.out

iostat -kx 3 2 > $SOURCE_DATA
echo 0