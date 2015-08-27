![](https://github.com/xhzengAIB/LearnEnglish/raw/master/Screenshots/MessageDisplayKit.png)
MessageDisplayKit
=================
一个类似微信App的IM应用，拥有发送文字、图片、语音、视频、地理位置消息，管理本地通信录、分享朋友圈、漂流交友、摇一摇和更多有趣的功能。                                
An IM APP like WeChat which has sending text, pictures, audio, video, location messaging, managing local address book, share moments with friends, drift bottle, shake for new friends and some other interesting features.                                 
![image](https://github.com/xhzengAIB/LearnEnglish/raw/master/Screenshots/MessageDisplayKit.gif)

## 宝贵意见
如果有任何问题，请到github开issue，[点击这里](https://github.com/xhzengAIB/MessageDisplayKit/issues?state=open)移步新建一个issue，写上你不明白的地方，我会在github给予帮助。                        

很多朋友反应，只看到静态库，看不到源码，一个工作区域内，有多个使用例子，也包含了源码，源码请[戳这里](https://github.com/xhzengAIB/MessageDisplayKit/tree/master/MessageDisplayKit), 让大家都可以快速查看到。

Most of code has comments with which I believe you can understand them. If you can't understand the code please feel free to [open an issue] (https://github.com/xhzengAIB/MessageDisplayKit/issues?state=open) I will do my best to answer them.

## 非常有趣，在LeanClound的开发者支持下，将开始全面的改进，将没有实现业务的功能进行对接LC的后台，敬请期待哦！

## 组件要求                                        Requirements

* iPhone4/5/6/6+/iPad，Portrait
* Xcode6 or later
* iOS 6.0+ 
* ARC
* System Frameworks : 'Foundation', 'CoreGraphics', 'UIKit', 'MobileCoreServices', 'AVFoundation', 'CoreLocation', 'MediaPlayer', 'CoreMedia', 'CoreText', 'AudioToolbox'.

## Podfile

[CocoaPods](http://cocoapods.org/) is the recommended method to install MessageDisplayKit, just add the following line to `Podfile`

```
pod 'MessageDisplayKit'
```

and run `pod install`, then you're all done!

## TODO
* 尽量去除绘制代码，由于现在引起性能下降的原因之一。                            
Delete drawRect code, because of lead to lower FPS. 
* 语音转换处理，适应多平台可用语音、视频等数据。                             
Convert audio format.
* 搭建服务器。                                
Build server 
* 模仿微信全部功能。

## 特性 Features 

* 1、高度可定制。                                     
Highly customizable.                           
* 2、任意消息的大小。                                   
Arbitrary message sizes.                           
* 3、复制&粘贴消息。                       
Able to copy & paste messages.                           
* 4、数据检查器(确认电话号码、链接、日期等)。           
Data detectors (recognizes phone numbers, links, dates, etc.).                           
* 5、时间戳。                                           
Timestamps.                           
* 6、头像。                                             
Avatars.                           
* 7、向下滑动隐藏键盘。                                 
Swipe down to hide keyboard.                           
* 8、动态调整输入文本视图类型。                         
Dynamically resize input text view as you type.                           
* 9、自动启用/禁用发送按钮(如果文本视图是空的或不是)。                             
Automatically enable/disable send button according to the content of text view.                           
* 10、发送/接收声音效果。                           
Send/Receive sound effects.                           
* 11、发送语音。                           
Send voice messages.                           
* 12、发送图片。                           
Send photos.                           
* 13、发送视频。                           
Send videos.                           
* 14、发送地理位置。                           
Send geolocations.                           
* 15、发送第三方gif表情。                           
Send third party gif message.                           
* 16、通用于iPhone和iPad。                               
Support both iPhone and iPad.                            
* 17、支持StoryBorad。                              
Support the StoryBorad to user.                              
* 18、支持下拉加载更多旧消息，处理了保持可见cell不滚动的效果。
Support pull down load more old message, keep visible cells static when inserting old message at top.
* 19、支持通信录
* 20、支持朋友圈
* 21、支持扫一扫
* 22、支持摇一摇
* 23、支持附近的人
* 24、支持漂流瓶
* 25、支持多选联系人
* 26、支持新闻模板嵌套
* 27、支持弹出Menu菜单
* 28、支持游戏室展示
* 29、支持表情商店预览
* 30、核心网络层。                                 
Core Network Layer.                                                          
* 31、核心缓存层。                                    
Core Cache Layer.                                                    
* 32、核心数据层。                              
Core Model Layer.                      
* 33、优化TableView性能                                 
Majorization tableView performance.                        
* 34、强化gif播放机制                                 
Keep FPS due wih gif play.                      

## How to use
Easy to drop into your project.                                
* 1、#import "XHMessageTableViewController.h"                                
                                
* 2、Your must be subClass XHMessageTableViewController.                                
                                
* 3、implementation XHMessageTableViewController delegate due with message send.                                
                                
* 4、implementation XHMessageTableViewController DataSource due with message source.                                
                                
* 5、If you went to emotion message / plug function / audio play, must be implementation other delegate or dataSource.                                                                   
* Detail look this [demo](https://github.com/xhzengAIB/MessageDisplayKit/blob/master/Example/MessageDisplayExample/MessageDisplayExample/XHDemoWeChatMessageTableViewController.m).                           


## License

中文: MessageDisplayKit 是在MIT协议下使用的，可以在LICENSE文件里面找到相关的使用协议信息。

English: MessageDisplayKit is available under the MIT license, see the LICENSE file for more information.     

## 须知       Notes
如果您在您的项目中使用该开源组件，请给我们发[电子邮件](mailto:xhzengAIB@gmail.com?subject=From%20GitHub%20MessageDisplayKit)告诉我们您的应用程序的名称，谢谢！主要是为了互推的效果，如果您的app火了，请给予少许的回报，如果您的App不火，或许能通过这个开源库了解到您的App！         
主要目的只有一个，互推，使用该开源库的开发者，我都会向其保证，永远免费，不涉及任何商业纠纷的事情，请放心使用。
                           
If you use this open source components in your project, please [Email us](mailto:xhzengAIB@gmail.com?subject=From%20GitHub%20MessageDisplayKit) to notify us the name of your application(s). Thanks!

## What app use this open source
这里会列出所有使用该开源库的App列表。                     
[leanchat-ios](https://github.com/leancloud/leanchat-ios)，LeanCloud 提供一站式后端云服务，从数据存储、实时聊天、消息推送到移动统计，涵盖应用开发的多方面后端需求。                       
[家信-导购员](https://itunes.apple.com/cn/app/jia-xin-dao-gou-yuan/id918014453?mt=8)家信，专属家居导购员的商务沟通APP。家信app，将家居消费者与离他最近的导购员及时对接。消费者微信在线随时随地与导购员接触沟通；导购员家信在线时时处处为消费者提供各种资讯、商品、咨询、导购服务，辅助消费者决策，促进消费购买，提升服务体验。

## 使用到的第三方组件
* [PathCover](https://github.com/JackTeam/PathCover)用于朋友圈的下拉刷新。
* [XHImageViewer](https://github.com/JackTeam/XHImageViewer)图片查看器，用于整个项目。
* [XHRefreshControl](https://github.com/xhzengAIB/XHRefreshControl)是一款高扩展性、低耦合度的下拉刷新、上提加载更多的组件。用于整个项目的所有下拉刷新和上提加载更多的UI和业务逻辑。    
* 
* 谢谢[molon](https://github.com/molon)提供多选组件[MLMultiSelectViewController](https://github.com/molon/MLMultiSelectViewController)，现在已经集成进去了。可用于群聊、添加多个朋友、等等。
* Thanks you [lakesoft](https://github.com/lakesoft) provide [LKBadgeView](https://github.com/lakesoft/LKBadgeView).
* Thanks you [kishikawakatsumi](https://github.com/kishikawakatsumi) provide [SECoreTextView](https://github.com/kishikawakatsumi/SECoreTextView).     

## Thanks Developer
[我家App](https://itunes.apple.com/us/app/wo-jia-jia-ting-quan-si-mi/id538285014?mt=8)的主程Aevit提供了技术支持，他的[github](https://github.com/Aevit)地址，点击[我家App](https://itunes.apple.com/us/app/wo-jia-jia-ting-quan-si-mi/id538285014?mt=8)下载安装，如果看到里面有好的效果，可以协商开源。                       


谢谢[微信App](https://itunes.apple.com/cn/app/wei-xin/id414478124?mt=8)给予我鼓励，我参考了很多框架设计问题、也提供了许多素材，但是请网友不要直接使用素材，我不知道是否会引起侵权的问题，所以请自重，我这里只是模仿微信，而不是攻击。使用该开源库所导致的所有侵权关系与我无关，我只是提供学习机会。                                         

## 警告
请不要拿该工程的微信图片资源文件用于商业使用，如果不遵守规则，而产生的法律责任，一律与我无关。代码按照上文描述的License和Notes来使用。                              

## Credits
Thanks to [jessesquires](https://github.com/jessesquires) who created [JSMessagesViewController](https://github.com/jessesquires/MessagesTableViewController) on which my chat list UI work is based.                             

