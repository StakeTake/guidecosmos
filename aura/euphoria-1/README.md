![](https://i.yapx.ru/RTuEU.jpg)


## One line script for full install
```
curl -s https://raw.githubusercontent.com/StakeTake/guidecosmos/main/aura/euphoria-1/aura > aura.sh && chmod +x aura.sh && ./aura.sh
```
To install, you just need to take the script and go through the installation order
## RPC
```
https://snapshot-1.euphoria.aura.network:443, https://snapshot-2.euphoria.aura.network:443
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
sudo systemctl restart aurad && journalctl -u aurad -f -o cat
```
## Delete node
```
sudo systemctl stop aurad && sudo systemctl disable aurad
rm -rf $HOME/aura $HOME/.aura /etc/systemd/system/aurad.service $HOME/go/bin/aurad
```
