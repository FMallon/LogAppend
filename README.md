# LogAppend
Bash Script to make Logging easier

Usage: log <FLAG> <LOG_FILE>
  
  Flag: 
    
    [--append | -a] appends the output to the log file!
    [--begin | -b] begins the log file, applying a start date!
    [--backup] backs-up the log file!
    [--edit] brings up the log file in nano!
    [--end | -e] ends the log file applying a date!
    [--help | -h] brings up this menu!


Based off 'sudo tee -a', this Script was made to append to, and sanitize log files.

Using (where the script is set to alias 'log'): 
  1) "log --begin /log/logfile.log" will set the current date and time to begin the log;
  2) "ls -lah | log -a /log/logfile.log" will append the command to the log, adding new lines to make logs readable for quick additions to log files.
  3) "log --end /log/logfile.log" ends the log file with the time and date to finish the logging.

Uses other functionality such as "log --edit /log/logfile.log" && "log --backup /log/logfile.log" to quickly bring the log to an editor towards the last line for quick editing of recent logging, or to backup the log file in /log/Backups.
