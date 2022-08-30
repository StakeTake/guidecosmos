![](https://i.yapx.ru/RTuEU.jpg)


## Explorers
PingPub - https://explorer.stake-take.com/dws/staking
## One line script for full install
```
curl -s https://raw.githubusercontent.com/StakeTake/guidecosmos/main/DWS/deweb-testnet-1/DWS > DWS.sh && chmod +x DWS.sh && ./DWS.sh
```
To install, you just need to take the script and go through the installation order
### Please save your mnemonic and backup $HOME/.deweb/config/priv_validator_key.json
#### For example mnemonic phrase:
![image](https://user-images.githubusercontent.com/93165931/184551172-16cb2f1a-3145-4e5b-8092-c966e2f3e5ef.png)

## Snapshot 1424063 height 0.4gb
```
sudo systemctl stop dewebd
dewebd unsafe-reset-all
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="10"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.deweb/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.deweb/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.deweb/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.deweb/config/app.toml
wget -O $HOME/.deweb/config/addrbook.json "https://raw.githubusercontent.com/StakeTake/guidecosmos/main/DWS/deweb-testnet-1/addrbook.json"
cd
rm -rf ~/.deweb/data; \
wget -O - http://snap.stake-take.com:8000/deweb.tar.gz | tar xf -
mv $HOME/root/.deweb/data $HOME/.deweb
rm -rf $HOME/root
sudo systemctl restart dewebd && journalctl -u dewebd -f -o cat
```
## Start with state sync
```
sudo systemctl stop dewebd
dewebd unsafe-reset-all
SEEDS=""; \
PEERS=""; \
sed -i.bak -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.deweb/config/config.toml
wget -O $HOME/.deweb/config/addrbook.json "https://raw.githubusercontent.com/StakeTake/guidecosmos/main/DWS/deweb-testnet-1/addrbook.json"
SNAP_RPC=http://deweb.stake-take.com:16657
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 1000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)
echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"| ; \
s|^(seeds[[:space:]]+=[[:space:]]+).*$|\1\"\"|" $HOME/.deweb/config/config.toml
sudo systemctl restart dewebd && journalctl -u dewebd -f -o cat
```
## Add addrbook
```
sudo systemctl stop dewebd
rm $HOME/.deweb/config/addrbook.json
wget -O $HOME/.deweb/config/addrbook.json "https://raw.githubusercontent.com/StakeTake/guidecosmos/main/DWS/deweb-testnet-1/addrbook.json"
sudo systemctl restart dewebd && journalctl -u dewebd -f -o cat
```
## RPC
```
http://deweb.stake-take.com:16657, https://rpc-deweb.deweb.services:443
```
## Delete node
```
sudo systemctl stop dewebd && sudo systemctl disable dewebd
rm -rf $HOME/deweb $HOME/.deweb /etc/systemd/system/dewebd.service $HOME/go/bin/dewebd
```
