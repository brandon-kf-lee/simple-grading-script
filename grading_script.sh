#!/bin/bash

#############################################################################################
# grading_script.sh                                                                         #
# Bash script to automate grading for CPSC 350 as much as possible. Takes in name of        #
# section & professor and loops through entire directory and unzips each submission into    #
# a temporary directory                                                                     #
#                                                                                           #
# This file must be in the parent directory of all the other files (like the temporary      #
# directory & assignments directory). The desired grader input file must be in inside its   #
# appropriate assignment directory                                                          #
#                                                                                           #
# author: Brandon Lee                                                                       #
#                                                                                           #
# 09/23/2023 Modified from grading_script_h8.sh (CENG 231/L)                                #
# 12/22/2023 Added QoL improvements: auto compiling, auto grader input file insertion,      # 
#                                    better command line handling                           #
#############################################################################################

#--------------------------------------Variables--------------------------------------
HWDIR=''    #[a]ssignment number
INP=''      #desired [c]ommand line inputs when running student code
GRADIN=''   #[g]rader input file name
START='0'   #start [p]oint
SECTION=''  #[s]ection number (also the same name as the dir. holding the section's submissions)

#--------------------------------------Functions--------------------------------------
#Prints available flags to make script work
#parameters: none
#returns: none
printUsage(){
  echo "Usage: $(basename "$0") -a <HWDIR> -s <SECTION> [-g <GRADIN>] [-c \"<INP>\"] [-p <START>] [-h]"
  echo "Options:"
  echo "  -a <HWDIR>     Specify a relative path to the homework directory."
  echo "  -s <SECTION>   Specify the class section's directory name within <HWDIR>."
  echo "  -g <GRADIN>    (Optional) Specify the grader's input file name."
  echo "  -c <INP>       (Optional) Specify any desired command line inputs when running student code."
  echo "                 Note: These inputs will be the student's executable's commandline arguments."
  echo "  -p <START>     (Optional) Specify the starting point for processing files (processes alphabetically)."
  echo "                 Note: Program will start at the beginning of the directory if p is not set."
  echo "  -h             Display this help message."
  echo ""
  echo "Example: $(basename "$0") -a ../A1 -s 01-Stevens -g input.txt -c \"input.txt\" -p doejohn"
  echo "         $(basename "$0") -a ../A5 -s 02-Linstead"

}

#The simple compile command to compile a student's assignment
#parameters: $1: the student's directory
#returns: none
compile(){
  cp ./$HWDIR/$GRADIN $1           #Copy grader input file into the student's dir.
  g++ $dir/*.cpp -o $1/output.out  #Assume all .cpp files must be compiled together
}

#--------------------------------------Main script--------------------------------------
#Automatically print usage if no flags given
if [ $# -eq 0 ]; then
  printUsage
  exit 0
fi

#a - [a]ssignment number
#c - desired [c]ommand line inputs when running student code
#g - [g]rader input file name
#h - [h]elp
#p - start [p]oint
#s - [s]ection number (also the same name as the dir. holding the section's submissions)
while getopts 'a:c:g:hp:s:' flag; do
  case "$flag" in
    a) HWDIR="${OPTARG}" ;;
    c) INP="${OPTARG}" ;;
    g) GRADIN="${OPTARG}" ;;
    h) printUsage
       exit 0 ;;
    p) START="${OPTARG}" ;;
    s) SECTION="${OPTARG}" ;;
  esac
done

#Create a temporary dir. called GradingBuffer (and discard error msg. if "GradingBuffer" already exists)
mkdir ./GradingBuffer > /dev/null 2>&1
TEMPDIR="./GradingBuffer"

#Loop through each student's submission
startProcessing=false
for file in ./$HWDIR/$SECTION/*; do
  
  #If the flag is set, loop through the dir. until the given student is found
  if [ "$startProcessing" != true ]; then
    if [ $START != '0' ]; then
      if [[ $(basename $file) != $START* ]]; then  #i.e doejohn_foo_bar.zip = doejohn, so doejohn's file was found
        continue
      else
        startProcessing=true
      fi
    fi
  fi

  rm -r --interactive=never $TEMPDIR/*       #Remove all, do not ask about removing write-protected files
  unzip $file -d $TEMPDIR

  echo "------------------------------------------------------------"
  echo "ZIP file name: $file"
  echo "------------------------------------------------------------"

  #Find the dir. that holds code (students may have their code in a folder inside the unzipped folder)
  #Breakdown: finds a file (-type f) by finding the word "main" inside any of the files using grep (-exec grep)
  #           grep will find the file (-l) that contains "int main" or (-e) "void main" on the current file being 
  #           processed by find ({}) while supressing output (-q)
  #           send the output to xargs (-print and |) to get the file's parent (dirname) and quit after the first hit (-quit)
  dir=$(find $TEMPDIR -type f -exec grep -l -q -e "int main" -e "void main" {} \; -print -quit | xargs dirname)

  if [ -n "$dir" ]; then
    compile $dir

    if [ -e $dir/output.out ]; then
      #Pop to student's dir., run, then return to original dir (while supressing output of popd).
      #This is necessary to simulate how a student would run their progarm (running with input file in 
      #the same dir., keeping all output files contained in the same dir.)
      pushd $dir ; ./output.out $INP ; popd > /dev/null
    else
      echo "Uncompilable or does not exist. Exiting."
      exit 1
    fi
    
  else
    echo "main method not found, check folder if there is any code. Exiting."
    exit 1
  fi

  echo "--------------------------------------------------"
  echo "Student complete: Press return to continue"
  echo "--------------------------------------------------"
  read cont

done

if [ "$startProcessing" != true ]; then
  if [ $START != '0' ]; then
      echo "Entire directory traversed without finding the desired student. Please check the spelling."
  fi
fi
