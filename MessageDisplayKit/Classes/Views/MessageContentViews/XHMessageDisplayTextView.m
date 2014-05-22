//
//  XHMessageDisplayTextView.m
//  MessageDisplayExample
//
//  Created by qtone-1 on 14-4-28.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHMessageDisplayTextView.h"

@implementation XHMessageDisplayTextView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    return NO;
}

- (void)dealloc {
    
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    return NO;
}

@end
