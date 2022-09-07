![](https://i.yapx.ru/RTuEU.jpg)


## Explorers:
PingPub - https://explorer.stake-take.com/stride-1/staking

MintScan - https://www.mintscan.io/stride

NodesGuru - https://stride.explorers.guru/validators
## One line script for full install
```
curl -s https://raw.githubusercontent.com/StakeTake/guidecosmos/main/stride/STRIDE-1/stride > stride.sh && chmod +x stride.sh && ./stride.sh
```
To install, you just need to take the script and go through the installation order
### Please save your mnemonic and backup $HOME/.stride/config/priv_validator_key.json
#### For example mnemonic phrase:
![image](https://user-images.githubusercontent.com/93165931/184551172-16cb2f1a-3145-4e5b-8092-c966e2f3e5ef.png)
## Start with state sync
```
sudo systemctl stop strided
strided tendermint unsafe-reset-all --home $HOME/.stride
SEEDS=""; \
PEERS=""; \
sed -i.bak -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.stride/config/config.toml
wget -O $HOME/.stride/config/addrbook.json "https://raw.githubusercontent.com/StakeTake/guidecosmos/main/stride/STRIDE-1/addrbook.json"
SNAP_RPC=https://stride-rpc.polkachu.com:443
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
## RPC
```
https://stride-rpc.polkachu.com:443
```
## Delete node
```
sudo systemctl stop strided && sudo systemctl disable strided
rm -rf $HOME/stride $HOME/.stride /etc/systemd/system/strided.service $(which strided)
```
