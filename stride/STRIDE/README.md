![](https://i.yapx.ru/RTuEU.jpg)


In this guide, we have made setting up a node as easy as possible

    curl -s https://raw.githubusercontent.com/StakeTake/guidecosmos/main/stride/STRIDE/stride > stride.sh && chmod +x stride.sh && ./stride.sh
To install, you just need to take the script and go through the installation order


#START WITH STATE-SYNC

sudo systemctl stop strided

strided tendermint unsafe-reset-all

external_address=$(wget -qO- eth0.me)
peers="c73d5d83ae121dd9f2ebbfd381724c844a5e5106@stride-node1.poolparty.stridenet.co:26656"
sed -i.bak -e "s/^external_address *=.*/external_address = \"$external_address:26656\"/; s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.stride/config/config.toml


SNAP_RPC1="https://stride-node3.poolparty.stridenet.co:445" \
&& SNAP_RPC2="https://stride-node3.poolparty.stridenet.co:445"

LATEST_HEIGHT=$(curl -s $SNAP_RPC1/block | jq -r .result.block.header.height) \
&& BLOCK_HEIGHT=$((LATEST_HEIGHT - 2000)) \
&& TRUST_HASH=$(curl -s "$SNAP_RPC1/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC1,$SNAP_RPC2\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"|" $HOME/.stride/config/config.toml

sudo systemctl restart strided
