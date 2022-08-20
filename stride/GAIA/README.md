![](https://i.yapx.ru/RTuEU.jpg)

## Explorers:
Ping Pub - https://poolparty.stride.zone/GAIA
## One line script for full install
```
curl -s https://raw.githubusercontent.com/StakeTake/guidecosmos/main/stride/GAIA/gaia > gaia.sh && chmod +x gaia.sh && ./gaia.sh
```
To install, you just need to take the script and go through the installation order
### Please save your mnemonic and backup $HOME/.gaia/config/priv_validator_key.json
#### For example mnemonic phrase:
![image](https://user-images.githubusercontent.com/93165931/184551172-16cb2f1a-3145-4e5b-8092-c966e2f3e5ef.png)
## Start with state sync
```
sudo systemctl stop gaiad
gaiad tendermint unsafe-reset-all --home $HOME/.gaia
SEEDS=""; \
PEERS="5b1bd3fb081c79b7bdc5c1fd0a3d90928437266a@78.107.234.44:36656"; \
sed -i.bak -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.gaia/config/config.toml
wget -O $HOME/.gaia/config/addrbook.json "https://raw.githubusercontent.com/StakeTake/guidecosmos/main/stride/GAIA/addrbook.json"
SNAP_RPC="http://stride.stake-take.com:46657"
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 2000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)
echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"| ; \
s|^(seeds[[:space:]]+=[[:space:]]+).*$|\1\"\"|" $HOME/.gaia/config/config.toml
sudo systemctl restart gaiad && journalctl -u gaiad -f -o cat
```
## Add addrbook
```
sudo systemctl stop gaiad
rm $HOME/.gaia/config/addrbook.json
wget -O $HOME/.gaia/config/addrbook.json "https://raw.githubusercontent.com/StakeTake/guidecosmos/main/stride/GAIA/addrbook.json"
sudo systemctl restart gaiad && journalctl -u gaiad -f -o cat
```
## RPC
```
https://gaia-fleet.poolparty.stridenet.co:443, http://stride.stake-take.com:46657
```
## Delete node
```
sudo systemctl stop gaiad && sudo systemctl disable gaiad
rm -rf $HOME/gaia $HOME/.gaia /etc/systemd/system/gaiad.service $(which gaiad)
```

