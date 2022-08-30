![](https://i.yapx.ru/RTuEU.jpg)


## Explorers
PingPub - 
## One line script for full install
```
curl -s https://raw.githubusercontent.com/StakeTake/guidecosmos/main/sei/atlantic-sub-1/sei > sei.sh && chmod +x sei.sh && ./sei.sh
```
To install, you just need to take the script and go through the installation order
### Please save your mnemonic and backup $HOME/.sei/config/priv_validator_key.json
#### For example mnemonic phrase:
![image](https://user-images.githubusercontent.com/93165931/184551172-16cb2f1a-3145-4e5b-8092-c966e2f3e5ef.png)
## Start with state sync
```
sudo systemctl stop seid
seid tendermint unsafe-reset-all --home $HOME/.sei
wget -O $HOME/.sei/config/addrbook.json "https://raw.githubusercontent.com/StakeTake/guidecosmos/main/sei/atlantic-sub-1/addrbook.json"
SEEDS=""
PEERS="38b4d78c7d6582fb170f6c19330a7e37e6964212@65.109.49.111:46656,dd8b73cad778d622c255e6dcebf42262985bae1d@65.21.151.93:36656,e14cb72edc5bf06a55efa7ad1f5b3a5b9a8b167d@65.108.140.222:12656,4b8d694de8ae2348f6aea37a835ee9cd9bbfaed1@144.76.224.246:20656"; \
sed -i.bak -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.sei/config/config.toml
SNAP_RPC="http://sei.stake-take.com:20657"
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 1000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"| ; \
s|^(seeds[[:space:]]+=[[:space:]]+).*$|\1\"\"|" $HOME/.sei/config/config.toml
sudo systemctl restart seid && journalctl -u seid -f -o cat
```
## Add addrbook
```
sudo systemctl stop seid
rm $HOME/.sei/config/addrbook.json
wget -O $HOME/.sei/config/addrbook.json "https://raw.githubusercontent.com/StakeTake/guidecosmos/main/sei/atlantic-sub-1/addrbook.json"
sudo systemctl restart seid && journalctl -u seid -f -o cat
```
## RPC
```
http://sei.stake-take.com:20657
```
## Delete node
```
sudo systemctl stop seid && sudo systemctl disable seid
rm -rf $HOME/sei-chain $HOME/.sei /etc/systemd/system/seid.service $(which seid)
```
