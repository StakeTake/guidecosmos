![](https://i.yapx.ru/RTuEU.jpg)


## One line script for full install
```
curl -s https://raw.githubusercontent.com/StakeTake/guidecosmos/main/DWS/deweb-testnet-1/DWS > DWS.sh && chmod +x DWS.sh && ./DWS.sh
```
To install, you just need to take the script and go through the installation order
# RPC
```
http://deweb.stake-take.com:26657
```
## Start with state sync
```
sudo systemctl stop dewebd
dewebd unsafe-reset-all
SEEDS=""; \
PEERS=""; \
sed -i.bak -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.deweb/config/config.toml
wget -O $HOME/.deweb/config/addrbook.json "https://raw.githubusercontent.com/StakeTake/guidecosmos/main/DWS/deweb-testnet-1/addrbook.json"
SNAP_RPC=http://deweb.stake-take.com:26657
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 1000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)
echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"| ; \
s|^(seeds[[:space:]]+=[[:space:]]+).*$|\1\"\"|" $HOME/.deweb/config/config.toml
sudo systemctl restart dewebd && journalctl -u dewebd -f -o cat
```
## Delete node
```
sudo systemctl stop dewebd && sudo systemctl disable dewebd
rm -rf $HOME/deweb $HOME/.deweb /etc/systemd/system/dewebd.service $HOME/go/bin/dewebd
```
