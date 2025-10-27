# RevealLoader注入，支持指定App开启
如需MacOS Reveal(50)安装包请至公众号： 玩机分享汇

如需指定版本的RevealServer，开启Reveal App，选择Help->  show Reveal Framework in finder-> RevealServer->  RevealServer.xcframework -> RevealServer.xcframework -> ios-arm64 -> RevealServer.framework -> RevealServer

选择RevealServer 替换layout/Library/Application Support/ReveLoader/路径下的，然后执行命令make package FINALPACKAGE=1,STRIP=0 如果环境没有问题的话，正常会生成.deb格式文件，使用Sileo安装即可。

该插件目前**适配iOS15+，多巴胺越狱rootless**，其他系统及越狱方式请自行测试。

