![](https://i.yapx.ru/RTuEU.jpg)


## Explorers
PingPub - http://explorers.cryptech.com.ua/atlantic-sub-2/staking
## One line script for full install
```
curl -s https://raw.githubusercontent.com/StakeTake/guidecosmos/main/sei/atlantic-sub-2/sei > sei.sh && chmod +x sei.sh && ./sei.sh
```
To install, you just need to take the script and go through the installation order
### Please save your mnemonic and backup $HOME/.sei/config/priv_validator_key.json
#### For example mnemonic phrase:
![image](https://user-images.githubusercontent.com/93165931/184551172-16cb2f1a-3145-4e5b-8092-c966e2f3e5ef.png)
## Start with state sync
```
sudo systemctl stop seid
seid tendermint unsafe-reset-all --home $HOME/.sei
SEEDS=""
PEERS="f48eedfb31854a822129b7f857b43969f2526bad@185.144.99.19:26656,2f1e8842dec0a60c79d8fedfe420697661c837c8@195.3.221.191:26656,f61d6ace9a30d371fa2d1b8e04ec11b66c967a63@167.235.6.228:26656,070650355f3e51d5f1f514759ec7602b993588f1@185.248.24.16:26656,e528e2d19e1b611894745fc1a5d3e7802e606f31@95.214.52.173:26656,dd23e8a8f019ff8030a1238f7cbf99601293050e@213.239.218.199:26656,34c734f3908654b53045f06c5fd262efaa6c0766@65.109.27.156:26656,72e5106ce49cb794f8af7196a14916bc06a36465@5.161.75.216:26656,7900d390baf8e6d5ce69225917e8fd64927e94f2@154.12.240.133:26656,8acf073665a756fca2df91b647a280ef0d05dc8a@85.114.134.203:26656,263803aef62e933f568ced5df5ca2e24d0f9d329@95.216.40.123:26656,5cb50c4b80dff5a92d232057d07f97ab82895cea@65.108.246.4:26656,0174c55cc5fb6c7ad0c39e709710adfb1ee6bae8@49.12.15.138:26656,26ff7747fd64c703bd241bdad3cf75bbda5ae72b@85.10.199.157:26656,390be417d37cb2ac0ee72a7c40f2ead6aa98e62b@65.108.60.151:26656,5d0cee85dcac7364fb8861201eec3a767873bdf3@172.31.16.93:26656,62ec353a7c234ef436518a7d07eed422064c01c9@172.31.16.93:26656,2743782c2bdc22e51250c5edc21048d1e3a7bf01@172.20.0.75:26656,2743782c2bdc22e51250c5edc21048d1e3a7bf01@172.20.0.75:26656,a5b5ee5888f4a8b66a29184611dd19e4c8ce1c28@5.9.71.9:26656,aaa1da62895d2a8daaf09b235ca82a55c8d9efd7@173.212.203.238:26656,ab082b683c6ecfb1148cb87e0153b036b1ea2283@65.108.199.62:26656,169685c8550d1663ac44a77d8bb03ba681a9582d@45.84.138.127:26656,b2a4e16ef6ec4e2e42ec7c22e530840c16351bfa@135.181.222.185:26656,89ba32810d917a9db78808df338b60abcb7ae3e2@45.94.209.32:26656,e84bbca3bd80c9effba4451dd797a0edb61cb5d2@135.181.143.26:26656,531980d9574d1c619aad8ba9f42703c2c817d9f8@38.242.255.82:26656"; \
sed -i.bak -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.sei/config/config.toml
SNAP_RPC="http://185.144.99.19:26657"
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 1000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"| ; \
s|^(seeds[[:space:]]+=[[:space:]]+).*$|\1\"\"|" $HOME/.sei/config/config.toml
sudo systemctl restart seid && journalctl -u seid -f -o cat
```
## RPC
```
http://185.144.99.19:26657
```
## Delete node
```
sudo systemctl stop seid && sudo systemctl disable seid
rm -rf $HOME/sei-chain $HOME/.sei /etc/systemd/system/seid.service $(which seid)
```
