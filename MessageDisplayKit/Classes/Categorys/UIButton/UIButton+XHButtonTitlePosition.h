//
//  UIButton+XHButtonTitlePosition.h
//  MessageDisplayExample
//
//  Created by 曾 宪华 on 14-5-25.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, XHButtonTitlePostionType) {
    XHButtonTitlePostionTypeBottom = 0,
};

@interface UIButton (XHButtonTitlePosition)

- (void)setTitlePositionWithType:(XHButtonTitlePostionType)type;

@end
