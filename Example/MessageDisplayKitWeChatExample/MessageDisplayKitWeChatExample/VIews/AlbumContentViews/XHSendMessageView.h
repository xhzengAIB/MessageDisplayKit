//
//  XHSendMessageView.h
//  MessageDisplayKitWeChatExample
//
//  Created by Jack_iMac on 15/2/28.
//  Copyright (c) 2015年 嗨，我是曾宪华(@xhzengAIB)，曾加入YY Inc.担任高级移动开发工程师，拍立秀App联合创始人，热衷于简洁、而富有理性的事物 QQ:543413507 主页:http://zengxianhua.com All rights reserved.
//

#import <UIKit/UIKit.h>

@class XHSendMessageView;

@protocol XHSendMessageViewDelegate <NSObject>

@optional
- (void)didSendMessage:(NSString *)message albumInputView:(XHSendMessageView *)sendMessageView;

@end

@interface XHSendMessageView : UIView

@property (nonatomic, weak) id <XHSendMessageViewDelegate> sendMessageDelegate;

- (void)becomeFirstResponderForTextField;
- (void)resignFirstResponderForInputTextFields;

- (void)finishSendMessage;

@end
