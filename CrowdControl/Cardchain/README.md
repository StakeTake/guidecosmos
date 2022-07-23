![](https://i.yapx.ru/RTuEU.jpg)


## One line script for full install
```
    curl -s https://raw.githubusercontent.com/StakeTake/guidecosmos/main/CrowdControl/Cardchain/crowd > crowd.sh && chmod +x crowd.sh && ./crowd.sh
```
To install, you just need to take the script and go through the installation order
## RPC
```
http://cc.stake-take.com:36657
```
## Start with state sync
```
sudo systemctl stop Cardchain
Cardchain unsafe-reset-all
wget -O $HOME/.Cardchain/config/addrbook.json "https://raw.githubusercontent.com/StakeTake/guidecosmos/main/CrowdControl/Cardchain/addrbook.json"
SEEDS=""
PEERS="407fd08d831eaec4be840bf762740a72c5c48ea6@159.69.11.174:36656,a506820ea90c5b0ddb9005ef720a121e9f6bbaeb@45.136.28.158:26658"; \
sed -i.bak -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.Cardchain/config/config.toml
SNAP_RPC="http://159.69.11.174:36657"
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 1000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)
echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"| ; \
s|^(seeds[[:space:]]+=[[:space:]]+).*$|\1\"\"|" $HOME/.Cardchain/config/config.toml
sudo systemctl restart Cardchain && journalctl -u Cardchain -f -o cat
```
## Delete node
```
sudo systemctl stop Cardchain && sudo systemctl disable Cardchain
rm -rf $HOME/Cardchain $HOME/.Cardchain /etc/systemd/system/Cardchain.service $HOME/go/bin/Cardchain
```
