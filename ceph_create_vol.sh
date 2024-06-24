#!/bin/bash

# Read sandboxlist file and present options for $1
echo "Select an option from the sandboxlist:"
select sandbox in $(cat sandboxlist); do
    if [[ -n $sandbox ]]; then
        echo "You selected: $sandbox"
        break
    else
        echo "Invalid selection. Try again."
    fi
done

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
echo "Sandbox: $sandbox"
echo "Environment: $env"
echo "Size: $size"

echo "The contents of the sandboxlist file are:"
cat sandboxlist

read -p "Are these selections correct? (yes/no): " confirmation
if [[ $confirmation == "yes" ]]; then
    # Execute the command with the selected and calculated values
    echo "Executing: fs subvolume create nfsroot $sandbox $env --size $size"
    fs subvolume create nfsroot $sandbox $env --size $size
else
    echo "Operation cancelled."
    exit 1
fi
