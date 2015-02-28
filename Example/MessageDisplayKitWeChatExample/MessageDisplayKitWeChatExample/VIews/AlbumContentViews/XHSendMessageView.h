//
//  XHSendMessageView.h
//  MessageDisplayKitWeChatExample
//
//  Created by Jack_iMac on 15/2/28.
//  Copyright (c) 2015年 iOS软件开发工程师 曾宪华 热衷于简洁的UI QQ:543413507 http://www.pailixiu.com/blog   http://www.pailixiu.com/Jack/personal. All rights reserved.
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
