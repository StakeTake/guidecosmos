![](https://i.yapx.ru/RTuEU.jpg)


## Explorers
PingPub - https://explorer.stake-take.com/chronic-token/staking
## One-line script for full install
```
curl -s https://raw.githubusercontent.com/StakeTake/guidecosmos/main/ChronicToken/morocco-1/chtd > chtd.sh && chmod +x chtd.sh && ./chtd.sh
```
To install, you just need to take the script and go through the installation order
### Please save your mnemonic and backup $HOME/.cht/config/priv_validator_key.json
#### For example mnemonic phrase:
![image](https://user-images.githubusercontent.com/93165931/184551172-16cb2f1a-3145-4e5b-8092-c966e2f3e5ef.png)

## Delete node
```
sudo systemctl stop chtd && sudo systemctl disable chtd
rm -rf $HOME/cht $HOME/.cht /etc/systemd/system/chtd.service $HOME/go/bin/chtd
```
