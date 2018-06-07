#!/bin/bash

# This script displays various information to the screen

# Display 'Hello'
echo 'Hello'

# Assign a value to a variable
WORD='script'

# Display that value using the variable
echo "$WORD"

# Demonstrate that single quotes cause variables to NOT get expanded
echo '$WORD'

# Combine a variable with hard-coded text.
echo "This is a shell $WORD"

# Display the content of the variable using a different syntax.
echo "This is a shell ${WORD}"

# Append text to the variable.
echo "${WORD}ing is fun!"

# How not to append text to the variable.
echo "$WORDing is fun!"

# Create a new variable
ENDING='ed'

# Combine the two variables.
echo "This is ${WORD}${ENDING}"

# Reassign the the ENDING variable
ENDING='ing'
echo "${WORD}${ENDING}"
