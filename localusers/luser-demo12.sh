#!/bin/bash

# This deletes a user.

# Use as Root.
if [[ ${uid} -ne 0 ]]
then
    echo "Please run this with sudo or as root." >&2
    exit 1
fi

# Assume the first argument is the user to delete.
USER=${1}

# Delete the user.
userdel ${USER}

# Make sure the user go deleted.
if [[ ${?} -ne 0 ]]
then 
    echo "The account ${USER} was not deleted." >&2
    exit 1
fi

# Tell the user the account was deleted.
echo "The account ${USER} was deleted." >&2

exit 0
