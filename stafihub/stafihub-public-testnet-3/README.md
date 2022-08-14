![](https://i.yapx.ru/RTuEU.jpg)


## One line script for full install
```
curl -s https://raw.githubusercontent.com/StakeTake/guidecosmos/main/stafihub/stafihub-public-testnet-3/stafihub > stafihub.sh && chmod +x stafihub.sh && ./stafihub.sh
```
To install, you just need to take the script and go through the installation order
### Please save your mnemonic and backup $HOME/.stafihub/config/priv_validator_key.json
#### For example mnemonic phrase:
![image](https://user-images.githubusercontent.com/93165931/184551172-16cb2f1a-3145-4e5b-8092-c966e2f3e5ef.png)


## RPC
```
http://stafi.stake-take.com:36657
```

## Start via state-sync
```
sudo systemctl stop stafihubd
stafihubd tendermint unsafe-reset-all --home $HOME/.stafihub
wget -O $HOME/.stafihub/config/addrbook.json "https://raw.githubusercontent.com/StakeTake/guidecosmos/main/stafihub/stafihub-public-testnet-3/addrbook.json"

SNAP_RPC="http://stafi.stake-take.com:36657"
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 1000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"| ; \
s|^(seeds[[:space:]]+=[[:space:]]+).*$|\1\"\"|" $HOME/.stafihub/config/config.toml
sudo systemctl restart stafihubd && journalctl -u stafihubd -f -o cat
```
## Delete node
```
sudo systemctl stop stafihubd && sudo systemctl disable stafihubd
rm -rf $HOME/stafihub $HOME/.stafihub /etc/systemd/system/stafihubd.service $HOME/go/bin/stafihubd
```
