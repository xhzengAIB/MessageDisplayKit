//
//  XHEmotionManager.h
//  MessageDisplayExample
//
//  Created by HUAJIE-1 on 14-5-3.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XHEmotion.h"

@interface XHEmotionManager : NSObject

@property (nonatomic, copy) NSString *emotionName;
/**
 *  某一类表情的数据源
 */
@property (nonatomic, strong) NSMutableArray *emotions;

@end
