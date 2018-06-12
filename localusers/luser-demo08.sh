#!/bin/bash

# This file demonstrates I/O redirection.

# Redirect STDOUT to a file.

FILE=/tmp/data
head -n1 /etc/passwd > ${FILE}

# Redirect STDIN to a program.
read LINE <  ${FILE}
echo "LINE contents: ${LINE}"

#Redirect STDOUT to a file.
head -n3 /etc/passwd > ${FILE}
echo
echo "Contents of : ${FILE}"
cat ${FILE}

# Redirect STDOUT to a file. Appending to that file.
date | sha256sum | head -c10 >> ${FILE}
echo
echo "Appending content to the ${FILE}"
cat ${FILE}


# Redirect STDIN to a program, using File Descriptor 0.
read LINE 0< ${FILE}
echo
echo "LINE Contents: ${LINE}"

# Redirect STDOUT to a file use File Descriptor 1.
head -n3 /etc/passwd 1> ${FILE}
echo
echo "LINE contents: ${FILE}"

# Redirect STDERR to a file.
ERR_FILE="/tmp/data.err"
head -n1 /etc/hostname /fakefile 2> ${ERR_FILE} 
echo
echo "Contents of file from STDERR : ${ERR_FILE}"
cat ${FILE}

# Redirect STDERR & STDOUT to a file.
head -n1 /etc/hostname /fakefile &> ${ERR_FILE}
echo
echo "Contents of file from STDOUT STDERR : ${ERR_FILE}"
cat ${FILE}

# Redirect STDERR & STDOUT to a program using a pipe.
echo
head -n1 /etc/hostname /fakefile |& cat -n 

# Send output to STDERR.
echo "THIS is STDERR!" >&2

# Discard STDOUT.
echo
echo "discarding STDOUT"
head -n1 /etc/hostname /fakefile > /dev/null

# Discard STDERR
echo
echo "Discarding STDERR"
head -n1 /etc/hostname /fakefile 2> /dev/null

# Discard STDOUT and STDERR.
echo
echo "Discarding STDOUT and STDERR"
head -n1 /etc/hostname /fakefile &> /dev/null

# Clean up 
rm ${FILE} ${ERR_FILE} &> /dev/null

