#!/bin/bash

# Piped Script to be used in conjunction with writing to log files, and cleaning up the data
#
#log --append 


# Global Variables
FLAG=$1
LOG_FILE=$2
LOG_FILE_SANITIZED=$(echo $LOG_FILE | sed 's|.*/||')
LOG_BACKUP_DIR="/log/Backups"
LOG_BACKUP_FILE="$LOG_BACKUP_DIR/$LOG_FILE_SANITIZED.bk"



function beginLog(){


    createSpace

    echo "Log started: " | sudo tee -a "$LOG_FILE"

    timedatectl status | head -n 1 | sudo tee -a "$LOG_FILE"

    createSpace

}



function endLog(){

  createSpace

  echo "Log ended: " | sudo tee -a "$LOG_FILE"

  timedatectl status | head -n 1 | sudo tee -a "$LOG_FILE"

  createSpace

  drawLine

}



function createSpace(){


  echo "" | sudo tee -a "$LOG_FILE"

  echo "" | sudo tee -a "$LOG_FILE"

}



function drawLine(){


  echo "_____________________________________________________________________________________________________________________________________________________________________" | sudo tee -a "$LOG_FILE"

}



function backupLog(){


  if [[ ! -d "$LOG_BACKUP_DIR" ]]; then
    
    createSpace
    
    echo "Directory for backup logs doesn't exist.  Creating now!"
    
    createSpace

    echo "Backups are saved to $LOG_BACKUP_DIR!"
    
    createSpace

    sudo mkdir -p "$LOG_BACKUP_DIR"

  fi

  sudo cp -r "$LOG_FILE" "$LOG_BACKUP_FILE"

}


function check_log_file_exists(){



    if [ ! -f "$LOG_FILE" ]; then 


      echo -e "\nError! Log File does not exist or was not specified!"

      kill -SIGINT $$

    fi




}


function appendToLog(){


  createSpace

  sudo tee -a "$LOG_FILE"


}


function editLog(){

  log_file_line_count=$(wc -l < $LOG_FILE)
    
  sudo nano +$log_file_line_count "$LOG_FILE"

}


function displayHelp(){


  createSpace

  drawLine

  echo "Usage: log <FLAG> <LOG_FILE>"
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

  check_log_file_exists

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

init $@
