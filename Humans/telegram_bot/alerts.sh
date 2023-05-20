#!/bin/bash

# File name for saving parameters, e.g. "cosmos.log"
LOG_FILE="$HOME/alerts/nodealerts.log"
# Your node RPC address, e.g. "http://127.0.0.1:26657"
NODE_RPC="http://127.0.0.1:26657"
source 
# Trusted node RPC address, e.g. "https://rpc.cosmos.network:26657"
SIDE_RPC="https://rpc.humans.stake-take.com:443"
ip=$(wget -qO- eth0.me)

touch $LOG_FILE
REAL_BLOCK=$(curl -s "$SIDE_RPC/status" | jq '.result.sync_info.latest_block_height' | xargs )
STATUS=$(curl -s "$NODE_RPC/status")
CATCHING_UP=$(echo $STATUS | jq '.result.sync_info.catching_up')
LATEST_BLOCK=$(echo $STATUS | jq '.result.sync_info.latest_block_height' | xargs )
VOTING_POWER=$(echo $STATUS | jq '.result.validator_info.voting_power' | xargs )
ADDRESS=$(echo $STATUS | jq '.result.validator_info.address' | xargs )
source $LOG_FILE
#REAL_BLOCK=350000
#VOTING_POWER=150

echo 'LAST_BLOCK="'"$LATEST_BLOCK"'"' > $LOG_FILE
echo 'LAST_POWER="'"$VOTING_POWER"'"' >> $LOG_FILE

source $HOME/.bash_profile
curl -s "$NODE_RPC/status"> /dev/null
if [[ $? -ne 0 ]]; then
    MSG="$ip node is stopped!!! ( узел остановлен )"
    MSG="$NODENAME $MSG"
    SEND=$(curl -s -X POST -H "Content-Type:multipart/form-data" "https://api.telegram.org/bot$TG_API/sendMessage?chat_id=$TG_ID&text=$MSG"); exit 1
fi

if [[ $LAST_POWER -ne $VOTING_POWER ]]; then
    DIFF=$(($VOTING_POWER - $LAST_POWER))
    if [[ $DIFF -gt 0 ]]; then
        DIFF="%2B$DIFF"
    fi
    MSG="$ip voting power changed ( размер стейка валидатора изменился ) $DIFF%0A($LAST_POWER -> $VOTING_POWER)"
fi

if [[ $LAST_BLOCK -ge $LATEST_BLOCK ]]; then

    MSG="$ip node is probably stuck at block (узел застрял в блоке номер>> ) $LATEST_BLOCK"
fi

if [[ $VOTING_POWER -lt 1 ]]; then
    MSG="$ip validator inactive\jailed ( валидатор не активен\в тюрьме ). Voting power $VOTING_POWER"
fi

if [[ $CATCHING_UP = "true" ]]; then
    MSG="$ip node is unsync, catching up ( узел находится в процессе синхронизации ). $LATEST_BLOCK -> $REAL_BLOCK"
fi

if [[ $REAL_BLOCK -eq 0 ]]; then
    MSG="$ip can't connect to ( пропало соединения с рпц нодой ) $SIDE_RPC"
fi

if [[ $MSG != "" ]]; then
    MSG="$NODENAME $MSG"
    SEND=$(curl -s -X POST -H "Content-Type:multipart/form-data" "https://api.telegram.org/bot$TG_API/sendMessage?chat_id=$TG_ID&text=$MSG")
fi
