![](https://i.yapx.ru/RTuEU.jpg)


## Explorers
PingPub - https://explorer.stake-take.com/teritori-testnet/staking

NodesGuru - https://teritori.explorers.guru
## One line script for full install
```
curl -s https://raw.githubusercontent.com/StakeTake/guidecosmos/main/teritori/teritori-testnet-v2/teritori > teritori.sh && chmod +x teritori.sh && ./teritori.sh
```
To install, you just need to take the script and go through the installation order
### Please save your mnemonic and backup $HOME/.teritorid/config/priv_validator_key.json
#### For example mnemonic phrase:
![image](https://user-images.githubusercontent.com/93165931/184551172-16cb2f1a-3145-4e5b-8092-c966e2f3e5ef.png)
## Snapshot height 708010 0.3gb
```
sudo systemctl stop teritorid
teritorid tendermint unsafe-reset-all --home $HOME/.teritorid --keep-addr-book
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="10"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.teritorid/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.teritorid/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.teritorid/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.teritorid/config/app.toml
cd
rm -rf ~/.teritorid/data; \
wget -O - http://snap.stake-take.com:8000/teritori.tar.gz | tar xf -
mv $HOME/root/.teritorid/data $HOME/.teritorid
rm -rf $HOME/root
sudo systemctl restart teritorid && journalctl -u teritorid -f -o cat
```
## Start with state sync
```
sudo systemctl stop teritorid
teritorid tendermint unsafe-reset-all --home $HOME/.teritorid
wget -O $HOME/.teritorid/config/addrbook.json https://raw.githubusercontent.com/StakeTake/guidecosmos/main/teritori/teritori-testnet-v2/addrbook.json
SEEDS=""
PEERS="c1fdbc3d0679bcaf4cfe3aeaf5247ba12b7daa6f@49.12.236.218:26656,0b42fd287d3bb0a20230e30d54b4b8facc412c53@176.9.149.15:26656,2f394edda96be07bf92b0b503d8be13d1b9cc39f@5.9.40.222:26656,8ce81af6b4acee9688b9b3895fc936370321c0a3@78.46.106.69:26656"; \
sed -i.bak -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.teritorid/config/config.toml
SNAP_RPC="http://teritori.stake-take.com:26657"
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 1000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)
echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"| ; \
s|^(seeds[[:space:]]+=[[:space:]]+).*$|\1\"\"|" $HOME/.teritorid/config/config.toml
sudo systemctl restart teritorid && journalctl -u teritorid -f -o cat
```
## Add addrbook
```
sudo systemctl stop teritorid
rm $HOME/.teritorid/config/addrbook.json
wget -O $HOME/.teritorid/config/addrbook.json https://raw.githubusercontent.com/StakeTake/guidecosmos/main/teritori/teritori-testnet-v2/addrbook.json
sudo systemctl restart teritorid && journalctl -u teritorid -f -o cat
```
## RPC
```
http://teritori.stake-take.com:26657
```
## Delete node
```
sudo systemctl stop teritorid && sudo systemctl disable teritorid
rm -rf $HOME/teritori-chain $HOME/.teritorid /etc/systemd/system/teritorid.service $HOME/go/bin/teritorid
```

