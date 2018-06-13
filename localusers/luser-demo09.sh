#!/bin/bash

# This script demonstrates the case statement.

case ${1} in
  start)
    echo 'Start'
  ;;
  stop)
    echo 'Stop'
  ;;
  status|state|--status|--state)
    echo 'Status'
  ;;
  *)
   echo 'Supply a valid option.' >&2
   exit 1 
  ;; 
esac
