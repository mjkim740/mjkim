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

# Present options for $2
echo "Select an environment (dev, sandbox, qa):"
select env in dev sandbox qa; do
    if [[ -n $env ]]; then
        echo "You selected: $env"
        break
    else
        echo "Invalid selection. Try again."
    fi
done

# Prompt for $3 and calculate the size
read -p "Enter an integer for size calculation: " input_size
if [[ $input_size =~ ^[0-9]+$ ]]; then
    size=$(( input_size * 1024 ** 3 ))
    echo "Calculated size: $size"
else
    echo "Invalid input. Please enter an integer."
    exit 1
fi

# Confirm selections before executing
echo "You have selected:"
echo "Volume list: $volume_list"
echo "Environment: $env"
echo "Size: $size"

echo "The contents of the volumelist file are:"
cat volumelist

read -p "Are these selections correct? (yes/no): " confirmation
if [[ $confirmation != "yes" ]]; then
    echo "Operation cancelled."
    exit 1
fi

# Display final command for confirmation
final_command="fs subvolume create nfsroot \"$volume_list\" $env --size $size"
echo "The final command to be executed is:"
echo "$final_command"

read -p "Do you want to execute this command? (yes/no): " execute_confirmation
if [[ $execute_confirmation == "yes" ]]; then
    # Execute the final command for each volume in the list
    for volume in $volume_list; do
        echo "Executing: fs subvolume create nfsroot $volume $env --size $size"
        fs subvolume create nfsroot "$volume" "$env" --size "$size"
    done
else
    echo "Operation cancelled."
    exit 1
fi
