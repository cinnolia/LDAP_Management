#!bin/bash

if ["$#" -ne 1]; then
    echo "Usage: $0 <group_names.txt>"
    exit 1
fi

GROUP_LIST=$1   #assigns the input file name to the variable GROUP_LIST

if [ ! -f "$GROUP_LIST" ]; then #Checks that the file exists, if it doesn't then:
    echo "File not found: $GROUP_LIST"  #Prints an error message
    exit 1
fi

GID_BASE=1001   #sets the starting point gor generating GIDs
LDIF_FILE="groups.ldif"  #defines the name of the LDIF file to be created

while IFS= read -r group_name   #loop over each group name (-r tells read not to not treat backslashes as escape characters(?))
do
    if [ -z "$group_name" ] || [["$group_name" =~ ^#]]; then    #skips empty lines or lines starting with a comment
        continue    #if either option is true, skips to the next line, ignoring empty or commented lines
    fi

    GID=$((GID_BASE))   #assigns the current value of GID_BASE to the GID
    GID_BASE=$((GID_BASE + 1))  #Increments the GID for the next group

    echo "dn: cn=$group_name,ou=groups,dc=zoo" >> $LDIF_FILE
    echo "objectClass: top" >>$LDIF_FILE    #what does this line mean? might not be meant to be here do check
    echo "objectClass: posixGroup" >>$LDIF_FILE
    echo "cn: $group_name" >>$LDIF_FILE
    echo "gidNumber: $GID" >>$LDIF_FILE
    echo "" >> $LDIF_FILE   #why is this here?

done < "$GROUP_LIST"

echo "LDIF file created: $LDIF_FILE"