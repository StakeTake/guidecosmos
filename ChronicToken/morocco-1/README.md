![](https://i.yapx.ru/RTuEU.jpg)


## One-line script for full install
```
curl -s https://raw.githubusercontent.com/StakeTake/guidecosmos/main/ChronicToken/morocco-1/chtd > chtd.sh && chmod +x chtd.sh && ./chtd.sh
```
To install, you just need to take the script and go through the installation order
## Delete node
```
sudo systemctl stop chtd && sudo systemctl disable chtd
rm -rf $HOME/cht $HOME/.cht /etc/systemd/system/chtd.service $HOME/go/bin/chtd
```
