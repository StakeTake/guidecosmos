![](https://i.yapx.ru/RTuEU.jpg)


In this guide, we have made setting up a node as easy as possible

    curl -s https://raw.githubusercontent.com/StakeTake/guidecosmos/main/quicksilver/killerqueen/quicksilver > quicksilver.sh && chmod +x quicksilver.sh && ./quicksilver.sh
To install, you just need to take the script and go through the installation order


#START WITH STATE-SYNC

sudo systemctl stop quicksilverd

quicksilverd tendermint unsafe-reset-all --home $HOME/.quicksilverd

external_address=$(wget -qO- eth0.me)
peers=""
sed -i.bak -e "s/^external_address *=.*/external_address = \"$external_address:26656\"/; s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.quicksilverd/config/config.toml
SEEDS="dd3460ec11f78b4a7c4336f22a356fe00805ab64@seed.killerqueen-1.quicksilver.zone:26656,8603d0778bfe0a8d2f8eaa860dcdc5eb85b55982@seed02.killerqueen-1.quicksilver.zone:27676"
sed -i -e "/seeds =/ s/= .*/= \"$SEEDS\"/"  $HOME/.quicksilverd/config/config.toml

SNAP_RPC1="http://node03.killerqueen-1.quicksilver.zone:26657" \
&& SNAP_RPC2="http://node02.killerqueen-1.quicksilver.zone:26657"

LATEST_HEIGHT=$(curl -s $SNAP_RPC2/block | jq -r .result.block.header.height) \
&& BLOCK_HEIGHT=$((LATEST_HEIGHT - 2000)) \
&& TRUST_HASH=$(curl -s "$SNAP_RPC2/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC1,$SNAP_RPC2\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"|" $HOME/.quicksilverd/config/config.toml

sudo systemctl restart quicksilverd && journalctl -u quicksilverd -f -o cat
