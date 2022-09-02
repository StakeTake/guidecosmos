![](https://i.yapx.ru/RTuEU.jpg)


## Explorers:
Ping Pub - https://explorer.stake-take.com/umee/staking  
NodesGuru - https://umee.explorers.guru   
Cosmostation - https://www.mintscan.io/umee
## OneLine script of full install
```
curl -s https://raw.githubusercontent.com/StakeTake/guidecosmos/main/umee/umee-1/umee > umee.sh && chmod +x umee.sh && ./umee.sh
```
To install, you just need to take the script and go through the installation order
### Please save your mnemonic and backup $HOME/.umee/config/priv_validator_key.json
#### For example mnemonic phrase:
![image](https://user-images.githubusercontent.com/93165931/184551172-16cb2f1a-3145-4e5b-8092-c966e2f3e5ef.png)
## Snapshot 2847075  height 1gb
```
sudo systemctl stop umeed
umeed unsafe-reset-all --home $HOME/.umee
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="10"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.umee/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.umee/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.umee/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.umee/config/app.toml
cd
rm -rf ~/.umee/data; \
wget -O - http://snap.stake-take.com:8000/umee.tar.gz | tar xf -
mv $HOME/root/.umee/data $HOME/.umee
rm -rf $HOME/root
wget -O $HOME/.umee/config/addrbook.json "https://raw.githubusercontent.com/StakeTake/guidecosmos/main/umee/umee-1/addrbook.json"
sudo systemctl restart umeed && journalctl -u umeed -f -o cat
```
## Start with state sync
```
sudo systemctl stop umeed
umeed unsafe-reset-all --home $HOME/.umee
SEEDS=""
PEERS=""; \
sed -i.bak -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.umee/config/config.toml
SNAP_RPC="http://rpc.umee.blockscope.net:26657"
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 2000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)
echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"| ; \
s|^(seeds[[:space:]]+=[[:space:]]+).*$|\1\"\"|" $HOME/.umee/config/config.toml
wget -O $HOME/.umee/config/addrbook.json "https://raw.githubusercontent.com/StakeTake/guidecosmos/main/umee/umee-1/addrbook.json"
sudo systemctl restart umeed && journalctl -u umeed -f -o cat
```
## Add addrbook
```
sudo systemctl stop umeed
rm $HOME/.umee/config/addrbook.json
wget -O $HOME/.umee/config/addrbook.json "https://raw.githubusercontent.com/StakeTake/guidecosmos/main/umee/umee-1/addrbook.json"
sudo systemctl restart umeed && journalctl -u umeed -f -o cat
```
## RPC
```
https://rpc.umee.testnet.run:443, http://rpc-umee-0.node75.org:26657, http://rpc.umee.blockscope.net:26657, https://umee-rpc.theamsolutions.info:443, http://5.189.166.167:26657
```
## Delete node
```
sudo systemctl stop umeed && sudo systemctl disable umeed
rm -rf $HOME/umee $HOME/.umee /etc/systemd/system/umeed.service $(which umeed)
```
