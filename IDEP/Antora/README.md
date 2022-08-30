![](https://i.yapx.ru/RTuEU.jpg)


## Explorers
PingPub - https://explorer.stake-take.com/idep/staking
## One line script for full install
```
curl -s https://raw.githubusercontent.com/StakeTake/guidecosmos/main/IDEP/Antora/idep > idep.sh && chmod +x idep.sh && ./idep.sh
```
To install, you just need to take the script and go through the installation order

### Please save your mnemonic and backup $HOME/.ion/config/priv_validator_key.json
#### For example mnemonic phrase:
![image](https://user-images.githubusercontent.com/93165931/184551172-16cb2f1a-3145-4e5b-8092-c966e2f3e5ef.png)

## Start with state sync
```
sudo systemctl stop iond
iond tendermint unsafe-reset-all --home ~/.ion
SEEDS="6e52997400aaa1b3d2155e45cf2559bf7a4c5e76@164.92.161.91:26656"
PEERS="f14e7dd78fd2462541f59eac08a8107fca89c2b3@75.119.159.159:26641,8ffc74dbcd5ab32bc89e058ec53060d5762f88b5@178.63.100.102:26656,2a5c7fb6475f4edf5ea36dd1d40aecc70f55fa45@65.108.106.19:11343"; \
sed -i.bak -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.ion/config/config.toml
SNAP_RPC="https://rpc.idep.nodestake.top:443"
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 1000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"| ; \
s|^(seeds[[:space:]]+=[[:space:]]+).*$|\1\"\"|" $HOME/.ion/config/config.toml
sudo systemctl restart iond && journalctl -u iond -f -o cat
```
## Delete node
```
sudo systemctl stop iond && sudo systemctl disable iond
rm -rf $HOME/Antora $HOME/.ion /etc/systemd/system/iond.service /usr/local/bin/iond
```
