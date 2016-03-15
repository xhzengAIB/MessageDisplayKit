//
//  XHContactCommunicationView.m
//  MessageDisplayExample
//
//  Created by 曾 宪华 on 14-5-23.
//  Copyright (c) 2014年 嗨，我是曾宪华(@xhzengAIB)，曾加入YY Inc.担任高级移动开发工程师，拍立秀App联合创始人，热衷于简洁、而富有理性的事物 QQ:543413507 主页:http://zengxianhua.com All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "XHContactCommunicationView.h"

#import "XHContact.h"

@implementation XHContactCommunicationView

#pragma mark - Propertys

- (UIButton *)videoCommunicationButton {
    if (!_videoCommunicationButton) {
        _videoCommunicationButton = [[UIButton alloc] initWithFrame:CGRectMake(kXHAlbumAvatarSpacing, 0, CGRectGetWidth(self.bounds) - kXHAlbumAvatarSpacing * 2, kXHContactButtonHeight)];
        _videoCommunicationButton.layer.cornerRadius = 4;
        _videoCommunicationButton.backgroundColor = [UIColor colorWithRed:0.263 green:0.717 blue:0.031 alpha:1.000];
        [_videoCommunicationButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_videoCommunicationButton setTitle:@"发消息" forState:UIControlStateNormal];
        [self addSubview:_videoCommunicationButton];
    }
    return _videoCommunicationButton;
}

- (UIButton *)messageCommunicationButton {
    if (!_messageCommunicationButton) {
        _messageCommunicationButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.videoCommunicationButton.frame), CGRectGetMaxY(self.videoCommunicationButton.frame) + kXHContactButtonSpacing, CGRectGetWidth(self.videoCommunicationButton.bounds), CGRectGetHeight(self.videoCommunicationButton.bounds))];
        _messageCommunicationButton.layer.cornerRadius = 4;
        _messageCommunicationButton.backgroundColor = [UIColor whiteColor];
        [_messageCommunicationButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_messageCommunicationButton setTitle:@"视频聊天" forState:UIControlStateNormal];
        [self addSubview:_messageCommunicationButton];
    }
    return _messageCommunicationButton;
}

#pragma mark - Life Cycle

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
