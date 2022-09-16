![](https://i.yapx.ru/RTuEU.jpg)


## Explorers:
Ping Pub - https://explorer.stake-take.com/umeemania/staking  
## OneLine script of full install
```
curl -s https://raw.githubusercontent.com/StakeTake/guidecosmos/main/umee/canon-1/umee > umee.sh && chmod +x umee.sh && ./umee.sh
```
To install, you just need to take the script and go through the installation order
### Please save your mnemonic and backup $HOME/.umee/config/priv_validator_key.json
#### For example mnemonic phrase:
![image](https://user-images.githubusercontent.com/93165931/184551172-16cb2f1a-3145-4e5b-8092-c966e2f3e5ef.png)
## Start with state sync
```
sudo systemctl stop umeed
umeed unsafe-reset-all --home $HOME/.umee
SEEDS=""
PEERS="dc1b1b89a83873f20b613cdb1361f932afb84a97@35.215.72.45:26656,94ac8328b4b9f45b6f7b8e9569ae0253dc53c7eb@35.212.143.125:26656,5e01b69ead6e0781af0361d3ec4e436d96dba932@35.215.98.106:26656"; \
sed -i.bak -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.umee/config/config.toml
SNAP_RPC="http://umee.stake-take.com:16657"
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 2000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)
echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"| ; \
s|^(seeds[[:space:]]+=[[:space:]]+).*$|\1\"\"|" $HOME/.umee/config/config.toml
#wget -O $HOME/.umee/config/addrbook.json "https://raw.githubusercontent.com/StakeTake/guidecosmos/main/umee/canon-1/addrbook.json"
sudo systemctl restart umeed && journalctl -u umeed -f -o cat
```
## Add addrbook
```
sudo systemctl stop umeed
rm $HOME/.umee/config/addrbook.json
wget -O $HOME/.umee/config/addrbook.json "https://raw.githubusercontent.com/StakeTake/guidecosmos/main/umee/canon-1/addrbook.json"
sudo systemctl restart umeed && journalctl -u umeed -f -o cat
```
## RPC
```
http://umee.stake-take.com:16657
```
## Delete node
```
sudo systemctl stop umeed && sudo systemctl disable umeed
rm -rf $HOME/umee $HOME/.umee /etc/systemd/system/umeed.service $(which umeed)
```
