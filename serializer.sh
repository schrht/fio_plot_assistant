#!/bin/bash
# Description:
#     Join "chart_bw.1.log chart_bw.2.log chart_bw.3.log chart_bw.4.log" into chart_bw.log, making time continuous.
# Input:
#     $1 must be "chart_bw." in this case.
# Restriction:
#     File number should be continuously increased.

if [ -z "$1" ]; then
	echo -e "\nUsage: $0 <file name prefix before dot>\n"
	exit 1
else
	fname=$1
fi

input_files=$(ls $fname.*.log 2>/dev/null)
if [ -z "$input_files" ]; then
	echo -e "\nCan not found input files.\n"
	exit 1
else
	echo -e "\nInput files:"
	echo $input_files | xargs echo
fi

output_file=$fname.log
echo -e "\nOutput file:\n$output_file\n"

# remove the output file
mv $output_file $output_file.bak >/dev/null 2>&1

get_base_duration(){
	if [ -r $output_file ]; then
		tail -1 $output_file | cut -d, -f1
	else
		echo "0"
	fi
}

for input_file in $input_files; do
	if [ -r $input_file ]; then
		# get the base duration
		base=$(get_base_duration)

		# print debug info
		echo "DEBUGINFO: handle file $input_file, base = $base ..."

		# add base to the duration
		cat $input_file | awk "{\$1+=$base}{print}" | sed 's/ /, /' >> $output_file
	fi
done

echo -e "\nFinished!\n"
exit 0

