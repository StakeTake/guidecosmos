![](https://i.yapx.ru/RTuEU.jpg)


In this guide, we have made setting up a node as easy as possible

    curl -s https://raw.githubusercontent.com/Stake-Take/guidecosmos/main/uptick/uptick_7776-1/uptick > uptick.sh && chmod +x uptick.sh && ./uptick.sh
To install, you just need to take the script and go through the installation order
### Please save your mnemonic and backup $HOME/.uptickd/config/priv_validator_key.json
#### For example mnemonic phrase:
![image](https://user-images.githubusercontent.com/93165931/184551172-16cb2f1a-3145-4e5b-8092-c966e2f3e5ef.png)

If you see a bad hash error - use these commands to rebuild the binary

```html
sudo systemctl stop uptickd
cd uptick
git checkout 0.1.0
make install
sudo systemctl restart uptickd
```
