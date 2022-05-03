![](https://i.yapx.ru/RTuEU.jpg)


In this guide, we have made setting up a node as easy as possible

    curl -s https://raw.githubusercontent.com/Aleksandr7793/guidecosmos/main/uptick/uptick_7776-1/uptick > uptick.sh && chmod +x uptick.sh && ./uptick.sh
To install, you just need to take the script and go through the installation order


If you see a bad hash error - use these commands to rebuild the binary

```html
sudo systemctl stop uptickd
cd uptick
git checkout 0.1.0
make install
sudo systemctl restart uptickd
```
