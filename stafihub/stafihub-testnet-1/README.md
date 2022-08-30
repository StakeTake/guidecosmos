![](https://i.yapx.ru/RTuEU.jpg)

## Explorers
Ping Pub - https://explorer.stake-take.com/stafihub/staking
## One line script for full install
```
curl -s https://raw.githubusercontent.com/StakeTake/guidecosmos/main/stafihub/stafihub-testnet-1/stafihub > stafihub.sh && chmod +x stafihub.sh && ./stafihub.sh
```
To install, you just need to take the script and go through the installation order
### Please save your mnemonic and backup $HOME/.stafihub/config/priv_validator_key.json
#### For example mnemonic phrase:
![image](https://user-images.githubusercontent.com/93165931/184551172-16cb2f1a-3145-4e5b-8092-c966e2f3e5ef.png)
## Snapshot 265013 height 0.15gb
```
sudo systemctl stop stafihubd
stafihubd tendermint unsafe-reset-all --home $HOME/.stafihub --keep-addr-book
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="10"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.stafihub/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.stafihub/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.stafihub/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.stafihub/config/app.toml
cd
rm -rf ~/.stafihub/data; \
wget -O - http://snap.stake-take.com:8000/stafi.tar.gz | tar xf -
mv $HOME/root/.stafihub/data $HOME/.stafihub
rm -rf $HOME/root
sudo systemctl restart stafihubd && journalctl -u stafihubd -f -o cat
```
## Start via state-sync
```
sudo systemctl stop stafihubd
stafihubd tendermint unsafe-reset-all --home $HOME/.stafihub
wget -O $HOME/.stafihub/config/addrbook.json "https://raw.githubusercontent.com/StakeTake/guidecosmos/main/stafihub/stafihub-testnet-1/addrbook.json"
SNAP_RPC="http://stafi.stake-take.com:16657"
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 1000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"| ; \
s|^(seeds[[:space:]]+=[[:space:]]+).*$|\1\"\"|" $HOME/.stafihub/config/config.toml
sudo systemctl restart stafihubd && journalctl -u stafihubd -f -o cat
```
## Fresh addrbook
```
sudo systemctl stop stafihubd
rm $HOME/.stafihub/config/addrbook.json
wget -O $HOME/.stafihub/config/addrbook.json "https://raw.githubusercontent.com/StakeTake/guidecosmos/main/stafihub/stafihub-testnet-1/addrbook.json"
sudo systemctl restart stafihubd && journalctl -u stafihubd -f -o cat
```
## RPC
```
http://stafi.stake-take.com:16657
```
## Delete node
```
sudo systemctl stop stafihubd && sudo systemctl disable stafihubd
rm -rf $HOME/stafihub $HOME/.stafihub /etc/systemd/system/stafihubd.service $HOME/go/bin/stafihubd
```
