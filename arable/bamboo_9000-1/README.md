![](https://i.yapx.ru/RTuEU.jpg)


## Explorers:
Ping Pub - https://explorer.stake-take.com/acre-testnet/staking
## One line script for full install
```
curl -s https://raw.githubusercontent.com/StakeTake/guidecosmos/main/arable/bamboo_9000-1/arable > arable.sh && chmod +x arable.sh && ./arable.sh
```
To install, you just need to take the script and go through the installation order
### Please save your mnemonic and backup $HOME/.acred/config/priv_validator_key.json
#### For example mnemonic phrase:
![image](https://user-images.githubusercontent.com/93165931/184551172-16cb2f1a-3145-4e5b-8092-c966e2f3e5ef.png)
## Snapshot 28750 height 0.1gb
```
sudo systemctl stop acred
acred tendermint unsafe-reset-all --home $HOME/.acred --keep-addr-book
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="10"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.acred/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.acred/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.acred/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.acred/config/app.toml
cd
rm -rf ~/.acred/data; \
wget -O - http://snap.stake-take.com:8000/arable.tar.gz | tar xf -
mv $HOME/root/.acred/data $HOME/.acred
rm -rf $HOME/root
sudo systemctl restart acred && journalctl -u acred -f -o cat
```
## Start with state sync
```
sudo systemctl stop acred
acred tendermint unsafe-reset-all --home $HOME/.acred
SEEDS=""
PEERS="44dd124ca34742245ad906f9f6ea377fae3af0cf@168.100.9.100:26656,6477921cdd4ba4503a1a2ff1f340c9d6a0e7b4a0@168.100.10.133:26656,9b53496211e75dbf33680b75e617830e874c8d93@168.100.8.9:26656,c55d79d6f76045ff7b68dc2bf6655348ebbfd795@168.100.8.60:26656"; \
sed -i.bak -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.acred/config/config.toml
SNAP_RPC="http://arable.stake-take.com:46657"
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 500)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)
echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"| ; \
s|^(seeds[[:space:]]+=[[:space:]]+).*$|\1\"\"|" $HOME/.acred/config/config.toml
sudo systemctl restart acred && journalctl -u acred -f -o cat
```
## Add addrbook
```
sudo systemctl stop acred
rm $HOME/.acred/config/addrbook.json
wget -O $HOME/.acred/config/addrbook.json "https://raw.githubusercontent.com/StakeTake/guidecosmos/main/arable/bamboo_9000-1/addrbook.json"
sudo systemctl restart acred && journalctl -u acred -f -o cat
```
## RPC
```
http://arable.stake-take.com:46657, https://rpc-t.acre.nodestake.top:443
```
## Delete node
```
sudo systemctl stop acred && sudo systemctl disable acred
rm -rf $HOME/acrechain $HOME/.acred /etc/systemd/system/acred.service $(which acred)
```
