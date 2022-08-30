![](https://i.yapx.ru/RTuEU.jpg)

## Explorers:
PingPub - https://explorer.stake-take.com/canto/staking
## One line script for full install
```
curl -s https://raw.githubusercontent.com/StakeTake/guidecosmos/main/canto/canto_7700-1/canto > canto.sh && chmod +x canto.sh && ./canto.sh
```
To install, you just need to take the script and go through the installation order
### Please save your mnemonic and backup $HOME/.cantod/config/priv_validator_key.json
#### For example mnemonic phrase:
![image](https://user-images.githubusercontent.com/93165931/184551172-16cb2f1a-3145-4e5b-8092-c966e2f3e5ef.png)
## Snapshot 486801 height 0.1gb
```
sudo systemctl stop cantod
cantod tendermint unsafe-reset-all --home $HOME/.cantod --keep-addr-book
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="10"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.cantod/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.cantod/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.cantod/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.cantod/config/app.toml
cd
rm -rf ~/.cantod/data; \
wget -O - http://snap.stake-take.com:8000/canto.tar.gz | tar xf -
mv $HOME/root/.cantod/data $HOME/.cantod
rm -rf $HOME/root
sudo systemctl restart cantod && journalctl -u cantod -f -o cat
```
## Start with state sync
```
sudo systemctl stop cantod
cantod tendermint unsafe-reset-all --home $HOME/.cantod
SEEDS=""; \
PEERS=""; \
sed -i.bak -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.cantod/config/config.toml
wget -O $HOME/.cantod/config/addrbook.json "https://raw.githubusercontent.com/StakeTake/guidecosmos/main/canto/canto_7700-1/addrbook.json"
SNAP_RPC="https://rpc.canto.nodestake.top:443"
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 2000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)
echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"| ; \
s|^(seeds[[:space:]]+=[[:space:]]+).*$|\1\"\"|" $HOME/.cantod/config/config.toml
sudo systemctl restart cantod && journalctl -u cantod -f -o cat
```
## Add addrbook
```
sudo systemctl stop cantod
rm $HOME/.cantod/config/addrbook.json
wget -O $HOME/.cantod/config/addrbook.json "https://raw.githubusercontent.com/StakeTake/guidecosmos/main/canto/canto_7700-1/addrbook.json"
sudo systemctl restart cantod && journalctl -u cantod -f -o cat
```
## RPC
```
https://rpc.canto.nodestake.top:443
```
## Delete node
```
sudo systemctl stop cantod && sudo systemctl disable cantod
rm -rf $HOME/Canto $HOME/.cantod /etc/systemd/system/cantod.service $HOME/go/bin/cantod
```
