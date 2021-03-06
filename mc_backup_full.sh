#!/bin/bash

SERVICE='minecraft_server.1.16.4.jar'
USERNAME='root'
SCNAME='minecraft'
MC_PATH='/opt/minecraft_server'
BK_PATH='/home/minecraft/mc_backup'
 
BK_TIME=`date +%Y%m%d-%H%M%S`
BK_NAME="$BK_PATH/mc_backup_full_${BK_TIME}.tar.gz"
BK_GEN="3"
 
XMX="4G"
XMS="2G"
 
 
cd $MC_PATH
 
ME=`whoami`
 
if [ $ME == $USERNAME ] ; then
  if pgrep -u $USERNAME -f $SERVICE > /dev/null
    then
      echo "Full backup start minecraft data..."
      screen -p 0 -S $SCNAME -X eval 'stuff "say SERVER SHUTTING DOWN IN 10 SECONDS. Saving map..."\015'
      sleep 10
      screen -p 0 -S $SCNAME -X eval 'stuff "save-all"\015'
      screen -p 0 -S $SCNAME -X eval 'stuff "stop"\015'
      echo "Stopped minecraft_server"
      echo "Full Backup start ..."
      tar cfvz $BK_NAME $MC_PATH
      git add $MC_PATH
      git commit -m "update $BK_TIME"
      git push origin master
      sleep 10
      echo "Full Backup compleate!"
      find $BK_PATH -name "mc_backup_full*.tar.gz" -type f -mtime +$BK_GEN -exec rm {} \;
      echo "Starting $SERVICE..."
      screen -AmdS $SCNAME java -Xmx$XMX -Xms$XMS -jar $SERVICE nogui
    else
      echo "$SERVICE was not runnning."
  fi
else
  echo "Please run the $USERNAME user."
fi
