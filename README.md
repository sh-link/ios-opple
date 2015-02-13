#SHLink 0.1

包内为SHLink iOS App的alpha版本源码，作者钱凯(ntqkhh@163.com)。

###环境

*	开发环境：	[Xcode 6.1](https://developer.apple.com/xcode/downloads/)， OS X 10.10

*	编译目标：	armv7，arm64

*	支持设备：	iPad，iphone

*	支持操作系统：	iOS 7.0 或更高，若要支持iOS 6.1或以下版本，需要进一步对UI进行调整和兼容。

*	支持全尺寸iOS设备，支持横屏。

*	使用[CocoaPods](http://cocoapods.org)管理部分第三方框架，如果需要更改请在mac上安装pods环境，在终端使用命令`pod update`来更新依赖库，[Podfile](http://guides.cocoapods.org/using/the-podfile.html)：
	
		platform :ios, '8.1'
		pod 'ZXingObjC', '~> 3.0'
		pod 'IQKeyboardManager'
		
*	使用但不由CocoaPods管理的第三方框架：
	*	[MBProgressHUD](https://github.com/jdg/MBProgressHUD)
	*	[CMPopTipView](https://github.com/chrismiles/CMPopTipView)
	*	[PureLayout](https://github.com/smileyborg/PureLayout)
	*	[Reachability](https://github.com/tonymillion/Reachability)
	
	以上框架如果需要请自行到github上更新。

*	工程使用[git](http://www.git-scm.com/downloads)进行版本控制，但没有远程仓库，安装git环境后在终端使用`git log`查看历史版本。
	
*	打开工程点击`SHLink.xcworkspace`，注意**不是**`SHLink.xcodeproj`

*	真机调试需要[证书](https://developer.apple.com/programs/ios/)，可以使用Xcode iOS模拟器进行调试，使用模拟器调试无法正确获取当前连接的ssid，显示为`null`，属正常现象，每一次变更mac的网络环境最好重启一下模拟器。


###进度

App基于文档`局域网APP通信方案V1`和安卓版App开发，目前(2.13)主体框架、控件库、通信协议和大部分功能都已完成，尚未完成的进度有：

*	UI设计方案的实现（缺失图片）

*	用户输入合法性的正则判断

*	WiFi定时开关模块

*	登陆后检测网络状态提示设置上网配置

*	登陆后检测路由账户状态提示设置路由登陆账号

*	更为详尽的测试


以上内容大约需要一周的工作量，App完成后首次提交审核还需要2-4周时间。


	
	
	