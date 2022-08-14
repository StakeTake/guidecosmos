![](https://i.yapx.ru/RTuEU.jpg)


In this guide, we have made setting up a node as easy as possible

    curl -s https://raw.githubusercontent.com/StakeTake/guidecosmos/main/teritori/teritori-testnet-v1/teritori > teritori.sh && chmod +x teritori.sh && ./teritori.sh
To install, you just need to take the script and go through the installation order
### Please save your mnemonic and backup $HOME/.teritorid/config/priv_validator_key.json
#### For example mnemonic phrase:
![image](https://user-images.githubusercontent.com/93165931/184551172-16cb2f1a-3145-4e5b-8092-c966e2f3e5ef.png)

#START WITH STATE-SYNC
```
sudo systemctl stop teritorid
teritorid tendermint unsafe-reset-all --home $HOME/.teritorid
SEEDS=""
PEERS="2a9bfeadf8005e2f0db71c0c818ffd88a16c362b@49.12.236.218:26656,3a2fe8bb58a75a91394a456463ca08b6de170f87@167.235.78.2:26656,6bc9f80a5123d62c23aadb7b5d68b740a794b0c6@207.180.194.156:36656,3a2fe8bb58a75a91394a456463ca08b6de170f87@167.235.78.2:26656,0dde2ae55624d822eeea57d1b5e1223b6019a531@176.9.149.15:26656,4d2ea61e6195ee4e449c1e6132cabce98f7d94e1@5.9.40.222:26656,bceb776975aab62bcfd501969c0e1a2734ed7c2e@176.9.19.162:26656"; \
sed -i.bak -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.teritorid/config/config.toml
SNAP_RPC="49.12.236.18:26657"
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
