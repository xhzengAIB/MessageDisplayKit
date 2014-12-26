//
//  XHSoundManager.m
//  XHPathCover
//
//  Created by 曾 宪华 on 14-2-7.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHSoundManager.h"
#import <AudioToolbox/AudioToolbox.h>

@interface XHSoundManager () {
    SystemSoundID refreshSound;
}

@end

@implementation XHSoundManager

+ (instancetype)sharedInstance {
    static XHSoundManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[XHSoundManager alloc] init];
    });
    return instance;
}

- (id)init {
    self = [super init];
    if (self) {
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"pullrefresh" withExtension:@"aif"];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)(url) , &refreshSound);
    }
    return self;
}

- (void)playRefreshSound {
    AudioServicesPlaySystemSound(refreshSound);
}

@end
