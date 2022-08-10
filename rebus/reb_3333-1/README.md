![](https://i.yapx.ru/RTuEU.jpg)

## Explorers:
Ping Pub - https://exp.nodeist.net/Rebus
## One line script for full install
```
curl -s https://raw.githubusercontent.com/StakeTake/guidecosmos/main/rebus/reb_3333-1/rebus > rebus.sh && chmod +x rebus.sh && ./rebus.sh
```
To install, you just need to take the script and go through the installation order
## Start with state sync
```
sudo systemctl stop rebusd
rebusd tendermint unsafe-reset-all --home ~/.rebusd
SEEDS="a6d710cd9baac9e95a55525d548850c91f140cd9@3.211.101.169:26656,c296ee829f137cfe020ff293b6fc7d7c3f5eeead@54.157.52.47:26656"; \
PEERS=""; \
sed -i.bak -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.gaia/config/config.toml
wget -O $HOME/.rebusd/config/addrbook.json "https://raw.githubusercontent.com/StakeTake/guidecosmos/main/rebus/reb_3333-1/addrbook.json"
SNAP_RPC="https://rpc-t.rebus.nodestake.top:443"
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 2000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)
echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"| ; \
s|^(seeds[[:space:]]+=[[:space:]]+).*$|\1\"\"|" $HOME/.rebusd/config/config.toml
sudo systemctl restart rebusd && journalctl -u rebusd -f -o cat
```
## Delete node
```
sudo systemctl stop rebusd && sudo systemctl disable rebusd
rm -rf $HOME/rebus.core $HOME/.rebusd /etc/systemd/system/rebusd.service $HOME/go/bin/rebusd
```
## RPC
```
http://rebus.stake-take.com:46657, https://rpc-t.rebus.nodestake.top:443
```
