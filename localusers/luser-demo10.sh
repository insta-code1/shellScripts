#!/bin/bash

log() {
  # Sends a message to syslog and STDOUT if VERBOSE is set to true.
  local VERBOSE=${1}
  shift
  local MESSAGE=${@}
  if [[ ${VERBOSE} = 'true' ]]
  then
    echo "${MESSAGE}" 
  fi
	logger -t "${0}" "${MESSAGE}"
}

log 'true' 'Passsing an argument to the log function'
log 'false' 'And again!'

log2() {
  local MESSAGE2=${@}
  if [[ ${VERBOSE2} = 'true' ]]
  then
    echo "${MESSAGE2}" 
  fi
}

backup_file() {
  # A function that creates a backup of a file. Returns a non-zero status on error.

  local FILE=${1}

  # Make sure the file exists
  if [[ -f ${FILE} ]]
  then
    BACKUP_FILE="/var/tmp/$(basename $FILE).$(date +%F-%N)"
    log 'true' "Backing up ${FILE} to ${BACKUP_FILE}"

    # The exit status with be the status of the cp command.    
    cp -p ${FILE} ${BACKUP_FILE}
  else
    # The file dose not exist, so return a non-zero exit status.
    return 1
  fi
}

readonly VERBOSE2='true'
log2 "Setting a readonly global variable"


backup_file '/etc/passwd'

backup_file '/etc/hostname'


# Make a decision based on the exit status.
if [[ "${?}" -eq '0' ]]
then
  log 'File backup succeeded!'
else
  log 'File backup  failed!'
  exit 1
fi
