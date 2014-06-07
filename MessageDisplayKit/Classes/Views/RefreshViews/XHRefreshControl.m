//
//  XHRefreshControl.m
//  MessageDisplayExample
//
//  Created by 曾 宪华 on 14-6-6.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHRefreshControl.h"

#import "XHRefreshView.h"
#import "XHLoadMoreView.h"

#define kXHDefaultRefreshTotalPixels 64

@interface XHRefreshControl ()

@property (nonatomic, strong) XHRefreshView *refreshView;

@property (nonatomic, strong) XHLoadMoreView *loadMoreView;

@property (nonatomic, assign) BOOL isPullDownRefreshed;

@property (nonatomic, assign) BOOL isLoadMoreRefreshed;

@property (nonatomic, assign) CGFloat refreshTotalPixels;

@end

@implementation XHRefreshControl

#pragma mark - Public Method

- (void)startPullDownRefreshing {
    
}

- (void)endPullDownRefreshing {
    
}

- (void)endLoadMoreRefresing {
    
}


#pragma mark - Getter Method

- (BOOL)isLoading {
    return [self.delegate isLoading];
}

- (BOOL)isPullDownRefreshed {
    if ([self.delegate respondsToSelector:@selector(isPullDownRefreshed)]) {
        return [self.delegate isPullDownRefreshed];
    }
    return NO;
}

- (BOOL)isLoadMoreRefreshed {
    if ([self.delegate respondsToSelector:@selector(isLoadMoreRefreshed)]) {
        return [self.delegate isLoadMoreRefreshed];
    }
    return NO;
}

- (CGFloat)refreshTotalPixels {
    if ([self.delegate respondsToSelector:@selector(pullDownRefreshTotalPixels)]) {
        return [self.delegate pullDownRefreshTotalPixels];
    }
    return kXHDefaultRefreshTotalPixels;
}

#pragma mark - Life Cycle

- (void)setup {
    
    
}

- (id)initWithScrollView:(UIScrollView *)scrollView {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

@end
