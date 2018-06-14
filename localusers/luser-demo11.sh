#!/bin/bash

# This script generates random passwords.
# This user can set a password length with -l and add a special character with -s.
# Verbose mode can be enabled with -d.

usage() {
    echo "Usage: ${0} [-vs] [-l LENGTH]" >&2
    echo 'Generate a random password.'
    echo '  -l LENGTH  Specify the password length.'
    echo '  -s         Append a special character to the password.' 
    echo '  -v         Increase verbosity.'
}

log(){
  # Send to STDOUT
  local MESSAGE="${@}"
  if [[ ${VERBOSE} = 'true' ]]
  then
    echo ${MESSAGE}
  fi
}

# Set a default password length.
LENGTH=48

while getopts vl:s OPTION
do
    case ${OPTION} in
        v)
            VERBOSE='true'
            log 'Verbose mode on.'
            ;;
        l)
            LENGTH="${OPTARG}"
            ;;  
        s)
            USE_SPEICAL_CHARACTER='true'
            ;;
        ?)
            usage
            ;;
    esac
done

# Remove the options while leaving the remaining commands.
shift "$(( OPTIND -1  ))"

if [[ "${#}" -gt 0 ]]
then
    usage
fi

log 'Generating password.'

PASSWORD=$(date +%s%N${RANDOM}${RANDOM} | sha256sum| head -c${LENGTH})

# Append special character if requested to do so.
if [[ ${USE_SPEICAL_CHARACTER} = 'true' ]]
then
    log 'Appending a special character.'
    SPEICAL_CHARACTER=$(echo '!@$#%^&*()-_+=' | fold -w1 | shuf | head -c1)
    PASSWORD=${PASSWORD}${SPEICAL_CHARACTER}
fi

log 'Done.'
log 'Here is the password.'

# Display the password.
echo ${PASSWORD}

exit 0
