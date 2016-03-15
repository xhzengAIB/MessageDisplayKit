//
//  XHViewState.m
//  XHImageViewer
//
//  Created by 曾 宪华 on 14-2-17.
//  Copyright (c) 2014年 嗨，我是曾宪华(@xhzengAIB)，曾加入YY Inc.担任高级移动开发工程师，拍立秀App联合创始人，热衷于简洁、而富有理性的事物 QQ:543413507 主页:http://zengxianhua.com All rights reserved.
//

#import "XHViewState.h"

@implementation XHViewState

+ (XHViewState *)viewStateForView:(UIView *)view {
    static NSMutableDictionary *dict = nil;
    if(dict == nil) {
        dict = [NSMutableDictionary dictionary];
    }
    
    XHViewState *state = dict[@(view.hash)];
    if(state == nil) {
        state = [[self alloc] init];
        dict[@(view.hash)] = state;
    }
    return state;
}

- (void)setStateWithView:(UIView *)view {
    CGAffineTransform trans = view.transform;
    view.transform = CGAffineTransformIdentity;
    
    self.superview = view.superview;
    self.frame     = view.frame;
    self.transform = trans;
    self.userInteratctionEnabled = view.userInteractionEnabled;
    
    view.transform = trans;
}

@end
