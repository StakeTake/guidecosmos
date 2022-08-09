![](https://i.yapx.ru/RTuEU.jpg)


## Explorers: 
NodesGuru - https://kyve.explorers.guru   
## One line script for full install
```
curl -s https://raw.githubusercontent.com/StakeTake/guidecosmos/main/KYVE/korellia/kyve > kyve.sh && chmod +x kyve.sh && ./kyve.sh
```
To install, you just need to take the script and go through the installation order
## Start with state sync
```
sudo systemctl stop kyved
chaind unsafe-reset-all --home $HOME/.stride
SEEDS=""; \
PEERS="a3fd6919ec3c5eb0fcd26dd9758ad8183bb7a93d@51.15.104.178:26656,52880e07804a612a3611025b4283e845084c2b26@38.242.241.164:26256,6215a7936b5410dd4b8ec1d25d80b80aaee275bc@45.10.43.108:26656,e56574f922ff41c68b80700266dfc9e01ecae383@18.156.198.41:26656,022399338c77a6be4bf26d6b0735030c6c95732f@194.163.189.114:56656,f85664da0bb5787b6d7e93c4d4cbb344374f1fce@178.20.43.103:26656,52be70508d5bceb14dd8745471f437182201e59b@135.181.6.243:26632,6fac99ff534a905f3339b400547d2c731ad3d6f7@45.10.42.125:26656,eb2172370e3e1f77fadef9018e1c503e12839b7e@62.113.119.150:26656,522bf8fe88ee84316a06c9f94a195fa0096ff2ad@77.83.92.238:26656,8813c8167b8f5a91e10bee676e9738c7d928ad7a@139.59.100.3:26656,e1a13fab199f489b41c0a0f705bf06cf46dc4d3f@165.227.202.155:26656"; \
sed -i.bak -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.kyve/config/config.toml
wget -O $HOME/.kyve/config/addrbook.json "https://raw.githubusercontent.com/StakeTake/guidecosmos/main/KYVE/korellia/addrbook.json"
SNAP_RPC="http://kyve.stake-take.com:16657"
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
sudo systemctl stop strided
rm $HOME/.kyve/config/addrbook.json
wget -O $HOME/.kyve/config/addrbook.json "https://raw.githubusercontent.com/StakeTake/guidecosmos/main/KYVE/korellia/addrbook.json"
sudo systemctl restart kyved && journalctl -u kyved -f -o cat
```
## Delete node
```
sudo systemctl stop kyved && sudo systemctl disable kyved
rm -rf $HOME/stride $HOME/.stride /etc/systemd/system/strided.service $HOME/go/bin/strided
```
## RPC
```
http://kyve.stake-take.com:16657
```

