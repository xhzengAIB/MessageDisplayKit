//
//  XHMessageAvatorFactory.m
//  MessageDisplayExample
//
//  Created by qtone-1 on 14-4-25.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHMessageAvatorFactory.h"
#import "UIImage+XHRounded.h"

@implementation XHMessageAvatorFactory

+ (UIImage *)avatarImageNamed:(UIImage *)originImage
            messageAvatorType:(XHMessageAvatorType)messageAvatorType {
    CGFloat radius = 0.0;
    switch (messageAvatorType) {
        case XHMessageAvatorTypeNormal:
            return originImage;
            break;
        case XHMessageAvatorTypeCircle:
            radius = originImage.size.width / 2.0;
            break;
        case XHMessageAvatorTypeSquare:
            radius = 8;
            break;
        default:
            break;
    }
    UIImage *avator = [originImage createRoundedWithRadius:radius];
    return avator;
}

@end
