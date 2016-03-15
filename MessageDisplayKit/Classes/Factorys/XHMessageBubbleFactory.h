//
//  XHMessageBubbleFactory.h
//  MessageDisplayExample
//
//  Created by HUAJIE-1 on 14-4-25.
//  Copyright (c) 2014年 嗨，我是曾宪华(@xhzengAIB)，曾加入YY Inc.担任高级移动开发工程师，拍立秀App联合创始人，热衷于简洁、而富有理性的事物 QQ:543413507 主页:http://zengxianhua.com All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, XHBubbleMessageType) {
    XHBubbleMessageTypeSending = 0, // 发送
    XHBubbleMessageTypeReceiving // 接收
};

typedef NS_ENUM(NSUInteger, XHBubbleImageViewStyle) {
    XHBubbleImageViewStyleWeChat = 0
};

typedef NS_ENUM(NSInteger, XHBubbleMessageMediaType) {
    XHBubbleMessageMediaTypeText = 0,
    XHBubbleMessageMediaTypePhoto = 1,
    XHBubbleMessageMediaTypeVideo = 2,
    XHBubbleMessageMediaTypeVoice = 3,
    XHBubbleMessageMediaTypeEmotion = 4,
    XHBubbleMessageMediaTypeLocalPosition = 5,
};

typedef NS_ENUM(NSInteger, XHBubbleMessageMenuSelecteType) {
    XHBubbleMessageMenuSelecteTypeTextCopy = 0,
    XHBubbleMessageMenuSelecteTypeTextTranspond = 1,
    XHBubbleMessageMenuSelecteTypeTextFavorites = 2,
    XHBubbleMessageMenuSelecteTypeTextMore = 3,
    
    XHBubbleMessageMenuSelecteTypePhotoCopy = 4,
    XHBubbleMessageMenuSelecteTypePhotoTranspond = 5,
    XHBubbleMessageMenuSelecteTypePhotoFavorites = 6,
    XHBubbleMessageMenuSelecteTypePhotoMore = 7,
    
    XHBubbleMessageMenuSelecteTypeVideoTranspond = 8,
    XHBubbleMessageMenuSelecteTypeVideoFavorites = 9,
    XHBubbleMessageMenuSelecteTypeVideoMore = 10,
    
    XHBubbleMessageMenuSelecteTypeVoicePlay = 11,
    XHBubbleMessageMenuSelecteTypeVoiceFavorites = 12,
    XHBubbleMessageMenuSelecteTypeVoiceTurnToText = 13,
    XHBubbleMessageMenuSelecteTypeVoiceMore = 14,
};

@interface XHMessageBubbleFactory : NSObject

+ (UIImage *)bubbleImageViewForType:(XHBubbleMessageType)type
                                  style:(XHBubbleImageViewStyle)style
                              meidaType:(XHBubbleMessageMediaType)mediaType;


@end
