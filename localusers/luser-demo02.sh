#!/bin/bash


# Display the UID and username of the user executing the script.
# Display if the user is the root user or not.

# Display the UID
echo "Your UID is ${UID}"

# Display the username.
echo "Your username is $(id -un)"

# Display if the user is root or not.

if [[ "${UID}" -eq 0 ]]
then
    echo "You are root"
else
    echo "You are not root"
fi
