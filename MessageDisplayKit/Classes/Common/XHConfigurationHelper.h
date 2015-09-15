//
//  XHConfigurationHelper.h
//  MessageDisplayKit
//
//  Created by Jack_iMac on 15/6/30.
//  Copyright (c) 2015年 iOS软件开发工程师 曾宪华 热衷于简洁的UI QQ:543413507 http://www.pailixiu.com/blog   http://www.pailixiu.com/Jack/personal. All rights reserved.
//

#import <Foundation/Foundation.h>

// (Input Tool Bar Style Key)
extern NSString *kXHMessageInputViewVoiceNormalImageNameKey;
extern NSString *kXHMessageInputViewVoiceHLImageNameKey;
extern NSString *kXHMessageInputViewVoiceHolderImageNameKey;
extern NSString *kXHMessageInputViewVoiceHolderHLImageNameKey;
extern NSString *kXHMessageInputViewExtensionNormalImageNameKey;
extern NSString *kXHMessageInputViewExtensionHLImageNameKey;
extern NSString *kXHMessageInputViewKeyboardNormalImageNameKey;
extern NSString *kXHMessageInputViewKeyboardHLImageNameKey;
extern NSString *kXHMessageInputViewEmotionNormalImageNameKey;
extern NSString *kXHMessageInputViewEmotionHLImageNameKey;
extern NSString *kXHMessageInputViewBackgroundImageNameKey;
extern NSString *kXHMessageInputViewBackgroundColorKey;
extern NSString *kXHMessageInputViewBorderColorKey;
extern NSString *kXHMessageInputViewBorderWidthKey;
extern NSString *kXHMessageInputViewCornerRadiusKey;
extern NSString *kXHMessageInputViewPlaceHolderTextColorKey;
extern NSString *kXHMessageInputViewPlaceHolderKey;
extern NSString *kXHMessageInputViewTextColorKey;


// (Message Table Style Key)
extern NSString *kXHMessageTablePlaceholderImageNameKey;
extern NSString *kXHMessageTableReceivingSolidImageNameKey;
extern NSString *kXHMessageTableSendingSolidImageNameKey;
extern NSString *kXHMessageTableVoiceUnreadImageNameKey;
extern NSString *kXHMessageTableAvatarPalceholderImageNameKey;
extern NSString *kXHMessageTableTimestampBackgroundColorKey;
extern NSString *kXHMessageTableTimestampTextColorKey;
extern NSString *kXHMessageTableAvatarTypeKey; // XHMessageAvatarType for NSNumber， if kXHMessageTableCustomLoadAvatarNetworImageKey is YES, kXHMessageTableAvatarTypeKey is invalid
extern NSString *kXHMessageTableCustomLoadAvatarNetworImageKey; // for NSNumber(BOOL)

// 优先控制MDK的UI控件样式，比如输入框的按钮图
@interface XHConfigurationHelper : NSObject

@property (nonatomic, strong, readonly) NSArray *popMenuTitles;

@property (nonatomic, strong, readonly) NSDictionary *messageInputViewStyle;

@property (nonatomic, strong, readonly) NSDictionary *messageTableStyle;

+ (instancetype)appearance;

- (void)setupPopMenuTitles:(NSArray *)popMenuTitles;

// The key from (Input Tool Bar Style Key)
- (void)setupMessageInputViewStyle:(NSDictionary *)messageInputViewStyle;

// The key from (Message Table Style Key)
- (void)setupMessageTableStyle:(NSDictionary *)messageTableStyle;

@end
