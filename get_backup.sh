#!/bin/bash

#CUSTOM FULL AND SELECTIVE WEBSITES BACKUP BASH SCRIPT
# Xenos (xkon) Konstantinos - https://xkon.gr

# ------- DECLARE BACKUPS  ------- #
declare -A backups

backups[1,WEBSITE]=whatever.gr
backups[1,DATABASE]=whatever_db
backups[1,CPACC]=whatvr
backups[1,FOLDER]=public_html

backups[2,WEBSITE]=whatever-2.gr
backups[2,DATABASE]=whatever2_db
backups[2,CPACC]=whatvr2
backups[2,FOLDER]=public_html

# TOTAL SITES
TOTALSITES=2

# ------- END DECLARE BACKUPS  ------- #

##################################
# DO NOT EDIT AFTER THIS MESSAGE #
##################################
# ------- GENERAL VARS ------- #

DATE=$(date '+%d-%m-%Y_%H-%M-%S')
LOOPSITES=$((TOTALSITES+1))

# ------- START SIGNLE BACKUP FUNCTION ------- #
function get_backup() {
  if [ "$BACKUPTYPE" == "FULLBACKUP" ]
    then
      BACKUPFOLDER=/WEBSITE_BACKUPS/${DATE}
      mkdir $BACKUPFOLDER
      cd $BACKUPFOLDER
    else
      BACKUPFOLDER=/WEBSITE_BACKUPS
      cd $BACKUPFOLDER
  fi
  printf " \r\n"
  printf "========================================================\r\n"
  printf "${DATE}_$2 - Backup Start\r\n"
  printf "========================================================\r\n"
  sleep 2
  if [ "$3" != 'NONE' ]
  then
    printf " \r\n"
    printf "Exporting Database > ${DATE}_$2.sql.gz\r\n"
    sleep 2
    mysqldump $3 | gzip -c > ${DATE}_$2.sql.gz 
    sleep 2
  fi
  printf " \r\n"
  printf "Creating Files Archive > ${DATE}_$2.tar.gz\r\n"
  sleep 2
  touch ${DATE}_$2.tar.gz
  tar -zcvf "${DATE}_$2.tar.gz" /home/$1/$4 >> ${DATE}_$2.log
  sleep 2
  printf " \r\n"
  printf "\r\nLog Created > ${DATE}_$2.log\r\n"
  printf " \r\n"
  printf "========================================================\r\n"
  printf "${DATE}_$2 - Backup Done\r\n"
  printf "========================================================\r\n"
  printf " \r\n"
}
# ------- END SIGNLE BACKUP FUNCTION ------- #

# ------- START BACKUPS ------- #

if [ -z "$1" ]
  then
    printf "a | all ) all ( $TOTALSITES websites )\r\n"
    printf "e | exit ) exit\r\n"
    for ((n=1;n<$LOOPSITES;n++))
    do
      printf "$n ) ${backups[$n,WEBSITE]}\r\n"
    done
    read -p "Input an option: " o
    case $o in
        a|all )
          BACKUPTYPE=FULLBACKUP
          for ((n=1;n<$LOOPSITES;n++))
          do
            get_backup ${backups[$n,CPACC]} ${backups[$n,WEBSITE]} ${backups[$n,DATABASE]} ${backups[$n,FOLDER]}
          done
          exit
        ;;
        e|exit )
          exit
        ;;
        * )
         BACKUPTYPE=SINGLEBACKUP
         get_backup ${backups[$o,CPACC]} ${backups[$o,WEBSITE]} ${backups[$o,DATABASE]} ${backups[$o,FOLDER]}
         exit
        ;;
    esac
  else
    case $1 in
         a|all )
          BACKUPTYPE=FULLBACKUP
           for ((n=1;n<$LOOPSITES;n++))
           do
             get_backup ${backups[$n,CPACC]} ${backups[$n,WEBSITE]} ${backups[$n,DATABASE]} ${backups[$n,FOLDER]}
           done
           exit
         ;;
         e|exit )
           exit
         ;;
         * )
          BACKUPTYPE=SINGLEBACKUP
          get_backup ${backups[$1,CPACC]} ${backups[$1,WEBSITE]} ${backups[$1,DATABASE]} ${backups[$1,FOLDER]}
          exit
         ;;
     esac
fi

# ------- END BACKUPS ------- #

# ------------------- EOF ------------------- #