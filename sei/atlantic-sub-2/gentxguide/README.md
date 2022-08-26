# Manual guide with create gentx atlantic-sub-2 chain

## Before publication of the genesis file
### Delete ur previous Sei node, if u use same server
```
cd $HOME
sudo systemctl stop seid && sudo systemctl disable seid
rm -rf $HOME/sei-chain $HOME/.sei $(which seid)
```
### Install node
#### Update APT
```
sudo apt update && sudo apt upgrade -y
sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential bsdmainutils git make ncdu gcc git jq chrony liblz4-tool -y
```
#### Install GO
```
rm -r /usr/local/go
rm -r /usr/lib/go-1.13
wget https://golang.org/dl/go1.18.3.linux-amd64.tar.gz; \
rm -rv /usr/local/go; \
tar -C /usr/local -xzf go1.18.3.linux-amd64.tar.gz && \
rm -v go1.18.3.linux-amd64.tar.gz && \
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bash_profile && \
source ~/.bash_profile && \
go version
```
#### Build binary
```
cd $HOME
git clone https://github.com/sei-protocol/sei-chain
cd $HOME/sei-chain
git checkout master && git pull
git checkout 1.1.2beta-internal
make install
mv $HOME/go/bin/seid /usr/bin/
```
#### Add variables (change "YOURNODENAME" and "YOURWALLETNAME" without "<>")
```
NODENAME=<YOURNODENAME>
WALLETNAME=<YOURWALLETNAME>
echo export NODENAME=${NODENAME} >> $HOME/.bash_profile
echo export WALLETNAME=${WALLETNAME} >> $HOME/.bash_profile
echo export CHAIN_ID=atlantic-sub-2 >> $HOME/.bash_profile
source ~/.bash_profile
```
#### make init
```
seid init $NODENAME --chain-id $CHAIN_ID
```
#### Add chain-id in config
```
seid config chain-id $CHAIN_ID
```
#### Restore your wallet
```
seid keys add $WALLETNAME --recover
```
### Create gentx
#### Add the account to your local genesis file with a given amount and key
```
seid add-genesis-account $WALLETNAME 10000000usei
```
#### Create gentx (security-contact, website, details, identity is optional flags)
```
 seid gentx $WALLETNAME 10000000usei \
 --chain-id=$CHAIN_ID \
 --moniker=$NODENAME \
 --commission-rate=0.05 \
 --commission-max-rate=0.2 \
 --commission-max-change-rate=0.05 \
 --pubkey $(seid tendermint show-validator) \
 --security-contact="" \
 --website="" \
 --details="" \
 --identity=""
```
#### Create Pull Request to the [testnet repository](https://github.com/sei-protocol/testnet/tree/main/atlantic-subchains/atlantic-sub-2/gentx) with the file your_validator_moniker.json.

## After publication of the genesis file:
