![](https://i.yapx.ru/RTuEU.jpg)


In this guide, we have made setting up a node as easy as possible

    curl -s https://raw.githubusercontent.com/StakeTake/guidecosmos/main/quicksilver/killerqueen/quicksilver > quicksilver.sh && chmod +x quicksilver.sh && ./quicksilver.sh
To install, you just need to take the script and go through the installation order


#START WITH STATE-SYNC
```
sudo systemctl stop quicksilverd
quicksilverd tendermint unsafe-reset-all --home $HOME/.quicksilverd

wget -O $HOME/.quicksilverd/config/addrbook.json "https://raw.githubusercontent.com/StakeTake/guidecosmos/main/quicksilver/killerqueen/addrbook.json"
SNAP_RPC1="http://144.76.224.246:26656:26657" \
&& SNAP_RPC2="http://144.76.224.246:26656:26657"
LATEST_HEIGHT=$(curl -s $SNAP_RPC2/block | jq -r .result.block.header.height) \
&& BLOCK_HEIGHT=$((LATEST_HEIGHT - 500)) \
&& TRUST_HASH=$(curl -s "$SNAP_RPC2/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC1,$SNAP_RPC2\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"|" $HOME/.quicksilverd/config/config.toml
sudo systemctl restart quicksilverd && journalctl -u quicksilverd -f -o cat
```

