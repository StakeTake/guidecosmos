![](https://i.yapx.ru/RTuEU.jpg)


In this guide, we have made setting up a node as easy as possible

    curl -s https://raw.githubusercontent.com/StakeTake/guidecosmos/main/ChronicToken/morocco-1/chtd > chtd.sh && chmod +x chtd.sh && ./chtd.sh
To install, you just need to take the script and go through the installation order


sudo systemctl stop chtd

chtd tendermint unsafe-reset-all --home $HOME/.cht

SEEDS="3f764ecb2f5f9fb6c8922c6ad2fbe1ac44310737@147.182.180.205:26656"
sed -i -e "/seeds =/ s/= .*/= \"$SEEDS\"/"  $HOME/.cht/config/config.toml
peers="f56d9bdb0e5f63edf73ca3e0d281be7298fc6e39@144.76.224.246:46656" 
sed -i.bak -e s/^persistent_peers =./persistent_peers = "$peers"/" $HOME/.cht/config/config.toml

SNAP_RPC=http://144.76.224.246:46657

LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height);
BLOCK_HEIGHT=$((LATEST_HEIGHT - 1000));
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)

echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).$|\1true| ;
s|^(rpc_servers[[:space:]]+=[[:space:]]+).$|\1"$SNAP_RPC,$SNAP_RPC"| ;
s|^(trust_height[[:space:]]+=[[:space:]]+).$|\1$BLOCK_HEIGHT| ;
s|^(trust_hash[[:space:]]+=[[:space:]]+).$|\1"$TRUST_HASH"| ;
s|^(seeds[[:space:]]+=[[:space:]]+).*$|\1""|" $HOME/.cht/config/config.toml

sudo systemctl restart chtd
