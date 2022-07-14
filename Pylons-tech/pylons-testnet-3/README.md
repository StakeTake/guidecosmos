![](https://i.yapx.ru/RTuEU.jpg)


In this guide, we have made setting up a node as easy as possible

    curl -s https://raw.githubusercontent.com/StakeTake/guidecosmos/main/Pylons-tech/pylons-testnet-3/pylons > pylons.sh && chmod +x pylons.sh && ./pylons.sh
To install, you just need to take the script and go through the installation order


#START WITH STATE-SYNC
```
sudo systemctl stop pylonsd
pylonsd tendermint unsafe-reset-all --home $HOME/.pylons
SEEDS=""; \
PEERS="53dbaa70a1f7769f74e46ada1597f854fd616c2d@http://pylons.stake-take.com:26656"; \
sed -i.bak -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.pylons/config/config.toml
wget -O $HOME/.pylons/config/addrbook.json "https://raw.githubusercontent.com/StakeTake/guidecosmos/main/Pylons-tech/pylons-testnet-3/addrbook.json"
SNAP_RPC=http://pylons.stake-take.com:26657
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 1000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)
echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"| ; \
s|^(seeds[[:space:]]+=[[:space:]]+).*$|\1\"\"|" $HOME/.pylons/config/config.toml
sudo systemctl restart pylonsd && journalctl -u pylonsd -f -o cat
