#!/bin/bash

#File Variables
INPUT_FILE="staff_directory.csv"
OUTPUT_FILE="users.ldif"

#Department to GID Mapping
declare -A DEPARTMENT_TO_GID=(
    ["Veterinary"]=1000
    ["Research_Education"]=1001
    ["Animal_Care"]=1002
    ["Executives"]=1003
    ["Management"]=1004
    ["IT"]=1005
    ["Maintenance"]=1006
    ["Guest_Services"]=1007
    ["Security"]=1008
    ["Volunteers"]=1009  
)

#Initialise base UID
base_uid=2000

#Check if the INPUT_FILE exists
if [[ ! -f "$INPUT_FILE" ]]; then
    echo "Error: Input File '$INPUT_FILE' not found."
    exit 1
fi 

#clears output file
> "$OUTPUT_FILE"

#skips the first line of the csv file and starts reading from there
tail -n +2 "$INPUT_FILE" | while IFS=',' read -r full_name username department birthday age pronouns; do
# for processing the csv file do the names of the fields in each csv row have to match whats in the actual file?

    #Extract First and Last Names (splits the full_name into first and last names )
    first_name=$(echo "$full_name" | awk '{print $1}' ) #extracts the first word from full_name
    last_name=$(echo "$full_name" | awk '{print $2}' ) #extracts the second word from full_name

    # Default last_name to empty if not provided
    if [[ -z "$last_name" ]]; then
        last_name="N/A"
    fi

    #determine the GID for the Department
    gid=${DEPARTMENT_TO_GID[$department]:-9999} #looks up the GID for the department or assigns the default GID 9999 if the Department isnt found

    #assign and Incriment UID number
    uid_number=$((base_uid++))

    #define home directories
    home_directory="/home/$username"

    #Genate temporary password (to be refined)
    temp_password="${username}@$(echo "$birthday" | tr -d '-')"

    #Write LDIF Entry
    cat <<EOF >> "$OUTPUT_FILE"
dn: uid=$username,ou=users,dc=zoo
objectClass: inetOrgPerson
objectClass: posixAccount
objectClass: top
cn: $full_name
sn: $last_name
givenName: $first_name
uid: $username
uidNumber: $uid_number
gidNumber: $gid
homeDirectory: $home_directory
userPassword: $temp_password
description: Birthday: $birthday, Pronouns: $pronouns

EOF
done

echo "LDIF file '$OUTPUT_FILE' created successfully."