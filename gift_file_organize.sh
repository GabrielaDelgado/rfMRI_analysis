#!/bin/bash

source_dir="/mnt/scratch/NHP4TAIT/TAIT_Subjects"

dest_base="/mnt/scratch/NHP4TAIT/TAIT_Subjects_Final"

file_ext="clean.nii.gz"

session_directories=("rfMRI_REST1_7T_PA" "rfMRI_REST2_7T_AP" "rfMRI_REST3_7T_PA" "rfMRI_REST4_7T_AP")

# Loop through subject directories that include "7T"
for sub_dir in "$source_dir"/*_7T*/; do 
	# Subject name 
	sub_name=$(basename "$sub_dir" | cut -c1-6)
	
	# Path to session directories
	for session_name in "${session_directories[@]}"; do 
		session_path="$sub_dir$sub_name/MNINonLinear/Results/$session_name"
	
		# Check if the session directory contains files with the specified file extension
		if [ -n "$(find "$session_path" -maxdepth 1 -type f -name "*$file_ext")" ]; then 
			dest_dir="$dest_base/$sub_name/$session_name"
			mkdir -p "$dest_dir"
		
			# Move files with specified extension to destination directory 
			mv "$session_path"/*"$file_ext" "$dest_dir/"
		
			echo "Moved files with $file_ext extension from $session_path to $dest_dir"
		else 
			echo "No files with $file_ext extension found in $session_path" 
		fi
	done 
done 
