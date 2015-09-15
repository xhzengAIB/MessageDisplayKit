//
//  XHConfigurationHelper.m
//  MessageDisplayKit
//
//  Created by Jack_iMac on 15/6/30.
//  Copyright (c) 2015年 iOS软件开发工程师 曾宪华 热衷于简洁的UI QQ:543413507 http://www.pailixiu.com/blog   http://www.pailixiu.com/Jack/personal. All rights reserved.
//

#import "XHConfigurationHelper.h"

// (Input Tool Bar Style Key)
NSString *kXHMessageInputViewVoiceNormalImageNameKey = @"com.HUAJIE.MDK.XHMessageInputViewVoiceNormalImageNameKey";
NSString *kXHMessageInputViewVoiceHLImageNameKey = @"com.HUAJIE.MDK.XHMessageInputViewVoiceHLImageNameKey";
NSString *kXHMessageInputViewVoiceHolderImageNameKey = @"com.HUAJIE.MDK.XHMessageInputViewVoiceHolderImageNameKey";
NSString *kXHMessageInputViewVoiceHolderHLImageNameKey = @"com.HUAJIE.MDK.XHMessageInputViewVoiceHolderHLImageNameKey";
NSString *kXHMessageInputViewExtensionNormalImageNameKey = @"com.HUAJIE.MDK.XHMessageInputViewExtensionNormalImageNameKey";
NSString *kXHMessageInputViewExtensionHLImageNameKey = @"com.HUAJIE.MDK.XHMessageInputViewExtensionHLImageNameKey";
NSString *kXHMessageInputViewKeyboardNormalImageNameKey = @"com.HUAJIE.MDK.XHMessageInputViewKeyboardNormalImageNameKey";
NSString *kXHMessageInputViewKeyboardHLImageNameKey = @"com.HUAJIE.MDK.XHMessageInputViewKeyboardHLImageNameKey";
NSString *kXHMessageInputViewEmotionNormalImageNameKey = @"com.HUAJIE.MDK.XHMessageInputViewEmotionNormalImageNameKey";
NSString *kXHMessageInputViewEmotionHLImageNameKey = @"com.HUAJIE.MDK.XHMessageInputViewEmotionHLImageNameKey";
NSString *kXHMessageInputViewBackgroundImageNameKey = @"com.HUAJIE.MDK.XHMessageInputViewBackgroundImageNameKey";
NSString *kXHMessageInputViewBackgroundColorKey = @"com.HUAJIE.MDK.XHMessageInputViewBackgroundColorKey";
NSString *kXHMessageInputViewBorderColorKey = @"com.HUAJIE.MDK.XHMessageInputViewBorderColorKey";
NSString *kXHMessageInputViewBorderWidthKey = @"com.HUAJIE.MDK.XHMessageInputViewBorderWidthKey";
NSString *kXHMessageInputViewCornerRadiusKey = @"com.HUAJIE.MDK.XHMessageInputViewCornerRadiusKey";
NSString *kXHMessageInputViewPlaceHolderTextColorKey = @"com.HUAJIE.MDK.XHMessageInputViewPlaceHolderTextColorKey";
NSString *kXHMessageInputViewPlaceHolderKey = @"com.HUAJIE.MDK.XHMessageInputViewPlaceHolderKey";
NSString *kXHMessageInputViewTextColorKey = @"com.HUAJIE.MDK.XHMessageInputViewTextColorKey";

// (Message Table Style Key)
NSString *kXHMessageTablePlaceholderImageNameKey = @"com.HUAJIE.MDK.XHMessageTablePlaceholderImageNameKey";
NSString *kXHMessageTableReceivingSolidImageNameKey = @"com.HUAJIE.MDK.XHMessageTableReceivingSolidImageNameKey";
NSString *kXHMessageTableSendingSolidImageNameKey = @"com.HUAJIE.MDK.XHMessageTableSendingSolidImageNameKey";
NSString *kXHMessageTableVoiceUnreadImageNameKey = @"com.HUAJIE.MDK.XHMessageTableVoiceUnreadImageNameKey";
NSString *kXHMessageTableAvatarPalceholderImageNameKey = @"com.HUAJIE.MDK.XHMessageTableAvatarPalceholderImageNameKey";
NSString *kXHMessageTableTimestampBackgroundColorKey = @"com.HUAJIE.MDK.XHMessageTableTimestampBackgroundColorKey";
NSString *kXHMessageTableTimestampTextColorKey = @"com.HUAJIE.MDK.XHMessageTableTimestampTextColorKey";
NSString *kXHMessageTableAvatarTypeKey = @"com.HUAJIE.MDK.XHMessageTableAvatarTypeKey";
NSString *kXHMessageTableCustomLoadAvatarNetworImageKey = @"com.HUAJIE.MDK.XHMessageTableCustomLoadAvatarNetworImageKey";

@interface XHConfigurationHelper ()

@property (nonatomic, strong, readwrite) NSArray *popMenuTitles;

@property (nonatomic, strong, readwrite) NSDictionary *messageInputViewStyle;

@property (nonatomic, strong, readwrite) NSDictionary *messageTableStyle;

@end

@implementation XHConfigurationHelper

+ (instancetype)appearance {
    static XHConfigurationHelper *configurationHelper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        configurationHelper = [[XHConfigurationHelper alloc] init];
    });
    return configurationHelper;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.popMenuTitles = @[NSLocalizedStringFromTable(@"copy", @"MessageDisplayKitString", @"复制文本消息"),
                               NSLocalizedStringFromTable(@"transpond", @"MessageDisplayKitString", @"转发"),
                               NSLocalizedStringFromTable(@"favorites", @"MessageDisplayKitString", @"收藏"),
                               NSLocalizedStringFromTable(@"more", @"MessageDisplayKitString", @"更多"),];
    }
    return self;
}

- (void)setupPopMenuTitles:(NSArray *)popMenuTitles {
    self.popMenuTitles = popMenuTitles;
}

- (void)setupMessageInputViewStyle:(NSDictionary *)messageInputViewStyle {
    self.messageInputViewStyle = messageInputViewStyle;
}

- (void)setupMessageTableStyle:(NSDictionary *)messageTableStyle {
    self.messageTableStyle = messageTableStyle;
}

@end
