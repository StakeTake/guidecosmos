![](https://i.yapx.ru/RTuEU.jpg)


## Explorers
PingPub - https://explorer.erialos.me/aura/staking
## One line script for full install
```
curl -s https://raw.githubusercontent.com/StakeTake/guidecosmos/main/aura/euphoria-1/aura > aura.sh && chmod +x aura.sh && ./aura.sh
```
To install, you just need to take the script and go through the installation order
### Please save your mnemonic and backup $HOME/.aura/config/priv_validator_key.json
#### For example mnemonic phrase:
![image](https://user-images.githubusercontent.com/93165931/184551172-16cb2f1a-3145-4e5b-8092-c966e2f3e5ef.png)
## Snapshot 435038 height 0.2gb
```
sudo systemctl stop aurad
aurad unsafe-reset-all --home $HOME/.aura
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="10"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.aura/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.aura/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.aura/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.aura/config/app.toml
wget -O $HOEM/.aura/config/addrbook.jsnon "https://raw.githubusercontent.com/StakeTake/guidecosmos/main/aura/euphoria-1/addrbook.json"
cd
rm -rf ~/.aura/data; \
wget -O - http://snap.stake-take.com:8000/aura.tar.gz | tar xf -
mv $HOME/root/.aura/data $HOME/.aura
rm -rf $HOME/root
sudo systemctl restart aurad && journalctl -u aurad -f -o cat
```
## Start with state sync
```
sudo systemctl stop aurad
aurad unsafe-reset-all
SEEDS="705e3c2b2b554586976ed88bb27f68e4c4176a33@13.250.223.114:26656,b9243524f659f2ff56691a4b2919c3060b2bb824@13.214.5.1:26656"
sed -i -e "/seeds =/ s/= .*/= \"$SEEDS\"/"  $HOME/.aura/config/config.toml
SNAP_RPC="https://snapshot-2.euphoria.aura.network:443"
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 1000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"| ; \
s|^(seeds[[:space:]]+=[[:space:]]+).*$|\1\"\"|" $HOME/.aura/config/config.toml
wget -O $HOEM/.aura/config/addrbook.jsnon "https://raw.githubusercontent.com/StakeTake/guidecosmos/main/aura/euphoria-1/addrbook.json"
sudo systemctl restart aurad && journalctl -u aurad -f -o cat
```
## Add addrbook
```
sudo systemctl stop aurad
rm $HOEM/.aura/config/addrbook.jsnon
wget -O $HOEM/.aura/config/addrbook.jsnon "https://raw.githubusercontent.com/StakeTake/guidecosmos/main/aura/euphoria-1/addrbook.json"
sudo systemctl restart aurad && journalctl -u aurad -f -o cat
```
## RPC
```
https://snapshot-1.euphoria.aura.network:443, https://snapshot-2.euphoria.aura.network:443
```
## Delete node
```
sudo systemctl stop aurad && sudo systemctl disable aurad
rm -rf $HOME/aura $HOME/.aura /etc/systemd/system/aurad.service $HOME/go/bin/aurad
```
