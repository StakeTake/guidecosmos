![](https://i.yapx.ru/RTuEU.jpg)

## Explorers:
Ping Pub - https://poolparty.stride.zone  
NodesGuru - https://stride.explorers.guru   
Cosmostation - https://testnet.mintscan.io/stride-testnet
## One line script for full install
```
curl -s https://raw.githubusercontent.com/StakeTake/guidecosmos/main/stride/STRIDE-TESTNET-2/stride > stride.sh && chmod +x stride.sh && ./stride.sh
```
To install, you just need to take the script and go through the installation order
## Guide for migrate STRIDE-1 --> STRIDE-TESTNET-2
```
sudo systemctl stop strided
strided tendermint unsafe-reset-all --home $HOME/.stride
rm -rf $HOME/stride $HOME/go/bin/strided $HOME/.stride/config/genesis.json
cd $HOME
git clone https://github.com/Stride-Labs/stride.git
cd stride
git checkout 644c7574ee79128970a81cf8b9f23351dcdeec62
mkdir -p $HOME/go/bin
go build -mod=readonly -trimpath -o $HOME/go/bin ./...
wget -O $HOME/.stride/config/addrbook.json "https://raw.githubusercontent.com/StakeTake/guidecosmos/main/stride/STRIDE-TESTNET-2/addrbook.json"
wget -O $HOME/.stride/config/genesis.json "https://raw.githubusercontent.com/Stride-Labs/testnet/main/poolparty/genesis.json"
sudo systemctl restart strided
```
## Start with state sync
```
sudo systemctl stop strided
strided tendermint unsafe-reset-all --home $HOME/.stride
SEEDS="baee9ccc2496c2e3bebd54d369c3b788f9473be9@seedv1.poolparty.stridenet.co:26656"; \
PEERS="b61ea4c2c549e24c1a4d2d539b4d569d2ff7dd7b@stride-node1.poolparty.stridenet.co:26656,edfece4d3e7e5d4ad8658d6184b589965466ca0b@stride-node2.poolparty.stridenet.co:26656,0b501b0ff22b91a627363b21332a4a89c826cfa9@stride-node3.poolparty.stridenet.co:26656"; \
sed -i.bak -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.stride/config/config.toml
wget -O $HOME/.stride/config/addrbook.json "https://raw.githubusercontent.com/StakeTake/guidecosmos/main/stride/STRIDE-TESTNET-1/addrbook.json"
SNAP_RPC=http://stride-node3.poolparty.stridenet.co:26657
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 2000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)
echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"| ; \
s|^(seeds[[:space:]]+=[[:space:]]+).*$|\1\"\"|" $HOME/.stride/config/config.toml
sudo systemctl restart strided && journalctl -u strided -f -o cat
```
## Delete node
```
sudo systemctl stop strided && sudo systemctl disable strided
rm -rf $HOME/stride $HOME/.stride /etc/systemd/system/strided.service $HOME/go/bin/strided
```
## RPC
```
http://stride-node2.poolparty.stridenet.co:26657, http://stride-node3.poolparty.stridenet.co:26657
```
