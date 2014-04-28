//
//  XHMessageBubbleView.h
//  MessageDisplayExample
//
//  Created by qtone-1 on 14-4-24.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XHMessageDisplayTextView.h"
#import "XHBubblePhotoImageView.h"

#define kXHMessageBubbleDisplayMaxLine 200

@interface XHMessageBubbleView : UIView

@property (nonatomic, weak, readonly) XHMessageDisplayTextView *messageDisplayTextView;
@property (nonatomic, weak, readonly) UIImageView *bubbleImageView;

@property (nonatomic, weak, readonly) UIImageView *animationVoiceImageView;

@property (nonatomic, weak, readonly) XHBubblePhotoImageView *bubblePhotoImageView;


@property (nonatomic, strong) UIFont *font UI_APPEARANCE_SELECTOR;

@property (nonatomic, strong, readonly)  id <XHMessageModel> message;

- (instancetype)initWithFrame:(CGRect)frame
                      message:(id <XHMessageModel>)message;

- (CGRect)bubbleFrame;

- (void)configureCellWithMessage:(id <XHMessageModel>)message;

+ (CGFloat)calculateCellHeightWithMessage:(id <XHMessageModel>)message;

@end
