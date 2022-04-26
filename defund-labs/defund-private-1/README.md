![](https://i.yapx.ru/RTuEU.jpg)


In this guide, we have made setting up a node as easy as possible

    curl -s https://raw.githubusercontent.com/StakeTake/guidecosmos/main/defund-labs/defund-private-1/defund > defund.sh && chmod +x defund.sh && ./defund.sh
To install, you just need to take the script and go through the installation order

If you have any difficulties with synchronization - use the address book from our repository. You can replace it with the commands
```html
sudo systemctl stop defundd

wget -O $HOME/.defund/config/addrbook.json https://raw.githubusercontent.com/sowell-owen/defund-addrbook/main/addrbook.json

sudo systemctl restart defundd
```
