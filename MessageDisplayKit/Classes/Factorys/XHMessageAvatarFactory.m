//
//  XHMessageAvatarFactory.m
//  MessageDisplayExample
//
//  Created by HUAJIE-1 on 14-4-25.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHMessageAvatarFactory.h"
#import "UIImage+XHRounded.h"

@implementation XHMessageAvatarFactory

+ (UIImage *)avatarImageNamed:(UIImage *)originImage
            messageAvatarType:(XHMessageAvatarType)messageAvatarType {
    CGFloat radius = 0.0;
    switch (messageAvatarType) {
        case XHMessageAvatarTypeNormal:
            return originImage;
            break;
        case XHMessageAvatarTypeCircle:
            radius = originImage.size.width / 2.0;
            break;
        case XHMessageAvatarTypeSquare:
            radius = 8;
            break;
        default:
            break;
    }
    UIImage *avatar = [originImage createRoundedWithRadius:radius];
    return avatar;
}

@end
