![](https://i.yapx.ru/RTuEU.jpg)


## Explorers
NodesGuru - https://pylons.explorers.guru
## One line script for full install
```
curl -s https://raw.githubusercontent.com/StakeTake/guidecosmos/main/Pylons-tech/pylons-testnet-3/pylons > pylons.sh && chmod +x pylons.sh && ./pylons.sh
```
To install, you just need to take the script and go through the installation order
### Please save your mnemonic and backup $HOME/.pylons/config/priv_validator_key.json
#### For example mnemonic phrase:
![image](https://user-images.githubusercontent.com/93165931/184551172-16cb2f1a-3145-4e5b-8092-c966e2f3e5ef.png)
## Snapshot height 1928309 0.2gb
```
sudo systemctl stop pylonsd
pylonsd tendermint unsafe-reset-all --home $HOME/.pylons --keep-addr-book
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="10"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.pylons/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.pylons/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.pylons/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.pylons/config/app.toml
cd
rm -rf ~/.pylons/data; \
wget -O - http://snap.stake-take.com:8000/pylons.tar.gz | tar xf -
mv $HOME/root/.pylons/data $HOME/.pylons
rm -rf $HOME/root
sudo systemctl restart pylonsd && journalctl -u pylonsd -f -o cat
```
## Start with state sync
```
sudo systemctl stop pylonsd
pylonsd tendermint unsafe-reset-all --home $HOME/.pylons
cd $HOME
rm -rf pylons
git clone https://github.com/Pylons-tech/pylons
cd pylons
git pull
git checkout 8650c11
make install
SEEDS=""
PEERS="53dbaa70a1f7769f74e46ada1597f854fd616c2d@stake-take.com:26656,2c50b8171af784f1dca3d37d5dda5e90f1e1add8@95.214.55.4:26656,4f90babf520599ffe606157b0151c4c9bc0ec23f@194.163.172.115:26666,ebecc93e7865036fbdf8d3d54a624941d6e41ba1@104.200.136.57:26656,25e7ef64b41a636e3fb4e9bb1191b785e7d1d5cc@46.166.140.172:26656,2c50b8171af784f1dca3d37d5dda5e90f1e1add8@95.214.55.4:26656,4f90babf520599ffe606157b0151c4c9bc0ec23f@194.163.172.115:26666,ebecc93e7865036fbdf8d3d54a624941d6e41ba1@104.200.136.57:26656,022ee5a5231a5dec014841394f8ce766d657cff5@95.214.53.132:26156,a6972be573807d34f28a337c0f7d599e0014be80@161.97.99.247:26656,515ffd755a92a47b56233143f7c25481dbe99f94@161.97.99.251:26606,9c3261f7859a4f43a72cb9eef8d1fcfc70dc7e7c@95.216.204.255:26656,f6a9cc00142a4ce2fc1cbe536ba7ac9701f0786f@62.113.119.213:11221,665a747edcb6c68d3fe317053bd2cbcae1ef0843@138.201.246.185:26656"; \
sed -i.bak -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.pylons/config/config.toml
wget -O $HOME/.pylons/config/addrbook.json "https://raw.githubusercontent.com/StakeTake/guidecosmos/main/Pylons-tech/pylons-testnet-3/addrbook.json"
SNAP_RPC=http://pylons.stake-take.com:26657
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 2000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)
echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"| ; \
s|^(seeds[[:space:]]+=[[:space:]]+).*$|\1\"\"|" $HOME/.pylons/config/config.toml
sudo systemctl restart pylonsd && journalctl -u pylonsd -f -o cat
```
## Add addrbook
```
sudo systemctl stop pylonsd
rm $HOME/.pylons/config/addrbook.json
wget -O $HOME/.pylons/config/addrbook.json "https://raw.githubusercontent.com/StakeTake/guidecosmos/main/Pylons-tech/pylons-testnet-3/addrbook.json"
sudo systemctl restart pylonsd && journalctl -u pylonsd -f -o cat
```
## RPC
```
http://pylons.stake-take.com:26657
```
## Delete node
```
sudo systemctl stop pylonsd && sudo systemctl disable pylonsd
rm -rf $HOME/pylons $HOME/.pylons /etc/systemd/system/pylonsd.service $(which pylonsd)
```
