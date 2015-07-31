//
//  XHMessageModel.h
//  MessageDisplayExample
//
//  Created by HUAJIE-1 on 14-4-24.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "XHMessageBubbleFactory.h"

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
- (NSString *)voiceUrl;
- (NSString *)voiceDuration;

- (UIImage *)localPositionPhoto;
- (NSString *)geolocations;
- (CLLocation *)location;

- (NSString *)emotionPath;

- (UIImage *)avatar;
- (NSString *)avatarUrl;

- (XHBubbleMessageMediaType)messageMediaType;

- (XHBubbleMessageType)bubbleMessageType;

@optional

- (BOOL)shouldShowUserName;

- (NSString *)sender;

- (NSDate *)timestamp;

- (BOOL)isRead;
- (void)setIsRead:(BOOL)isRead;

@end

