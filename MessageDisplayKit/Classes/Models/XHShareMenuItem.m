//
//  XHShareMenuItem.m
//  MessageDisplayExample
//
//  Created by HUAJIE-1 on 14-5-1.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHShareMenuItem.h"

@implementation XHShareMenuItem

- (instancetype)initWithNormalIconImage:(UIImage *)normalIconImage
                                  title:(NSString *)title {
    return [self initWithNormalIconImage:normalIconImage title:title titleColor:nil titleFont:nil];
}

- (instancetype)initWithNormalIconImage:(UIImage *)normalIconImage
                                  title:(NSString *)title
                             titleColor:(UIColor *)titleColor
                              titleFont:(UIFont *)titleFont {
    self = [super init];
    if (self) {
        self.normalIconImage = normalIconImage;
        self.title = title;
        self.titleColor = titleColor;
        self.titleFont = titleFont;
    }
    return self;
}

- (void)dealloc {
    self.normalIconImage = nil;
    self.title = nil;
}

@end
