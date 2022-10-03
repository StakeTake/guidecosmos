![](https://i.yapx.ru/RTuEU.jpg)


## Explorers: 
PingPub - https://explorer.stake-take.com/ollo-testnet/staking
## One line script for full install
```
curl -s https://raw.githubusercontent.com/StakeTake/guidecosmos/main/ollo/ollo-testnet-0/ollo > ollo.sh && chmod +x ollo.sh && ./ollo.sh
```
To install, you just need to take the script and go through the installation order
### Please save your mnemonic and backup $HOME/.ollo/config/priv_validator_key.json
#### For example mnemonic phrase:
![image](https://user-images.githubusercontent.com/93165931/184551172-16cb2f1a-3145-4e5b-8092-c966e2f3e5ef.png)

## Snapshot 2113204 height 1gb
```
sudo systemctl stop ollod
ollod tendermint unsafe-reset-all --home $HOME/.ollo --keep-addr-book
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="10"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.ollo/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.ollo/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.ollo/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.ollo/config/app.toml
cd
rm -rf ~/.ollo/data; \
wget -O - http://snap.stake-take.com:8000/ollo.tar.gz | tar xf -
mv $HOME/root/.ollo/data $HOME/.ollo
rm -rf $HOME/root
sudo systemctl restart ollod && journalctl -u ollod -f -o cat
```
## Start with state sync
```
sudo systemctl stop ollod
ollod tendermint unsafe-reset-all --home $HOME/.ollo
SEEDS=""; \
PEERS=""; \
sed -i.bak -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.ollo/config/config.toml
wget -O $HOME/.ollo/config/addrbook.json "https://raw.githubusercontent.com/StakeTake/guidecosmos/main/ollo/ollo-testnet-0/addrbook.json"
SNAP_RPC="http://ollo.stake-take.com:16657"
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 500)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)
echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"| ; \
s|^(seeds[[:space:]]+=[[:space:]]+).*$|\1\"\"|" $HOME/.ollo/config/config.toml
sudo systemctl restart ollod && journalctl -u ollod -f -o cat
```
## Add addrbook
```
sudo systemctl stop ollod
rm $HOME/.ollo/config/addrbook.json
wget -O $HOME/.ollo/config/addrbook.json "https://raw.githubusercontent.com/StakeTake/guidecosmos/main/ollo/ollo-testnet-0/addrbook.json"
sudo systemctl restart ollod && journalctl -u ollod -f -o cat
```
## RPC
```
http://ollo.stake-take.com:16657
```
## Delete node
```
sudo systemctl stop ollod && sudo systemctl disable ollod
rm -rf /etc/systemd/system/ollod.service $HOME/.ollo /usr/bin/ollod $HOME/go/bin/ollod
```

