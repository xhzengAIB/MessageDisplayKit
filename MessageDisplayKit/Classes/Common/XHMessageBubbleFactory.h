//
//  XHMessageBubbleFactory.h
//  MessageDisplayExample
//
//  Created by qtone-1 on 14-4-25.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, XHBubbleMessageType) {
    XHBubbleMessageTypeReceiving = 0,
    XHBubbleMessageTypeSending
};

typedef NS_ENUM(NSUInteger, XHBubbleImageViewStyle) {
    XHBubbleImageViewStyleWeChat = 0
};

typedef NS_ENUM(NSInteger, XHBubbleMessageMediaType) {
    XHBubbleMessageText = 0,
    XHBubbleMessagePhoto = 1,
    XHBubbleMessageVideo = 2,
    XHBubbleMessagevoice = 3,
};

typedef NS_ENUM(NSInteger, XHBubbleMessageMenuSelecteType) {
    XHBubbleMessageTextCopy = 0,
    XHBubbleMessageTextTranspond = 1,
    XHBubbleMessageTextFavorites = 2,
    XHBubbleMessageTextMore = 3,
    
    XHBubbleMessagePhotoCopy = 4,
    XHBubbleMessagePhotoTranspond = 5,
    XHBubbleMessagePhotoFavorites = 6,
    XHBubbleMessagePhotoMore = 7,
    
    XHBubbleMessageVideoTranspond = 8,
    XHBubbleMessageVideoFavorites = 9,
    XHBubbleMessageVideoMore = 10,
    
    XHBubbleMessageVoicePlay = 11,
    XHBubbleMessageVoiceFavorites = 12,
    XHBubbleMessageVoiceTurnToText = 13,
    XHBubbleMessageVoiceMore = 14,
};

@interface XHMessageBubbleFactory : NSObject

+ (UIImage *)bubbleImageViewForType:(XHBubbleMessageType)type
                                  style:(XHBubbleImageViewStyle)style
                              meidaType:(XHBubbleMessageMediaType)mediaType;


@end
