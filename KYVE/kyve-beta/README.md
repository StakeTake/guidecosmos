![](https://i.yapx.ru/RTuEU.jpg)


## Explorers:
PingPub - https://explorer.stake-take.com/kyve-beta
## One line script for full install
```
curl -s https://raw.githubusercontent.com/StakeTake/guidecosmos/main/KYVE/kyve-beta/kyve > kyve.sh && chmod +x kyve.sh && ./kyve.sh
```
To install, you just need to take the script and go through the installation order
### Please save your mnemonic and backup $HOME/.kyve/config/priv_validator_key.json
#### For example mnemonic phrase:
![image](https://user-images.githubusercontent.com/93165931/184551172-16cb2f1a-3145-4e5b-8092-c966e2f3e5ef.png)
## Start with state sync
```
sudo systemctl stop kyved
chaind tendermint unsafe-reset-all --home $HOME/.kyve
SEEDS=""; \
PEERS=""; \
sed -i.bak -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.kyve/config/config.toml
wget -O $HOME/.kyve/config/addrbook.json "https://raw.githubusercontent.com/StakeTake/guidecosmos/main/KYVE/kyve-beta/addrbook.json"
SNAP_RPC="http://kyve-beta.stake-take.com:36657"
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 2000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)
echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"| ; \
s|^(seeds[[:space:]]+=[[:space:]]+).*$|\1\"\"|" $HOME/.kyve/config/config.toml
sudo systemctl restart kyved && journalctl -u kyved -f -o cat
```
## Add addrbook
```
sudo systemctl stop kyved
rm $HOME/.kyve/config/addrbook.json
wget -O $HOME/.kyve/config/addrbook.json "https://raw.githubusercontent.com/StakeTake/guidecosmos/main/KYVE/kyve-beta/addrbook.json"
sudo systemctl restart kyved && journalctl -u kyved -f -o cat
```
## RPC
```
http://kyve-beta.stake-take.com:26657
```
## Delete node
```
sudo systemctl stop kyved && sudo systemctl disable kyved
rm -rf /etc/systemd/system/kyved.service $HOME/.kyve /usr/bin/chaind $HOME/go/bin/chaind
```
