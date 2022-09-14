![](https://i.yapx.ru/RTuEU.jpg)

## Explorers:
Ping Pub - https://explorer.stake-take.com/rebus-mainnet/staking
## One line script for full install
```
curl -s https://raw.githubusercontent.com/StakeTake/guidecosmos/main/rebus/reb_1111-1/rebus > rebus.sh && chmod +x rebus.sh && ./rebus.sh
```
To install, you just need to take the script and go through the installation order
### Please save your mnemonic and backup $HOME/.rebusd/config/priv_validator_key.json
#### For example mnemonic phrase:
![image](https://user-images.githubusercontent.com/93165931/184551172-16cb2f1a-3145-4e5b-8092-c966e2f3e5ef.png)
## Start with state sync
```
sudo systemctl stop rebusd
rebusd tendermint unsafe-reset-all --home ~/.rebusd
SEEDS=""; \
PEERS=""; \
sed -i.bak -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.rebusd/config/config.toml
wget -O $HOME/.rebusd/config/addrbook.json "https://raw.githubusercontent.com/StakeTake/guidecosmos/main/rebus/reb_1111-1/addrbook.json"
SNAP_RPC="https://rebus.rpc.manticore.team:443"
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
## Add addrbook
```
sudo systemctl stop rebusd
rm $HOME/.rebusd/config/addrbook.json
wget -O $HOME/.rebusd/config/addrbook.json "https://raw.githubusercontent.com/StakeTake/guidecosmos/main/rebus/reb_1111-1/addrbook.json"
sudo systemctl restart rebusd && journalctl -u rebusd -f -o cat
```
## RPC
```
https://rebus.rpc.manticore.team
```
## Delete node
```
sudo systemctl stop rebusd && sudo systemctl disable rebusd
rm -rf $HOME/rebus.core $HOME/.rebusd /etc/systemd/system/rebusd.service $(which rebusd)
```

