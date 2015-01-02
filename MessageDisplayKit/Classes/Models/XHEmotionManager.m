//
//  XHEmotionManager.m
//  MessageDisplayExample
//
//  Created by HUAJIE-1 on 14-5-3.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHEmotionManager.h"

@implementation XHEmotionManager

- (void)dealloc {
    [self.emotions removeAllObjects];
    self.emotions = nil;
}

@end
