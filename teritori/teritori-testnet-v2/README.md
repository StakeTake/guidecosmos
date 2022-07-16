![](https://i.yapx.ru/RTuEU.jpg)


In this guide, we have made setting up a node as easy as possible

    curl -s https://raw.githubusercontent.com/StakeTake/guidecosmos/main/teritori/teritori-testnet-v2/teritori > teritori.sh && chmod +x teritori.sh && ./teritori.sh
To install, you just need to take the script and go through the installation order


#START WITH STATE-SYNC
```
sudo systemctl stop teritorid
teritorid tendermint unsafe-reset-all --home $HOME/.teritorid
SEEDS=""
PEERS="c1fdbc3d0679bcaf4cfe3aeaf5247ba12b7daa6f@49.12.236.218:26656,0b42fd287d3bb0a20230e30d54b4b8facc412c53@176.9.149.15:26656,2f394edda96be07bf92b0b503d8be13d1b9cc39f@5.9.40.222:26656,8ce81af6b4acee9688b9b3895fc936370321c0a3@78.46.106.69:26656"; \
sed -i.bak -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.teritorid/config/config.toml
SNAP_RPC="49.12.236.218:26657"
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
