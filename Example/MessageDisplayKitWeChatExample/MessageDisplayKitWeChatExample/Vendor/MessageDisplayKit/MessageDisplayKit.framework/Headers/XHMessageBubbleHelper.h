//
//  XHMessageBubbleHelper.h
//  MessageDisplayExample
//
//  Created by 曾 宪华 on 14-6-2.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XHMessageBubbleHelper : NSObject

+ (instancetype)sharedMessageBubbleHelper;

- (NSAttributedString *)bubbleAttributtedStringWithText:(NSString *)text;

@end
