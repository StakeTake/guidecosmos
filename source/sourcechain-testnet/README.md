![](https://i.yapx.ru/RTuEU.jpg)

## Explorers:
Ping Pub - https://explorer.testnet.sourceprotocol.io/source  
## One line script for full install
```
curl -s https://raw.githubusercontent.com/StakeTake/guidecosmos/main/source/sourcechain-testnet/source > source.sh && chmod +x source.sh && ./source.sh
```
To install, you just need to take the script and go through the installation order
## Start with state sync
```
sudo systemctl stop sourced
sourced unsafe-reset-all --home $HOME/.source
SEEDS=""; \
PEERS="9d16b552697cdce3c8b4f23de53708533d99bc59@165.232.144.133:26656,d565dd0cb92fa4b830662eb8babe1dcdc340c321@44.234.26.62:26656,2dbc3e6d52e5eb9357aec5cf493718f6078ffaad@144.76.224.246:36656"; \
sed -i.bak -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.source/config/config.toml
# wget -O $HOME/.source/config/addrbook.json "https://raw.githubusercontent.com/StakeTake/guidecosmos/main/source/sourcechain-testnet/addrbook.json"
SNAP_RPC="https://testnet.sourceprotocol.io:26657"
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 2000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)
echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"| ; \
s|^(seeds[[:space:]]+=[[:space:]]+).*$|\1\"\"|" $HOME/.source/config/config.toml
sudo systemctl restart sourced && journalctl -u sourced -f -o cat
```
## Delete node
```
sudo systemctl stop sourced && sudo systemctl disable sourced
rm -rf $HOME/source $HOME/.sourcee /etc/systemd/system/sourced.service $HOME/go/bin/sourced
```
## RPC
```
https://testnet.sourceprotocol.io:26657
```
