![](https://i.yapx.ru/RTuEU.jpg)

## Explorers:
Ping Pub - https://explorer.stake-take.com/haqq/staking
## One line script for full install
```
curl -s https://raw.githubusercontent.com/StakeTake/guidecosmos/main/haqq/haqq_54211-1/haqq > haqq.sh && chmod +x haqq.sh && ./haqq.sh
```
To install, you just need to take the script and go through the installation order
### Please save your mnemonic and backup $HOME/.haqqd/config/priv_validator_key.json
#### For example mnemonic phrase:
![image](https://user-images.githubusercontent.com/93165931/184551172-16cb2f1a-3145-4e5b-8092-c966e2f3e5ef.png)
## Start with state sync
```
sudo systemctl stop haqqd
haqqd tendermint unsafe-reset-all --home $HOME/.haqqd
SEEDS=""
PEERS=""; \
sed -i.bak -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.haqqd/config/config.toml
wget -O $HOME/.haqqd/config/addrbook.json "https://raw.githubusercontent.com/StakeTake/guidecosmos/main/haqq/haqq_54211-2/addrbook.json"
SNAP_RPC="http://haqq.stake-take.com:20657"
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 2000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)
echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"| ; \
s|^(seeds[[:space:]]+=[[:space:]]+).*$|\1\"\"|" $HOME/.haqqd/config/config.toml
sudo systemctl restart haqqd && journalctl -u haqqd -f -o cat
```
## Add addrbook
```
sudo systemctl stop haqqd
rm $HOME/.haqqd/config/addrbook.json
wget -O $HOME/.haqqd/config/addrbook.json "https://raw.githubusercontent.com/StakeTake/guidecosmos/main/haqq/haqq_54211-2/addrbook.json"
sudo systemctl restart haqqd && journalctl -u haqqd -f -o cat
```
## RPC
```
http://haqq.stake-take.com:20657
```
## Delete node
```
sudo systemctl stop haqqd && sudo systemctl disable haqqd
rm -rf $HOME/haqq $HOME/.haqqd /etc/systemd/system/haqqd.service $(which haqqd)
```
