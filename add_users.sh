#!/bin/bash

#File Variables
INPUT_FILE= "staff directory"
OUTPUT_FILE= "users.ldif"

#Department to GID Mapping

declare -A DEPARTMENT_TO_GID = (
    ["Veterinary"] = 1000
    ["Reasearch_Education"] = 1001
    ["Animal_Care"] = 1002
    ["Executives"] = 1003
    ["Management"] = 1004
    ["IT"] = 1005
    ["Maintenance"] = 1006
    ["Guest_Services"] = 1007
    ["Security"] = 1008
    ["Volunteers"] = 1009  
)

#Check if the INPUT_FILE exists
if [[! -f "$INPUT_FILE"]]; then
    echo "Error: Input File '$INPUT_FILE' not found."
    exit 1
fi 

> "$OUTPUT_FILE"
#skips the first line of the csv file and starts reading from there
tail -n +2 "$INPUT_FILE" | while IFS=',' read -r Full Name Username Department Birthday Age Pronouns; do
# for processing the csv file do the names of the fields in each csv row have to match whats in the actual file?

#Extract First and Last Names (splits the full_name into first and last names )
first_name=$(echo "$full_name" | awk '{print $1}' ) #extracts the first word from full_name
last_name=$(echo "$full_name" | awk '{print $1}' ) #extracts the second word from full_name

#determine the GID for the Department
gid=${DEPARTMENT_TO_GID[$department]: -9999} #looks up the GID for the department or assigns the default GID 9999 if the Department isnt found

#generate UID number


#define home directories
home_directory="/home/$username"

#Write LDIF Entry

cat <<EOf >> "$OUTPUT_FILE"