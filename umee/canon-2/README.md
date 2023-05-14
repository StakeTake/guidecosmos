![](https://i.yapx.ru/RTuEU.jpg)


## Explorers:
https://explorer.stake-take.com/umee-testnet/staking  
## OneLine script of full install
```
curl -s https://raw.githubusercontent.com/StakeTake/guidecosmos/main/umee/canon-2/umee > umee.sh && chmod +x umee.sh && ./umee.sh
```
To install, you just need to take the script and go through the installation order
### Please save your mnemonic and backup $HOME/.umee/config/priv_validator_key.json
#### For example mnemonic phrase:
![image](https://user-images.githubusercontent.com/93165931/184551172-16cb2f1a-3145-4e5b-8092-c966e2f3e5ef.png)

## Start with state sync
```
sudo systemctl stop umeed
umeed tendermint unsafe-reset-all --home $HOME/.umee
SEEDS=""
PEERS=""; \
sed -i.bak -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.umee/config/config.toml
SNAP_RPC="https://rpc.umee-testnet.stake-take.com:443"
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 2000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)
echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"| ; \
s|^(seeds[[:space:]]+=[[:space:]]+).*$|\1\"\"|" $HOME/.umee/config/config.toml
wget -O $HOME/.umee/config/addrbook.json "https://raw.githubusercontent.com/StakeTake/guidecosmos/main/umee/canon-2/addrbook.json"
sudo systemctl restart umeed && journalctl -u umeed -f -o cat
```
## Add addrbook
```
sudo systemctl stop umeed
rm $HOME/.umee/config/addrbook.json
wget -O $HOME/.umee/config/addrbook.json "https://raw.githubusercontent.com/StakeTake/guidecosmos/main/umee/canon-2/addrbook.json"
sudo systemctl restart umeed && journalctl -u umeed -f -o cat
```
## RPC
```
https://rpc.umee-testnet.stake-take.com
```
## API
```
https://api.umee-testnet.stake-take.com
```
## Delete node
```
sudo systemctl stop umeed && sudo systemctl disable umeed
rm -rf $HOME/umee $HOME/.umee /etc/systemd/system/umeed.service $(which umeed)
```
