//
//  XHMessageAvatarFactory.m
//  MessageDisplayExample
//
//  Created by HUAJIE-1 on 14-4-25.
//  Copyright (c) 2014年 嗨，我是曾宪华(@xhzengAIB)，曾加入YY Inc.担任高级移动开发工程师，拍立秀App联合创始人，热衷于简洁、而富有理性的事物 QQ:543413507 主页:http://zengxianhua.com All rights reserved.
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
