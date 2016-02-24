#!/bin/bash

folder_path="/Users/jim/Robot/project"
search_start="\*\*\* Keywords \*\*\*"
search_end="\*\*\*"

kwds_in_one_string=$(find "$folder_path" -type f -print0 | xargs -0 awk "/$search_start/{flag=1;next}/$search_end/{flag=0}flag" "$file" | grep -e "^\S" | grep -v "^#" | grep -v "\${" )
IFS=$'\n' read -rd '' -a kwds_array <<<"$kwds_in_one_string"

echo "---ALL USER KEYWORDS--- (without embedded variables)"
for i in "${!kwds_array[@]}"; do 
  printf "%s\t%s\n" "$i" "${kwds_array[$i]}"
done
echo ----

echo "---UNUSED USER KEYWORDS---"
for keyword in "${kwds_array[@]}"
do
	stripped_keyword_without_comments=$(echo "$keyword"|cut -d'#' -f 1 | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
	number_of_occurencies=0
	number_of_occurencies=$(find "$folder_path" -type f -print0 | xargs -0 cat | grep -c -i "$stripped_keyword_without_comments")
	if (( $number_of_occurencies \< 2 ))
	then
		echo "$stripped_keyword_without_comments"
	fi
done
echo "-------"