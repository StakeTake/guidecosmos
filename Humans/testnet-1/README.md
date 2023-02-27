<a id="anchor"></a>
# Humans testnet phase 1 node tutorial 



[<img align="right" alt="Personal Website" width="22px" src="https://raw.githubusercontent.com/iconic/open-iconic/master/svg/globe.svg" />][humans-website]
[<img align="right" alt="Humans Discord" width="22px" src="https://cdn.jsdelivr.net/npm/simple-icons@v3/icons/discord.svg" />][humans-discord]
[<img align="right" alt="Humans Medium Blog" width="22px" src="https://cdn.jsdelivr.net/npm/simple-icons@3.13.0/icons/medium.svg"/>][humans-medium]

[humans-medium]: https://medium.com/humansdotai
[humans-website]: https://humans.ai/
[humans-discord]: https://discord.com/invite/humansdotai

|Sections|Description|
|-----------------------:|------------------------------------------:|
| [Install other necessary environments](#go) | Clone repository. Compilation project |
| [Run Node](#run) |  Initialize node. Create configuration files. Check logs & sync status. |
| [Create Validator](#validator) |  Create valdator & wallet, check your balance. |
| <a href="https://explorer.stake-take.com/humans-testnet" target="_explorer">Explorer</a> |  Check whether your validator is created successfully |


 <p align="center"><a href="https://docs.nibiru.fi/"><img align="right"width="100px"alt="humans" src="https://stake-take.com/img/humans.png"></p</a>

| Minimum hardware requirements                                                                                |
|------------------------------------------------------------------------------------------------------|
- Memory: 8 GB RAM
- CPU: Quad-Core
- Disk: 250 GB SSD Storage
- Bandwidth: 1 Gbps for Download / 100 Mbps for Upload                                                                                          

--- 
### -Install the basic environment
#### The system used in this tutorial is Ubuntu20.04, please adjust some commands of other systems by yourself. It is recommended to use a foreign VPS.
<a id="go"></a>
#### Install golang
```
sudo rm -rf /usr/local/go;
curl https://dl.google.com/go/go1.19.2.linux-amd64.tar.gz | sudo tar -C/usr/local -zxvf - ;
cat <<'EOF' >>$HOME/.profile
export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export GO111MODULE=on
export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin
EOF
source $HOME/.profile
```
#### After the installation is complete, run the following command to check the version

```
go version
```
<a id="necessary"></a>
[Up to sections ↑](#anchor)
### -Install other necessary environments

#### Update apt
```
sudo apt update && sudo apt full-upgrade -y
sudo apt list --upgradable
sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential bsdmainutils git make ncdu gcc git jq chrony liblz4-tool -y
```

```
cd \
git clone https://github.com/humansdotai/humans \
cd humans \
git checkout v1.0.0
```

```
go build -o humansd cmd/humansd/main.go
```

```
mv humansd /usr/local/go/bin
```

<a id="run"></a>
### Run node

#### Initialize node

```
moniker=YOUR_MONIKER_NAME

humansd config chain-id testnet-1

humansd init $moniker --chain-id=testnet-1
```

#### Download the Genesis file and addrbook

```
curl -s https://rpc-testnet.humans.zone/genesis | jq -r .result.genesis > genesis.json
```

```
mv genesis.json $HOME/.humans/config
```

```
wget -O $HOME/.humans/config/addrbook.json "https://raw.githubusercontent.com/StakeTake/guidecosmos/main/Humans/testnet-1/addrbook.json"
```

#### Set peer and seed

```
PEERS="1df6735ac39c8f07ae5db31923a0d38ec6d1372b@45.136.40.6:26656,9726b7ba17ee87006055a9b7a45293bfd7b7f0fc@45.136.40.16:26656,6e84cde074d4af8a9df59d125db3bf8d6722a787@45.136.40.18:26656,eda3e2255f3c88f97673d61d6f37b243de34e9d9@45.136.40.13:26656,4de8c8acccecc8e0bed4a218c2ef235ab68b5cf2@45.136.40.12:26656"
seeds=""
sed -i 's|^persistent_peers *=.*|persistent_peers = "'$PEERS'"|' $HOME/.humans/config/config.toml
sed -i 's/minimum-gas-prices =.*/minimum-gas-prices = "0.025uheart"/g' $HOME/.humans/config/app.toml
```

```
CONFIG_TOML="$HOME/.humans/config/config.toml"
sed -i 's/timeout_propose =.*/timeout_propose = "100ms"/g' $CONFIG_TOML
sed -i 's/timeout_propose_delta =.*/timeout_propose_delta = "500ms"/g' $CONFIG_TOML
sed -i 's/timeout_prevote =.*/timeout_prevote = "100ms"/g' $CONFIG_TOML
sed -i 's/timeout_prevote_delta =.*/timeout_prevote_delta = "500ms"/g' $CONFIG_TOML
sed -i 's/timeout_precommit =.*/timeout_precommit = "100ms"/g' $CONFIG_TOML
sed -i 's/timeout_precommit_delta =.*/timeout_precommit_delta = "500ms"/g' $CONFIG_TOML
sed -i 's/timeout_commit =.*/timeout_commit = "1s"/g' $CONFIG_TOML
sed -i 's/skip_timeout_commit =.*/skip_timeout_commit = false/g' $CONFIG_TOML
```

[Up to sections ↑](#anchor)

#### Pruning settings
```
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="50"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.humans/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.humans/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.humans/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.humans/config/app.toml
```

```
indexer="null"
sed -i -e "s/^indexer *=.*/indexer = \"$indexer\"/" $HOME/.humans/config/config.toml
```

[Up to sections ↑](#anchor)
#### Start node 
```
sudo tee /etc/systemd/system/humansd.service > /dev/null <<EOF
[Unit]
Description=humans node
After=network.target
[Service]
User=root
Type=simple
ExecStart=$(which humansd) start --home $HOME/.humans
Restart=on-failure
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target
EOF
```
```
sudo systemctl daemon-reload && \
sudo systemctl enable humansd && \
sudo systemctl start humansd
```
#### Check
```
systemctl status humansd
```
___

#### Show log
```
sudo journalctl -u humansd -f
```
#### Check sync status
```
humansd status 2>&1 | jq .SyncInfo
```
The display `"catching_up":` shows `false` that it has been synchronized. Synchronization takes a while, maybe half an hour to an hour. If the synchronization has not started, it is usually because there are not enough peers. You can consider adding a Peer or using someone else's addrbook.

[Up to sections ↑](#anchor)

<a id="validator"></a>
### Create a validator
#### Create wallet
```
humansd keys add WALLET_NAME
```
----
## `Note please save the mnemonic and priv_validator_key.json file! If you don't save it, you won't be able to restore it later.`
----

[Up to sections ↑](#anchor)


#### Check balance
```
humansd query bank balances WALLET_ADDRESS
```
#### Query the test currency balance.
#### Create a validator
`After enough test coins are obtained and the node is synchronized, a validator can be created. Only validators whose pledge amount is in the top 100 are active validators.`
```
daemon=humansd
denom=uheart
moniker=MONIKER_NAME
chainid=testnet-1
$daemon tx staking create-validator \
    --amount=1000000$denom \
    --pubkey=$($daemon tendermint show-validator) \
    --moniker=$moniker \
    --chain-id=$chainid \
    --commission-rate=0.05 \
    --commission-max-rate=0.1 \
    --commission-max-change-rate=0.1 \
    --min-self-delegation=1000000 \
    --fees 5000uheart \
    --from=WALLET_NAME\
    --yes
```

#### After that, you can go to the block [explorer](https://explorer.stake-take.com/humans-testnet) to check whether your validator is created successfully.
And [other guides](https://github.com/StakeTake/guidecosmos)
----

  <h4 align="center"> More information </h4>
  
<table width="400px" align="center">
    <tbody>
        <tr valign="top">
          <td>
            <a href="https://humans.ai/" target="site">Official website</a> </td>
          <td><a href="https://twitter.com/humansdotai" target="twitt">Official twitter</a> </td> 
          <td><a href="https://discord.com/invite/humansdotai" target="discord">Discord</a></td> 
          <td><a href="https://github.com/humansdotai" target="git">Github</a> </td>
          <td><a href="https://github.com/humansdotai/docs-humans/blob/master/run-nodes/testnet/joining-testnet.md" target="doc">Documentation</a></td>   </tr>
    </tbody>
</table> 


### [Up to sections ↑](#anchor)
