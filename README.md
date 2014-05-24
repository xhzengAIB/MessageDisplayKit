![image](https://github.com/xhzengAIB/LearnEnglish/raw/master/Screenshots/MessageDisplayKit.gif)

MessageDisplayKit
=================
用于显示iPhone和iPad的消息页面，你可以发送文本、声音、图片、视频、gif表情等消息。模仿微信App。                        
A messages UI for iPhone and iPad. You can send texts, voice messages, images, videos, and emotions, etc. It's similar to the Wechat app.                                 

代码都有注释，如果看完注释还是不懂的话，那你只能在githu开issue，[点击这里](https://github.com/xhzengAIB/MessageDisplayKit/issues?state=open)移步新建一个issue，写上你不明白的地方，我会在github给予帮助。                        

It's ok if you don't understand how the code works. Most code has comments, which I believe will help you a lot. Feel free to [open an issue] (https://github.com/xhzengAIB/MessageDisplayKit/issues?state=open) if you have any questions. I will do my best to answer them.

## 组件要求                                        Requirements

* iOS 6.0+ 
* ARC
* System Frameworks : 'Foundation', 'CoreGraphics', 'UIKit', 'MobileCoreServices', 'AVFoundation', 'CoreLocation', 'MediaPlayer', 'CoreMedia', 'CoreText', 'AudioTollbox'.

## Podfile

[CocosPods](http://cocosPods.org) is the recommended method to install MessageDisplayKit, just add the following line to `Podfile`

```
pod 'MessageDisplayKit'
```

and run `pod install`, then you're all done!

## TODO
* 核心网络层。                                 
Core Network Layer.                                    
* 核心缓存层。                                    
Core Cache Layer.                              
* 核心数据层。                              
Core Model Layer.
* 优化TableView性能                                 
Majorization tableView performance.  
* 强化gif播放机制                                 
Keep FPS due wih gif play.
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
* 21、支持漂流瓶

## License

中文: MessageDisplayKit 是在MIT协议下使用的，可以在LICENSE文件里面找到相关的使用协议信息。

English: MessageDisplayKit is available under the MIT license, see the LICENSE file for more information.     


## 须知       Notes
如果您在您的项目中使用该开源组件,请给我们发[电子邮件](mailto:xhzengAIB@gmail.com?subject=From%20GitHub%20MessageDisplayKit)告诉我们您的应用程序的名称，谢谢！主要是为了互推的效果，如果您的app火了，请给予少许的回报，如果您的App不火，或许能通过这个开源库了解到您的App！            
                           
If you use this open source components in your project, please [Email us](mailto:xhzengAIB@gmail.com?subject=From%20GitHub%20MessageDisplayKit) to notify us the name of your application(s). Thanks!

## What app use this open source
这里会列出所有使用该开源库的App列表。

## Thanks Developer
[我家App](https://itunes.apple.com/us/app/wo-jia-jia-ting-quan-si-mi/id538285014?mt=8)的主程Aevit提供了技术支持，他的[github](https://github.com/Aevit)地址，点击[我家App](https://itunes.apple.com/us/app/wo-jia-jia-ting-quan-si-mi/id538285014?mt=8)下载安装，如果看到里面有好的效果，可以协商开源。

谢谢[微信App](https://itunes.apple.com/cn/app/wei-xin/id414478124?mt=8)给予我鼓励，我参考了很多框架设计问题、也提供了许多素材，但是请网友不要直接使用素材，我不知道是否会引起侵权的问题，所以请自重，我这里只是模仿微信，而不是攻击。使用该开源库所导致的所有侵权关系与我无关，我只是提供学习机会。                                         

谢谢[kishikawakatsumi](https://github.com/kishikawakatsumi)提供[富文本](https://github.com/kishikawakatsumi/SECoreTextView)组件。      

Thanks you [kishikawakatsumi](https://github.com/kishikawakatsumi) provide [SECoreTextView](https://github.com/kishikawakatsumi/SECoreTextView).                              

## 警告
请不要拿该工程的所有资源文件用于商业使用，如果不遵守规则，而产生的法律责任，一律与我无关。代码按照上文描述的License 和 Notes来使用。                              
该工程里面任何一个效果组件都不能擅自使用，如需使用，请告之于我。

## Credits
Thanks to [jessesquires](https://github.com/jessesquires/MessagesTableViewController) who created JSMessagesViewController on which my chat list UI work is based.

