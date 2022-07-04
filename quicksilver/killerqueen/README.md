![](https://i.yapx.ru/RTuEU.jpg)


In this guide, we have made setting up a node as easy as possible

    curl -s https://raw.githubusercontent.com/StakeTake/guidecosmos/main/quicksilver/killerqueen/quicksilver > quicksilver.sh && chmod +x quicksilver.sh && ./quicksilver.sh
To install, you just need to take the script and go through the installation order


#START WITH STATE-SYNC

sudo systemctl stop quicksilverd

quicksilverd tendermint unsafe-reset-all

external_address=$(wget -qO- eth0.me)
peers="b281289df37c5180f9ff278be5e29964afa0c229@185.56.139.84:26656,4f35ab6008fc46cc50b103a337ec2266400eca2e@148.251.50.79:26656,90f4459126152d21983f42c8e86bc899cd618af6@116.202.15.183:11656,6ac91620bc5338e6f679835cc604769a213d362f@139.59.56.24:36366,f9d2dbf6c80f08d12d1bc8d07ffd3bafa4965160@95.214.55.43:26651,abe7397ff92a4ca61033ceac127b5fc3a9a4217f@65.108.98.218:25095,07bb0fd7af9dc819bb5bb850ea5d870281c3adfa@167.235.74.230:26656"
sed -i.bak -e "s/^external_address *=.*/external_address = \"$external_address:26656\"/; s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.quicksilverd/config/config.toml


SNAP_RPC1="http://node02.killerqueen-1.quicksilver.zone:26657" \
&& SNAP_RPC2="http://node04.killerqueen-1.quicksilver.zone:26657"

LATEST_HEIGHT=$(curl -s $SNAP_RPC1/block | jq -r .result.block.header.height) \
&& BLOCK_HEIGHT=$((LATEST_HEIGHT - 2000)) \
&& TRUST_HASH=$(curl -s "$SNAP_RPC1/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC1,$SNAP_RPC2\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"|" $HOME/.quicksilverd/config/config.toml

sudo systemctl restart quicksilverd
