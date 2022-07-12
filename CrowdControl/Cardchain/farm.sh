# !/bin/bash

for ((x=1; x < 10000000; x++))
do
KEY=$(Cardchain keys show $WALLETNAME -a --keyring-backend test)
curl -X POST https://cardchain.crowdcontrol.network/faucet/ -d "{\"address\": \"$KEY\"}"
sleep 10
done
