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

@interface XHMessageBubbleFactory : NSObject

+ (UIImage *)bubbleImageViewForType:(XHBubbleMessageType)type
                                  style:(XHBubbleImageViewStyle)style
                              meidaType:(XHBubbleMessageMediaType)mediaType;


@end
