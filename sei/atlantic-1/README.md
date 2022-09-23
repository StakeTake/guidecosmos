![](https://i.yapx.ru/RTuEU.jpg)


## Explorers
NodesGuru - https://sei.explorers.guru
## One line script for full install
```
curl -s https://raw.githubusercontent.com/StakeTake/guidecosmos/main/sei/atlantic-1/sei > sei.sh && chmod +x sei.sh && ./sei.sh
```
To install, you just need to take the script and go through the installation order
### Please save your mnemonic and backup $HOME/.sei/config/priv_validator_key.json
#### For example mnemonic phrase:
![image](https://user-images.githubusercontent.com/93165931/184551172-16cb2f1a-3145-4e5b-8092-c966e2f3e5ef.png)
## Snapshot height 6211685 3gb 
```
sudo systemctl stop seid
seid tendermint unsafe-reset-all --home $HOME/.sei --keep-addr-book
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="10"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.sei/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.sei/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.sei/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.sei/config/app.toml
cd
rm -rf ~/.sei/data; \
wget -O - http://snap.stake-take.com:8000/sei.tar.gz | tar xf -
mv $HOME/root/.sei/data $HOME/.sei
rm -rf $HOME/root
sudo systemctl restart seid && journalctl -u seid -f -o cat
```
## Start with state sync
```
sudo systemctl stop seid
seid tendermint unsafe-reset-all --home $HOME/.sei
wget -O $HOME/.sei/config/addrbook.json "https://raw.githubusercontent.com/StakeTake/guidecosmos/main/sei/atlantic-1/addrbook.json"
SEEDS="df1f6617ff5acdc85d9daa890300a57a9d956e5e@sei-atlantic-1.seed.rhinostake.com:16660"
PEERS="e3b5da4caea7370cd85d7738eedaec8f56c5be28@144.76.224.246:36656,a37d65086e78865929ccb7388146fb93664223f7@18.144.13.149:26656,8ff4bd654d7b892f33af5a30ada7d8239d6f467b@91.223.3.190:51656,c4e8c9b1005fe6459a922f232dd9988f93c71222@65.108.227.133:26656"; \
sed -i.bak -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.sei/config/config.toml
SNAP_RPC="http://sei.stake-take.com:20657"
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 1000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"| ; \
s|^(seeds[[:space:]]+=[[:space:]]+).*$|\1\"\"|" $HOME/.sei/config/config.toml
sudo systemctl restart seid && journalctl -u seid -f -o cat
```
## Add addrbook
```
sudo systemctl stop seid
rm $HOME/.sei/config/addrbook.json
wget -O $HOME/.sei/config/addrbook.json "https://raw.githubusercontent.com/StakeTake/guidecosmos/main/sei/atlantic-1/addrbook.json"
sudo systemctl restart seid && journalctl -u seid -f -o cat
```
## RPC
```
http://sei.stake-take.com:20657
```
## Delete node
```
sudo systemctl stop seid && sudo systemctl disable seid
rm -rf $HOME/sei-chain $HOME/.sei /etc/systemd/system/seid.service $(which seid)
```
