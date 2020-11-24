IT=60
# STARTSCRIPT=$HOME/Minecraft_server/start.sh
SCREEN_NAME='minecraft'

screen -p 0 -S ${SCREEN_NAME} -X eval 'stuff "say '${WAIT}'秒後にサーバーを再起動します\015"'
screen -p 0 -S ${SCREEN_NAME} -X eval 'stuff "say すぐに再接続可能になるので、しばらくお待ち下さい\015"'

sleep $WAIT
screen -p 0 -S ${SCREEN_NAME} -X eval 'stuff "stop\015"'

while [ -n "$(screen -list | grep -o "${SCREEN_NAME}")" ]
do
  sleep 1
done

cd /mnt/hoge/world_backup
DIR=`date '+%Y%m%d_%H%M'`
tar -zcvf $DIR.tar.gz -C $HOME/Minecraft_server world

# $STARTSCRIPT
