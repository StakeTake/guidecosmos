![](https://i.yapx.ru/RTuEU.jpg)

## Explorers:
Ping Pub - https://testnet.ping.pub/crossfi
## One line script for full install
```
curl -s https://raw.githubusercontent.com/StakeTake/guidecosmos/main/crossfi/crossfi-evm-testnet-1/crossfi > crossfi.sh && chmod +x crossfi.sh && ./crossfi.sh
```
To install, you just need to take the script and go through the installation order
### Please save your mnemonic and backup $HOME/.mineplex-chain/config/priv_validator_key.json
#### For example mnemonic phrase:
![image](https://user-images.githubusercontent.com/93165931/184551172-16cb2f1a-3145-4e5b-8092-c966e2f3e5ef.png)
## Snapshot (updating every 4h)
```
sudo systemctl stop crossfid
crossfid tendermint unsafe-reset-all --home ~/.mineplex-chain
wget -O $HOME/.mineplex-chain/config/addrbook.json "https://raw.githubusercontent.com/StakeTake/guidecosmos/main/crossfi/crossfi-evm-testnet-1/addrbook.json"
rm -rf ~/.mineplex-chain/data/*
wget -P ~/.mineplex-chain/data http://snapshot.crossfi.stake-take.com:8000/crossfi.tar.gz
tar -zxvf ~/.mineplex-chain/data/crossfi.tar.gz -C ~/.mineplex-chain/data
sudo systemctl restart crossfid && journalctl -u crossfid -f -o cat
```
## Start with state sync
```
sudo systemctl stop crossfid
crossfid tendermint unsafe-reset-all --home ~/.mineplex-chain
wget -O $HOME/.mineplex-chain/config/addrbook.json "https://raw.githubusercontent.com/StakeTake/guidecosmos/main/crossfi/crossfi-evm-testnet-1/addrbook.json"
SNAP_RPC="https://rpc.crossfi.stake-take.com:443"
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 2000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)
echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"| ; \
s|^(seeds[[:space:]]+=[[:space:]]+).*$|\1\"\"|" $HOME/.mineplex-chain/config/config.toml
sudo systemctl restart crossfid && journalctl -u crossfid -f -o cat
```
## Delete node
```
systemctl stop crossfid
rm -rf $HOME/.mineplex-chain $(which crossfid) /etc/systemd/system/crossfid.service
```
## Add addrbook
```
sudo systemctl stop crossfid
rm $HOME/.mineplex-chain/config/addrbook.json
wget -O $HOME/.mineplex-chain/config/addrbook.json "https://raw.githubusercontent.com/StakeTake/guidecosmos/main/crossfi/crossfi-evm-testnet-1/addrbook.json"
sudo systemctl restart crossfid && journalctl -u crossfid -f -o cat
```
## RPC
```
https://rpc.crossfi.stake-take.com:443
```
## API
```
https://api.crossfi.stake-take.com:443
```
