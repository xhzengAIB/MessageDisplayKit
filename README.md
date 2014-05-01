MessageDisplayKit
=================
用于显示iPhone和iPad的消息页面，你可以发送文本、声音、图片、视频等消息。模仿微信App。                        
A messages UI for iPhone and iPad. You can send texts, voice messages, images, videos, and emotions, etc. It's similar to the Wechat app.                                 

![image](https://github.com/xhzengAIB/LearnEnglish/raw/master/Screenshots/MessageDisplayKitExample.gif)

代码都有注释，如果看完注释还是不懂的话，那你只能在githu开issue，[点击这里](https://github.com/xhzengAIB/MessageDisplayKit/issues?state=open)移步新建一个issue（至于怎么新建，打开issue页面，里面有一个new issue的按钮，点击之后你就会的了），写上你不明白的地方，我会在github给予帮助。                        

It's ok if you don't understand how the code works. Most code has comments, which I believe will help you a lot. Feel free to [open an issue] (https://github.com/xhzengAIB/MessageDisplayKit/issues?state=open) if you have any questions (Open issue page, there's a ``new issue" button). I will do my best to answer them.

## 组件要求                                        Requirements

* iOS 6.0+ 
* ARC

## Podfile

[CocosPods](http://cocosPods.org) is the recommended methods of installation MessageDisplayKit, just add the following line to `Podfile`:

```
pod 'MessageDisplayKit', '~> 0.1.1'
```

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
Automatically enable/disable send button (if text view is empty or not).                           
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

## License

中文: MessageDisplayKit 是在MIT协议下使用的，可以在LICENSE文件里面找到相关的使用协议信息.     

English: MessageDisplayKit is available under the MIT license, see the LICENSE file for more information.     


## 须知       Notes
如果您在您的项目中使用该开源组件,请给我们发[电子邮件](mailto:xhzengAIB@gmail.com?subject=From%20GitHub%20MessageDisplayKit)告诉我们您的应用程序的名称，谢谢！            
                           
If you use this open source components in your project, please [Email us](mailto:xhzengAIB@gmail.com?subject=From%20GitHub%20MessageDisplayKit) to notify us the name of your application(s). Thanks!

## Credits
Thanks to [jessesquires](https://github.com/jessesquires/MessagesTableViewController) who created JSMessagesViewController on which my work is based.
