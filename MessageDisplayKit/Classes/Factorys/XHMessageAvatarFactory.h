//
//  XHMessageAvatarFactory.h
//  MessageDisplayExample
//
//  Created by HUAJIE-1 on 14-4-25.
//  Copyright (c) 2014年 嗨，我是曾宪华(@xhzengAIB)，曾加入YY Inc.担任高级移动开发工程师，拍立秀App联合创始人，热衷于简洁、而富有理性的事物 QQ:543413507 主页:http://zengxianhua.com All rights reserved.
//

#import <Foundation/Foundation.h>

// 头像大小以及头像与其他控件的距离
static CGFloat const kXHAvatarImageSize = 40.0f;
static CGFloat const kXHAlbumAvatarSpacing = 15.0f;

typedef NS_ENUM(NSInteger, XHMessageAvatarType) {
    XHMessageAvatarTypeNormal = 0,
    XHMessageAvatarTypeSquare,
    XHMessageAvatarTypeCircle
};

@interface XHMessageAvatarFactory : NSObject

+ (UIImage *)avatarImageNamed:(UIImage *)originImage
            messageAvatarType:(XHMessageAvatarType)type;

@end
