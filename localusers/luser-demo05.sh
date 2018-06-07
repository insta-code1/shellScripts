#!/bin/bash

# This script generates a list of random passwords.

# A random number as a password.
PASSWORD=${RANDOM}
echo "${PASSWORD}"

# Three random numbers together.
PASSWORD="${RANDOM}${RANDOM}${RANDOM}"
echo "${PASSWORD}"

# Use the date/time as the basis for the password.
PASSWORD=$(date +%s)
echo "${PASSWORD}"

# Use nanoseconds to act as randomize the data.
PASSWORD=$(date +%s+%N) 
echo "${PASSWORD}"

# A better password.
PASSWORD=$(date +%s+%N | sha256sum | head -c 32)
echo "${PASSWORD}"

# A even better password.
PASSWORD=$(date +%s+%N${RANDOM}${RANDOM}${RANDOM} | sha256sum | head -c 48)
echo "${PASSWORD}"

# Append a special character.
SPECIAL_CHAR=$(echo '!@£$%^&*()_-+=' | fold -w1 | shuf | head -c 1)
echo "${PASSWORD}${SPECIAL_CHAR}"


