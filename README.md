##使用说明
###下载说明
*下载插件源代码

*下载fami-plugin-lists用于集成插件 git clone git@github.com:fami2u/fami-plugin-lists.git

*以上两个目录平级

*cd fami-plugin-lists

*查看当前安装的插件 cordova plugin list

*删除插件 cordova plugin remove com.fami2u.plugin.

*安装插件 cordova-plugin- 使用命令 cordova plugin add ../

*重新编译插件 cordova build android||ios

###调用说明
- ####IOS部分

在需要的地方调用 barcodeScanner.scan() 方法。


注：本插件中用到了block回调函数，在ARC开发下使用__weak 修饰，避免循环引用。请确保一下设置无误。否则会运行失败。

![price](/Users/fami_Lbb/Desktop/87A5E5B5-21E4-4409-822F-BAFBA3C7926E.png)

xcode -> Build Settings -> Apple LLVM 7.1-Language - Objective C -> Weak Refrernces in Manual Retain Release  设置为YES