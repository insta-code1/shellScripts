#!/bin/bash 


# This file generates a random password for each user specified on the command line.

# Display what the user typed on the command line.
echo "You executed this command: ${0}"

# Display the path and filename of this script.
echo "You used $(dirname ${0}) as the path to execute this $(basename ${0}) script."

# Tell them how many commands wear passed in.
# (Inside the script they are parameters, outside they are arguments.)
NUMBER_OF_PARAMETERS="${#}"
echo "You supplied ${NUMBER_OF_PARAMETERS} argument(s) on the command line."

# Make sure the supplied at least on argument.
if [[ "${NUMBER_OF_PARAMETERS}" -lt 1 ]]
then 
    echo  "Usage: ${0} USER_NAME [USER_NAME]..."
    exit 1
fi    

# Generate and display a password for each parameter.
for USER_NAME in "${@}"
do
    PASSWORD=$(date +%t%N | sha256sum | head -c48)
    echo "${USER_NAME}: ${PASSWORD}"
done
