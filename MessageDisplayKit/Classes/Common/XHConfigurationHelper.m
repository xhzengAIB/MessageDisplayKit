//
//  XHConfigurationHelper.m
//  MessageDisplayKit
//
//  Created by Jack_iMac on 15/6/30.
//  Copyright (c) 2015年 iOS软件开发工程师 曾宪华 热衷于简洁的UI QQ:543413507 http://www.pailixiu.com/blog   http://www.pailixiu.com/Jack/personal. All rights reserved.
//

#import "XHConfigurationHelper.h"

@interface XHConfigurationHelper ()

@property (nonatomic, strong) NSArray *popMenuTitles;

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

@end
