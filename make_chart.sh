#!/bin/bash
# Description:
#     Make chart from specified log.
# Input:
#     $1 must be one of "*_bw.log", "*_lat.log" or "*_iops.log".

if [[ "$1" =~ "_bw.log" ]]; then
	input_file=$1
	output_file=${1%_*}-bw.svg
elif [[ "$1" =~ "_lat.log" ]]; then
	input_file=$1
	output_file=${1%_*}-lat.svg
elif [[ "$1" =~ "_iops.log" ]]; then
	input_file=$1
	output_file=${1%_*}-iops.svg
else
	echo -e "\nUsage: $0 <*_bw.log, *_lat.log, *_iops.log>\n"
	exit 1
fi

if [ ! -r "$input_file" ]; then
	echo -e "\nCan not found / read input file.\n"
	exit 1
else
	echo -e "\nInput file:\n$input_file"
	echo -e "\nOutput file:\n$output_file (open with: eog $output_file)\n"
fi

temp_folder="fio_generate_plots.$$"
mkdir -p $temp_folder && cd $temp_folder

ln -s ../$input_file .
cmd="fio_generate_plots \"chart\" ${input_file%_*}"
echo $cmd
eval $cmd >/dev/null 2>&1

[ "chart-${output_file##*-}" != "$output_file" ] && mv chart-${output_file##*-} $output_file
cp $output_file ..

if [ "$?" = "0" ]; then
	cd .. && rm -r $temp_folder
else
	echo -e "\nPlease get your chart in $temp_folder"
fi

echo -e "\nFinished!\n"
exit 0

