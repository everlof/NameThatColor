#!/bin/bash

TAB=$'\t'
filename="NameThatColor/NameList.swift"
cat LICENSE | sed -e 's|^|// |' > $filename
echo -e "" >> $filename
echo -e "struct Resource {" >> $filename
echo -e "\tstatic let colorMap = [" >> $filename
curl "http://chir.ag/projects/ntc/ntc.js" \
    | grep '^\["' \
    | sed -e 's/,/:/' \
    | tr -d '[' \
    | tr -d ']' \
    | sed -e "s/^/${TAB}${TAB}/" \
    | sed -e 's/"/0x/' \
    | sed -e 's/"//' >> $filename
echo -e "\t]" >> $filename
echo -e "}" >> $filename
