![](https://i.yapx.ru/RTuEU.jpg)


## Explorers
PingPub - https://explorer.stake-take.com/cardchain/staking
## One line script for full install
```
curl -s https://raw.githubusercontent.com/StakeTake/guidecosmos/main/CrowdControl/Cardchain/crowd > crowd.sh && chmod +x crowd.sh && ./crowd.sh
```
To install, you just need to take the script and go through the installation order
### Please save your mnemonic and backup $HOME/.Cardchain/config/priv_validator_key.json
#### For example mnemonic phrase:
![image](https://user-images.githubusercontent.com/93165931/184551172-16cb2f1a-3145-4e5b-8092-c966e2f3e5ef.png)

## Snapshot height 294097 0.4gb
```
sudo systemctl stop Cardchain
Cardchain unsafe-reset-all --home $HOME/.Cardchain
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="10"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.Cardchain/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.Cardchain/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.Cardchain/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.Cardchain/config/app.toml
wget -O $HOME/.Cardchain/config/addrbook.json "https://raw.githubusercontent.com/StakeTake/guidecosmos/main/CrowdControl/Cardchain/addrbook.json"
cd
rm -rf ~/.Cardchain/data; \
wget -O - http://snap.stake-take.com:8000/crowdcontrol.tar.gz | tar xf -
mv $HOME/root/.Cardchain/data $HOME/.Cardchain
rm -rf $HOME/root
sudo systemctl restart Cardchain && journalctl -u Cardchain -f -o cat
```
## Start with state sync
```
sudo systemctl stop Cardchain
Cardchain unsafe-reset-all
wget -O $HOME/.Cardchain/config/addrbook.json "https://raw.githubusercontent.com/StakeTake/guidecosmos/main/CrowdControl/Cardchain/addrbook.json"
SEEDS=""
PEERS="a89083b131893ca8a379c9b18028e26fa250473c@159.69.11.174:36656"; \
sed -i.bak -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.Cardchain/config/config.toml
SNAP_RPC="http://cc.stake-take.com:36657"
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 2000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)
echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"| ; \
s|^(seeds[[:space:]]+=[[:space:]]+).*$|\1\"\"|" $HOME/.Cardchain/config/config.toml
sudo systemctl restart Cardchain && journalctl -u Cardchain -f -o cat
```
## Add addrbook
```
sudo systemctl stop Cardchain
rm $HOME/.Cardchain/config/addrbook.json
wget -O $HOME/.Cardchain/config/addrbook.json "https://raw.githubusercontent.com/StakeTake/guidecosmos/main/CrowdControl/Cardchain/addrbook.json"
sudo systemctl restart Cardchain && journalctl -u Cardchain -f -o cat
```
## RPC
```
http://cc.stake-take.com:36657
```
## Delete node
```
sudo systemctl stop Cardchain && sudo systemctl disable Cardchain
rm -rf $HOME/Cardchain $HOME/.Cardchain /etc/systemd/system/Cardchain.service /usr/local/bin/Cardchain
```
