//
//  XHMessageModel.h
//  MessageDisplayExample
//
//  Created by qtone-1 on 14-4-24.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XHMessage;

@protocol XHMessageModel <NSObject>

@required
- (NSString *)text;

- (UIImage *)photo;
- (NSString *)thumbnailUrl;
- (NSString *)originPhotoUrl;

- (UIImage *)videoConverPhoto;
- (NSString *)videoPath;
- (NSString *)videoUrl;

- (NSString *)voicePath;
- (UIImage *)localPositionPhoto;

- (NSString *)facePath;
- (NSString *)voiceUrl;

- (UIImage *)avator;
- (NSString *)avatorUrl;

- (XHBubbleMessageMediaType)messageMediaType;

- (XHBubbleMessageType)bubbleMessageType;

@optional

- (NSString *)sender;

- (NSDate *)timestamp;

@end

