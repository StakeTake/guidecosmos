![](https://i.yapx.ru/RTuEU.jpg)


## One line script for full install
```
curl -s https://raw.githubusercontent.com/StakeTake/guidecosmos/main/stride/STRIDE-1/stride > stride.sh && chmod +x stride.sh && ./stride.sh
```
To install, you just need to take the script and go through the installation order
## RPC
```
http://stride.stake-take.com:46657
```
## Start with state sync
```
sudo systemctl stop strided
strided tendermint unsafe-reset-all --home $HOME/.stride
SEEDS=""; \
PEERS="69249bb18f5cae0616338e78d91036d60358dc4b@23.88.100.175:46656"; \
sed -i.bak -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.stride/config/config.toml
wget -O $HOME/.stride/config/addrbook.json "https://raw.githubusercontent.com/StakeTake/guidecosmos/main/stride/STRIDE-1/addrbook.json"
SNAP_RPC=http://stride.stake-take.com:46657
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 2000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)
echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"| ; \
s|^(seeds[[:space:]]+=[[:space:]]+).*$|\1\"\"|" $HOME/.stride/config/config.toml
sudo systemctl restart strided && journalctl -u strided -f -o cat
```
## Delete node
```
sudo systemctl stop strided && sudo systemctl disable strided
rm -rf $HOME/stride $HOME/.stride /etc/systemd/system/strided.service $HOME/go/bin/strided
```
