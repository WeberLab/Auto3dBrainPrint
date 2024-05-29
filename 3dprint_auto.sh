#!/bin/bash

script_dir=$(echo $0 | sed 's/[^/]*$//')

# Parse command line arguments
while getopts ":i:o:" opt; do
	case ${opt} in
	i)
		input_dir=$OPTARG
		;;
	o)
		output_dir=$OPTARG
		;;
	\?)
		echo "Usage: $0 -i input_directory -o output_directory"
		exit 1
		;;
	esac
done
shift $((OPTIND - 1))

# Check if input and output directories are provided
if [ -z "$input_dir" ] || [ -z "$output_dir" ]; then
	echo "Usage: $0 -i input_directory -o output_directory"
	exit 1
fi

# Command to load files from the input directory and save the result to the output directory
echo "Loading files from $input_dir and saving to $output_dir"
mris_convert --combinesurfs $input_dir/rh.pial $input_dir/lh.pial $output_dir/combined_mesh.stl

# Apply the "Flatten Visible Layers" filter to the combined mesh
echo "Applying the 'Flatten Visible Layers' filter to the combined mesh..."
meshlabserver -i "$output_dir"/combined_mesh.stl -s ${script_dir}fix.mlx -o "$output_dir"/combined_mesh_processed.stl

echo "Processing complete!"
