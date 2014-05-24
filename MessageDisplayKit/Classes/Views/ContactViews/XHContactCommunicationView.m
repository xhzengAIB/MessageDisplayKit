//
//  XHContactCommunicationView.m
//  MessageDisplayExample
//
//  Created by 曾 宪华 on 14-5-23.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHContactCommunicationView.h"

@implementation XHContactCommunicationView

#pragma mark - Propertys

- (UIButton *)videoCommunicationButton {
    if (!_videoCommunicationButton) {
        _videoCommunicationButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), 44)];
        _videoCommunicationButton.backgroundColor = [UIColor colorWithRed:0.263 green:0.717 blue:0.031 alpha:1.000];
        [_videoCommunicationButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_videoCommunicationButton setTitle:@"视频聊天" forState:UIControlStateNormal];
        [self addSubview:_videoCommunicationButton];
    }
    return _videoCommunicationButton;
}

- (UIButton *)messageCommunicationButton {
    if (!_messageCommunicationButton) {
        _messageCommunicationButton = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.videoCommunicationButton.frame) + 20, CGRectGetWidth(self.bounds), CGRectGetHeight(self.videoCommunicationButton.bounds))];
        _messageCommunicationButton.backgroundColor = [UIColor whiteColor];
        [_messageCommunicationButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_messageCommunicationButton setTitle:@"发送消息" forState:UIControlStateNormal];
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
