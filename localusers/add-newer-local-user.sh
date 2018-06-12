#!/bin/bash
# This script creates a new user on the local system.
# You must supply a username as an argument to the script.
# Optionally, you can also provide a comment for the account as an argument.
# A password will be automatically generated for the account.
# The username, password, and host for the account will be displayed.


# Make sure the script is being executed with superuser privileges.
if [[ "${UID}" -ne 0 ]]
then
  echo "Please run as sudo or root" >&2
  exit 1
fi


# If the user dosen't supply at least one argument, give them help.
if [[ "${#}" -lt 1 ]]
then
    echo "Usage: ${0} USER_NAME [COMMENT]..." >&2
    echo 'Create an account on the local system with the name of USER_NAME and a comments field of COMMENT.' >&2
    exit 1
fi


# The first parameter is the username.
USERNAME="${1}"


# The rest of the parameters are used for the account comments.
shift
COMMENT="${@}"


# Generate a password.
PASSWD=$(date +%s+%N${RANDOM}${RANDOM}${RANDOM} | sha256sum | head -c 48)
SPECIAL_CHAR=$(echo '!@£$%^&*()_-+=' | fold -w1 | shuf | head -c 1)
PASSWORD="${PASSWD}${SPECIAL_CHAR}"


# Create the user.
useradd -c ${COMMENT} -m ${USERNAME} &> /dev/null 

# Check to see if the useradd command succeeded.
if [[ "${?}" -ne 0 ]]
then
  echo "Unable to add this username please try a different username." >&2
  exit 1
fi


# Set the password.
echo ${PASSWORD} | passwd --stdin ${USERNAME} &> /dev/null

#Check to see if the passwd command succeeded.
if [[ "${?}" -ne 0 ]]
then
  echo "The password for this account could not be set." >&2
  exit 1
fi

# Force password change on first login.
passwd -e ${USER_NAME} &> /dev/null

# Display the username, password, and the host where the user was created.
echo
echo "username:"
echo ${USERNAME}
echo
echo "password:"
echo ${PASSWORD}
echo
echo "host:"
echo ${HOSTNAME}
exit 0
