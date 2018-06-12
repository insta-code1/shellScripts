#!/bin/bash


# Make sure the script is being executed with superuser privileges.
if [[ "${UID}" -ne 0 ]]
then
  echo "Please run as sudo or root"
  exit 1
fi

# If the user dosen't supply at least one argument, give them help.
if [[ "${#}" -lt 1 ]]
then
    echo "Pass at one or more username to create an account(s)."
    exit 1
fi

# Iterate through each username passed to this file.
for USER_NAME in "${@}"
do

    # Create the user.
    useradd -m ${USER_NAME} 

    # Check to see if the useradd command succeeded.
    if [[ "${?}" -ne 0 ]]
    then
      echo "Unable to add this username please try a different username."
      exit 1
    fi

    # Generate a password.
    PASSWD=$(date +%s+%N${RANDOM}${RANDOM}${RANDOM} | sha256sum | head -c 48)

    SPECIAL_CHAR=$(echo '!@£$%^&*()_-+=' | fold -w1 | shuf | head -c 1)
    PASSWORD="${PASSWD}${SPECIAL_CHAR}"
    

    # Set the password.
    echo ${PASSWORD} | passwd --stdin ${USER_NAME} 

    # Check to see if the passwd command succeeded.
    # if [[ "${?}" -ne 0 ]]
       # then
       #   echo "Unable to use this password please try a different password"
       #   exit 1
       # fi

    # Force password change on first login.
    passwd -e ${USER_NAME}

    # Display the username, password, and the host where the user was created.
    echo
    echo "Username: ${USER_NAME}"
    echo "Password: ${PASSWORD}"
    echo "Host: ${HOSTNAME}"
    echo
done

exit 0
