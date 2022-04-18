![](https://i.yapx.ru/RTuEU.jpg)

___In this guide, we have written how to set up an autodelegator for your validator node of AssetMantle___

```html
curl -s https://raw.githubusercontent.com/StakeTake/guidecosmos/main/AssetMantle/mantle-1/autodelegator/autodelegator > autodelegator.sh && chmod +x autodelegator.sh && ./autodelegator.sh
```

We need to do is set the variables correctly

1. The name of the wallet that you wrote when installing the node
2. The password is set according to your password from the created wallet
3. The validator address and the delegator address will be set automatically, the only thing you need to do is enter the wallet password when setting the variable

**After you have set the variables, go to the launch of the redelegator**

The script will automatically open the screen window, where all you have to do is run the redelegator with the command
```html
cd $HOME/autodelegate && ./start.sh
```
and exit the window by pressing

__ctrl + a + d__

in order to go back to the window

__screen-r__
