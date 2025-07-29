#!/bin/bash

# Piped Script to be used in conjunction with writing to log files, and cleaning up the data
#
# by Finn Mallon 


# Global Variables
FLAG="$1"
LOG_FILE="$2"
LOG_FILE_SANITIZED=$(echo $LOG_FILE | sed 's|.*/||')
LOG_BACKUP_DIR="/log/Backups"
LOG_BACKUP_FILE="$LOG_BACKUP_DIR/$LOG_FILE_SANITIZED.bk"

#Subshell kill -SIGINT $$ fix - adds true/false to temp file, takes from it if in subshell;
SCRIPT_PID=$$
###############################################


function beginLog(){

    check_log_file_exists

    drawLine_log
    createSpace_log

    echo "Log started: " | sudo tee -a "$LOG_FILE"

    timedatectl status | head -n 1 | sudo tee -a "$LOG_FILE"

    createSpace_log

}



function endLog(){

  check_log_file_exists

  createSpace_log

  createSpace_log

  echo "Log ended: " | sudo tee -a "$LOG_FILE"

  timedatectl status | head -n 1 | sudo tee -a "$LOG_FILE"

  createSpace_log

  drawLine_log

}



function createSpace(){


  echo ""

  echo ""


}



function drawLine(){



  echo "_____________________________________________________________________________________________________________________________________________________________________"


}



function drawLine_log(){


  drawLine | sudo tee -a "$LOG_FILE"


}



createSpace_log(){


  createSpace | sudo tee -a "$LOG_FILE"

}



function backupLog(){

  check_log_file_exists

  if [ ! -d "$LOG_BACKUP_DIR" ]; then

    echo "Directory for backup logs doesn't exist.  Creating now!"
    createSpace
    sudo mkdir -p "$LOG_BACKUP_DIR"

  fi


  sudo cp -r "$LOG_FILE" "$LOG_BACKUP_FILE"

  createSpace

  echo "Backing up $LOG_FILE to $LOG_BACKUP_FILE now!"

  createSpace

}


function check_log_file_exists(){



  if [ ! -f "$LOG_FILE" ]; then 

    createSpace

    echo "Error! Log File not specified or doesn't exist!"

    createSpace
    

    is_subshell


  fi


}


function is_subshell(){



  if (( BASH_SUBSHELL > 0 )); then


    exit 0

  else
    
    kill -SIGINT "$SCRIPT_PID"

  fi


}



function is_piped(){


  if [[ -p /dev/stdin ]]; then

    piped_function="true"
    
  else
    
    piped_function="false"

  fi


}



function break_script(){

  # check if the --append function is being piped as necessary, or break!
  is_piped 

  if [ "$piped_function" = "false" ]; then

    createSpace 

    echo -e "Error: the Append flag [ -a || --append] must be piped in order to function!"

    kill -SIGINT $SCRIPT_PID

    createSpace

  fi

  check_log_file_exists

}



function appendToLog(){


  break_script

  createSpace_log

  sudo tee -a "$LOG_FILE"

  createSpace


}


function editLog(){

  check_log_file_exists

  log_file_line_count=$(wc -l < $LOG_FILE)
    
  sudo nano +$log_file_line_count "$LOG_FILE"

}


function displayHelp(){


  createSpace

  drawLine

  createSpace

  echo "Usage: log <FLAG> <LOG_FILE>::::If using <FLAG> [-a | --append], the script must be piped!"
  createSpace
  echo "Flag:"
  echo "   [--append | -a] appends the output to the log file!"
  echo "   [--begin | -b] begins the log file, applying a start date!"
  echo "   [--backup] backs-up the log file!"
  echo "   [--edit] brings up the log file in nano!"
  echo "   [--end | -e] ends the log file applying a date!"
  echo "   [--help | -h] brings up this menu!"

  createSpace

  drawLine


}




function error(){

  createSpace
  
  echo "Invalid argument! Use -h or --help to display argument menu." 
  
  createSpace

}


function main(){


  
  case "$FLAG" in

    --backup) backupLog
    ;;
    
    --begin | -b) beginLog
    ;;

    -e | --end) endLog
    ;;
  
    --append | -a) appendToLog
    ;;
    
    --edit) editLog
    ;;

    --help | -h) displayHelp
    ;;

    *) error
    ;;

  esac


}


function init(){

  main

}


init "$@"



