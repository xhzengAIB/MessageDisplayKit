//
//  XHViewState.m
//  XHImageViewer
//
//  Created by 曾 宪华 on 14-2-17.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
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
