#!/bin/bash

# Input arrays
portraits=("threebody-fiction.png" "hair.png" "deephouse.png" "gradar.png")
music=("deephouse_ai_music_001.wav" "deephouse_ai_music_002.wav")

# Default directories
image_dir="examples/image"
audio_dir="examples/wav"
output_dir="examples/results"

# Create output directory if it doesn't exist
mkdir -p "$output_dir"

# Process all combinations
for img in "${portraits[@]}"; do
    for audio in "${music[@]}"; do
        # Get filename without extension
        img_name=$(basename "$img" .png)
        audio_name=$(basename "$audio" .wav)

        # Define paths
        image_path="$image_dir/$img"
        audio_path="$audio_dir/$audio"
        output_path="$output_dir/${img_name}_${audio_name}.mp4"

        # Check if input files exist
        if [ ! -f "$image_path" ]; then
            echo "Warning: Image not found: $image_path"
            continue
        fi

        if [ ! -f "$audio_path" ]; then
            echo "Warning: Audio not found: $audio_path"
            continue
        fi

        # Run the processing
        echo "Processing: $img + $audio -> $output_path"
        uv run demo.py "$image_path" "$audio_path" "$output_path"

        if [ $? -eq 0 ]; then
            echo "✓ Successfully created: $output_path"
        else
            echo "✗ Failed to process: $img + $audio"
        fi
        echo "---"
    done
done

echo "Batch processing complete!"