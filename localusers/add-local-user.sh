#!/bin/bash


# Make sure the script is being executed with superuser privileges.
if [[ "${UID}" -ne 0 ]]
then
  echo "Please run as sudo or root"
  exit 1
fi

# Get the username (login).
read -p 'Enter username for this new account: ' USER_NAME

# Get the real name (contents for the description field).
read -p 'Enter the person name for this account: ' COMMENT

# Get the password.
read -p 'Enter the temporary password for this account: ' PASSWORD

# Create the user.
useradd -c "${COMMENT}" -m ${USER_NAME} 

# Check to see if the useradd command succeeded.
if [[ "${?}" -ne 0 ]]
then
  echo "Unable to add this username please try a different username."
  exit 1
fi

# Set the password.
echo ${PASSWORD} | passwd --stdin ${USER_NAME} 

# Check to see if the passwd command succeeded.
if [[ "${?}" -ne 0 ]]
then
  echo "Unable to use this password please try a different password"
  exit 1
fi

# Force password change on first login.
passwd -e ${USER_NAME}

# Display the username, password, and the host where the user was created.
echo
echo "Username: ${USER_NAME}"
echo "Password: ${PASSWORD}"
echo "Host: ${HOSTNAME}"
echo
exit 0
