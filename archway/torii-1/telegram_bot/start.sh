#!/bin/bash

while true
do

# Logo

echo "============================================================"
curl -s https://raw.githubusercontent.com/StakeTake/script/main/logo.sh | bash
echo "============================================================"


PS3='Select an action: '
options=(
"Setup parametrs for bot" 
"Start bot"
"Exit")
select opt in "${options[@]}"
               do
                   case $opt in
                   
"Setup parametrs for bot")
echo "============================================================"
echo "Setup your Telegramm API"
echo "============================================================"
read TG_API
echo export TG_API=${TG_API} >> $HOME/.bash_profile
echo "============================================================"
echo "Setup your Chat ID"
echo "============================================================"
read TG_ID
echo export TG_ID=${TG_ID} >> $HOME/.bash_profile
source $HOME/.bash_profile

mkdir $HOME/alerts
wget -O $HOME/alerts/alerts.sh https://raw.githubusercontent.com/StakeTake/guidecosmos/main/archway/torii-1/telegram_bot/alerts.sh
chmod +x $HOME/alerts/alerts.sh
break
;;
            
"Start bot")
echo "============================================================"
echo "Bot strating"
echo "============================================================"

crontab -e

break
;;

"Exit")
exit
;;

*) echo "invalid option $REPLY";;
esac
done
done
