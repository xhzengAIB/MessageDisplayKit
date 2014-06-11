//
//  XHPopMenuItem.h
//  MessageDisplayExample
//
//  Created by dw_iOS on 14-6-7.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kXHMenuTableViewWidth 140
#define kXHMenuTableViewSapcing 7

#define kXHMenuItemViewHeight 40
#define kXHMenuItemViewImageSapcing 15
#define kXHSeparatorLineImageViewHeight 0.5


@interface XHPopMenuItem : NSObject

@property (nonatomic, strong) UIImage *image;

@property (nonatomic, copy) NSString *title;

- (instancetype)initWithImage:(UIImage *)image title:(NSString *)title;

@end
