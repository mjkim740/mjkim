#!/bin/bash

# Read and display the entire volumelist file
echo "The contents of the volumelist file are:"
cat volumelist

read -p "Are these the correct volumes you want to use? (yes/no): " initial_confirmation
if [[ $initial_confirmation != "yes" ]]; then
    echo "Operation cancelled."
    exit 1
fi

# Read the entire volumelist file into a variable
volume_list=$(cat volumelist)
if [[ -z $volume_list ]]; then
    echo "The volumelist file is empty. Exiting."
    exit 1
fi

# Process each volume in the list
while IFS= read -r volume; do
    if [[ -z $volume ]]; then
        continue
    fi

    echo "Processing volume: $volume"

    # Prompt for dev
    read -p "Enter the device for volume $volume: " dev

    # Prompt for size and calculate the size
    read -p "Enter an integer for size calculation for volume $volume: " input_size
    if [[ $input_size =~ ^[0-9]+$ ]]; then
        size=$(( input_size * 1024 ** 3 ))
        echo "Calculated size: $size"
    else
        echo "Invalid input. Please enter an integer."
        exit 1
    fi

    # Confirm selections before executing
    echo "You have selected:"
    echo "Volume: $volume"
    echo "Device: $dev"
    echo "Size: $size"

    read -p "Are these selections correct? (yes/no): " confirmation
    if [[ $confirmation != "yes" ]]; then
        echo "Skipping volume $volume."
        continue
    fi

    # Display final command for confirmation
    final_command="fs subvolume create nfsroot $volume $dev --size $size"
    echo "The final command to be executed is:"
    echo "$final_command"

    read -p "Do you want to execute this command? (yes/no): " execute_confirmation
    if [[ $execute_confirmation == "yes" ]]; then
        # Execute the final command for the current volume
        echo "Executing: $final_command"
        fs subvolume create nfsroot "$volume" "$dev" --size "$size"
    else
        echo "Operation cancelled for volume $volume."
    fi
done < volumelist
