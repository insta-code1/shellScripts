#!/bin/bash
#
# This script disables, deletes, and/or archives users on the local system.
#


ARCHIVE_DIR='/archive'


# Make sure the script is being executed with superuser privileges.
if [[ ${UID} -ne 0 ]]
then
    echo "Please run as sudo or root." >&2
    exit 1
fi


usage() {
    # Display the usage and exit.
    echo "Usage: ${0} [-dra] USER [USER]..." >&2
    echo 'Disable a local linux account.' >&2
    echo '  -d  Deletes accounts instead of disabling them.' >&2
    echo '  -r  Removes the home directory associated with the account(s).' >&2
    echo '  -a  Creates an archive of the home directory associated the accounts. ' >&2
    exit 1
}

# Parse the options.
while getopts dra OPTION
do
    case ${OPTION} in
        d) DELETE_USER='true' ;;
        r) REMOVE_OPTION='-r' ;;
        a) ARCHIVE='true' ;;
        ?) Usage ;;
    esac
done

# Remove the arguments while leaving the remaining arguments.
shift "$(( OPTIND - 1 ))"

# if the user doesn't supply at least one argument, give them help.
if [[ ${#} -lt 1 ]]
then
    usage
fi

# Loop through all the usernames supplied as arguments.
for USERNAME in ${@}
do
    echo "Processing user: ${USERNAME}"

    USERID=$(id -u ${USERNAME})

    # Make sure the UID is at least 1000
    if [[ ${UID} -gt 1000 ]]
    then
        echo "Refusing to remove ${USERNAME} account with UID ${USERID}." >&2
        exit 1
    fi

    # Create an archive if requested to do so.
    if [[ ${ARCHIVE} = true ]]
    then
        # Make sure the ARCHIVE_DIR exists.
        if [[ ! -d ${ARCHIVE_DIR} ]]
        then
            echo "Creating ${ARCHIVE_DIR} directory." 
            mkdir -p ${ARCHIVE_DIR}
            if [[ ${?} -ne 0 ]]
            then
                echo "The archive directory ${ARCHIVE_DIR} could not be created." >&2
                exit 1
            fi
        fi
        
        # Archive the user's home directory and move it into the ARCHIVE_DIR
        HOME_DIR="/home/${USERNAME}"
        ARCHIVE_FILE="${ARCHIVE_DIR}/${USERNAME}.tgz"
        if [[ -d "${HOME_DIR}" ]]
        then
            echo "Archiving ${HOME_DIR} to ${ARCHIVE_FILE}."
            tar -zcf ${ARCHIVE_FILE} ${HOME_DIR} &> /dev/null
            if [[ ${?} -ne 0 ]]
            then
                echo "Could not create ${ARCHIVE_FILE}." >&2
                exit 1
            fi
        else
            echo "${HOME_DIR} dose not exist or is not a directory."
            exit 1
        fi
    fi

    if [[ ${DELETE_USER} = 'true' ]]
    then
        # Delete the user
        userdel ${REMOVE_OPTION} ${USERNAME}

        # Check to see if the userdel command succeeded.
        # We don't want to tell the user the account has been deleted when it hasn't been.
        if [[ ${?} -ne 0 ]]
        then
            echo "The account ${USERNAME} was NOT deleted."
            exit 1
        fi
        echo "The account ${USERNAME} was deleted."
    else 
        chage -E 0 ${USERNAME}

        # Check to see if the userdel command succeeded.
        # We don't want to tell the user the account has been deleted when it hasn't been.
        if [[ ${?} -ne 0 ]]
        then
            echo "The account ${USERNAME} was NOT disabled."
            exit 1
        fi
        echo "The account ${USERNAME} was disabled."
    fi
done

exit 0
