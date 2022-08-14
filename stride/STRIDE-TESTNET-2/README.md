![](https://i.yapx.ru/RTuEU.jpg)

## Explorers:
Ping Pub - https://poolparty.stride.zone  
NodesGuru - https://stride.explorers.guru   
Cosmostation - https://testnet.mintscan.io/stride-testnet
## One line script for full install
```
curl -s https://raw.githubusercontent.com/StakeTake/guidecosmos/main/stride/STRIDE-TESTNET-2/stride > stride.sh && chmod +x stride.sh && ./stride.sh
```
To install, you just need to take the script and go through the installation order
### Please save your mnemonic and backup $HOME/.stride/config/priv_validator_key.json
#### For example mnemonic phrase:
![image](https://user-images.githubusercontent.com/93165931/184551172-16cb2f1a-3145-4e5b-8092-c966e2f3e5ef.png)
## Snapshot 171593 height 1.4gb
```
sudo systemctl stop strided
strided tendermint unsafe-reset-all --home $HOME/.stride --keep-addr-book
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="10"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.stride/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.stride/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.stride/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.stride/config/app.toml
cd
rm -rf ~/.stride/data; \
wget -O - http://snap.stake-take.com:8000/stride.tar.gz | tar xf -
mv $HOME/root/.stride/data $HOME/.stride
rm -rf $HOME/root
sudo systemctl restart strided && journalctl -u strided -f -o cat
```
## Start with state sync
```
sudo systemctl stop strided
strided tendermint unsafe-reset-all --home $HOME/.stride
SEEDS=""; \
PEERS="48b1310bc81deea3eb44173c5c26873c23565d33@34.135.129.186:26656,0f45eac9af97f4b60d12fcd9e14a114f0c085491@stride-library.poolparty.stridenet.co:26656"; \
sed -i.bak -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.stride/config/config.toml
wget -O $HOME/.stride/config/addrbook.json "https://raw.githubusercontent.com/StakeTake/guidecosmos/main/stride/STRIDE-TESTNET-2/addrbook.json"
SNAP_RPC="http://stride.stake-take.com:26657"
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 2000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)
echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"| ; \
s|^(seeds[[:space:]]+=[[:space:]]+).*$|\1\"\"|" $HOME/.stride/config/config.toml
sudo systemctl restart strided && journalctl -u strided -f -o cat
```
## Add addrbook
```
sudo systemctl stop strided
rm $HOME/.stride/config/addrbook.json
wget -O $HOME/.stride/config/addrbook.json "https://raw.githubusercontent.com/StakeTake/guidecosmos/main/stride/STRIDE-TESTNET-2/addrbook.json"
sudo systemctl restart strided && journalctl -u strided -f -o cat
```
## RPC
```
http://stride.stake-take.com:26657, https://stride-library.poolparty.stridenet.co:443
```
## Delete node
```
sudo systemctl stop strided && sudo systemctl disable strided
rm -rf $HOME/stride $HOME/.stride /etc/systemd/system/strided.service $HOME/go/bin/strided
```
