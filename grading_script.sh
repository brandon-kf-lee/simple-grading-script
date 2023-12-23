#!/bin/bash

###########################################################################################
# grading_script.sh                                                                       #
# Bash script to automate grading for CPSC 350 as much as possible. Takes in name of      #
# section & professor and loops through entire directory and unzips each submission into  #
# a temporary folder                                                                      #
#                                                                                         #
# author: Brandon Lee                                                                     #
#                                                                                         #
# 09/23/2023 Modified from grading_script_h8.sh (CENG 231/L)                              #
###########################################################################################


#Command Line Arguments
HW=$1
SECTION=$2
# TODO: Not working
start_ind=$3 #Used to start at a specific student index based on the excel sheet row number (student's position on the excel sheet is ["students" index + 2])

HWDIR="./$HW/$SECTION"               #Path to hw solution dir.
TEMPDIR="./GradingBuffer"

#Allows for no command line arguments (defaults to first student on list)
if [ $# -lt 1 ]; then
  start_ind=0
elif [ $# -lt 2 ]; then
  let start_ind=$3-2
fi

i=$start_ind
#Loop for each student
for file in $HWDIR/*; do

  let "row=$i+2"         #Row on excel sheet
  i=$i+1

  rm -r $TEMPDIR/*
  unzip $file -d $TEMPDIR

  echo "------------------------------------------------------------"
  echo "ZIP file name: $file, row $row"
  echo "(Desired convention: LastName_FirstInitial_$HW.zip)"
  echo "------------------------------------------------------------"

  #View .txt file before compile
#  less $REPO/$stud/hw$HW/README

  #Compile & run program
#  dir=$REPO/$stud/hw$HW                                     #Path to executable



#  gcc -c -g -ansi -Wall $dir/Image.c -o $dir/Image.o           #Compile
#  gcc -c -g -ansi -Wall $dir/PhotoLab_server.c -o $dir/PhotoLab_server.o
#  gcc $dir/PhotoLab_server.o $dir/Image.o -o $dir/PhotoLab_server

#  gcc -g -ansi -Wall $dir/PhotoLab_client.c -o $dir/PhotoLab_client

#  if [ -e $program ]; then
#    cd $REPO/$stud/hw$HW ; valgrind --leak-check=full ./$NAME
#    cd $REPO/$stud/hw$HW ; ./$NAME\_server
    echo "--------------------------------------------------"
    echo "Unzip completed: Press return to continue"
    echo "--------------------------------------------------"
    read cont
#  else
#    echo "$stud's $NAME.c uncompilable or does not exist, exiting."
#    exit
#  fi

done

