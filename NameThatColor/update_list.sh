#!/bin/bash

TAB=$'\t'
content=$(curl "http://chir.ag/projects/ntc/ntc.js")
filename="NameThatColor/NameList.swift"
cat LICENSE | sed -e 's|^|// |' > $filename
echo -e "" >> $filename

# Define struct
echo -e "struct Resource {" >> $filename

# Define hex to name-map
echo -e "\tstatic let hexToName: [Int: String] = [" >> $filename
echo "${content}" \
    | grep '^\["' \
    | sed -e 's/,/:/' \
    | tr -d '[' \
    | tr -d ']' \
    | sed -e "s/^/${TAB}${TAB}/" \
    | sed -e 's/"/0x/' \
    | sed -e 's/"//' >> $filename
echo -e "\t]" >> $filename

# Define hex to name-map
echo -e "\tstatic let nameToHex: [String: Int] = [" >> $filename
echo "${content}" \
| grep '^\["' \
| sed -e 's/,/:/' \
| tr -d '[' \
| tr -d ']' \
| sed -e 's/"/0x/' \
| sed -e 's/"//' \
| sed -E 's/([^:]*): ([^,]*)/\2: \1/' \
| sed -e "s/^/${TAB}${TAB}/" >> $filename
echo -e "\t]" >> $filename

# Define names-array
echo -e "\tstatic let names: [String] = [" >> $filename
echo "${content}" \
| grep '^\["' \
| sed -e 's/,/:/' \
| tr -d '[' \
| tr -d ']' \
| cut -d: -f 2 \
| sed -e "s/^/${TAB}${TAB}/" >> $filename
echo -e "\t]" >> $filename

echo -e "}" >> $filename
