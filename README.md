# simple-grading-script

## Information
Author: Brandon Lee\
Contact: brandon.kf.lee@gmail.com\
         bellee@chapman.edu\
Version 2.0

This is a simple Bash script to automate grading programming assignments as much as possible. It simply unzips student programming assignments and compiles them for evaluation. It is optimized for grading for Chapman University's CPSC 350 Data Structures and Algorithms, but should work if your setup is the same or similar. A sample file structure is provided to show how I used this script.

### Structure
Each assignment is separated into folders with subfolders within that separate by class section (i.e A1/01-Stevens/). Each subfolder then holds the zip files that contains every student's submission (i.e A1/01-Stevens/doejohn_A1.zip)

### Limitations
The script assumes that the assignment has all required files within a single folder and will be compiled together.\
Have only tested the -p option with student zip files formatted with names ordered alphabetically, as bulk downloaded through Canvas.\
Each student must have a main method declared as "void main" or "int main", may error out if the main method is declared differently.\

### Notes
If needed the grader's input file can be copied from the appropriate assignment directory into the current student's temporary directory. See usage for more information.

### Usage
grading_script.sh -a \<HWDIR\> -s \<SECTION\> [-g \<GRADIN\>] [-c \"\<INP\>\"] [-p \<START\>] [-h]"\
Options:
  -a \<HWDIR\>     Specify a relative path to the homework directory.\
  -s \<SECTION\>   Specify the class section's directory name within \<HWDIR\>.\
  -g \<GRADIN\>    (Optional) Specify the grader's input file name.\
  -c \<INP\>       (Optional) Specify any desired command line inputs when running student code.\
                 Note: These inputs will be the student's executable's commandline arguments.\
  -p \<START\>     (Optional) Specify the starting point for processing files (processes alphabetically).\
                 Note: Program will start at the beginning of the directory if p is not set.\
  -h             Display this help message.\

Example: grading_script.sh -a ../A1 -s 01-Stevens -g input.txt -c \"input.txt\" -p doejohn\
         grading_script.sh -a ../A5 -s 02-Linstead\