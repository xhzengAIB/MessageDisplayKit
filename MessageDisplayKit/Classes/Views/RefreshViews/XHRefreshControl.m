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

#define fequal(a,b) (fabs((a) - (b)) < FLT_EPSILON)
#define fequalzero(a) (fabs(a) < FLT_EPSILON)

#define kXHDefaultRefreshTotalPixels 60

#define kXHAutoLoadMoreRefreshedCount 5


typedef NS_ENUM(NSInteger, XHRefreshState) {
    XHRefreshStatePulling   = 0,
    XHRefreshStateNormal    = 1,
    XHRefreshStateLoading   = 2,
    XHRefreshStateStopped   = 3,
};

@interface XHRefreshControl ()

@property (nonatomic, strong) XHRefreshView *refreshView;

@property (nonatomic, strong) XHLoadMoreView *loadMoreView;

@property (nonatomic, assign) BOOL isPullDownRefreshed;

@property (nonatomic, assign) BOOL isLoadMoreRefreshed;

@property (nonatomic, assign) CGFloat refreshTotalPixels;

@property (nonatomic, assign) NSInteger autoLoadMoreRefreshedCount;

@property (nonatomic, readwrite) CGFloat originalTopInset;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, assign) XHRefreshState refreshState;

@property (nonatomic, assign) NSInteger loadMoreRefreshedCount;

@property (nonatomic, assign) BOOL pullDownRefreshing;

@property (nonatomic, assign) BOOL loadMoreRefreshing;

@end

@implementation XHRefreshControl

#pragma mark - Pull Down Refreshing Method

- (void)startPullDownRefreshing {
    self.pullDownRefreshing = YES;
    
    NSDate *date = [self.delegate lastUpdateTime];
    if (date || [date isKindOfClass:[NSDate class]]) {
        self.refreshView.timeLabel.text = [NSString stringWithFormat:@"上次刷新：%@", @"10小时前"];
    }
    
    self.refreshState = XHRefreshStatePulling;
    
    self.refreshState = XHRefreshStateLoading;
}

- (void)animationRefreshCircleView {
    if (self.refreshView.refreshCircleView.offsetY != kXHDefaultRefreshTotalPixels - kXHRefreshCircleViewHeight) {
        self.refreshView.refreshCircleView.offsetY = kXHDefaultRefreshTotalPixels - kXHRefreshCircleViewHeight;
        [self.refreshView.refreshCircleView setNeedsDisplay];
    }
    // 先去除所有动画
    [self.refreshView.refreshCircleView.layer removeAllAnimations];
    // 添加旋转的动画
    [self.refreshView.refreshCircleView.layer addAnimation:[XHRefreshCircleView repeatRotateAnimation] forKey:@"rotateAnimation"];
    
    [self callBeginPullDownRefreshing];
}

- (void)callBeginPullDownRefreshing {
    [self.delegate beginPullDownRefreshing];
}

- (void)endPullDownRefreshing {
    self.pullDownRefreshing = NO;
    self.refreshState = XHRefreshStateStopped;
    
    [self resetScrollViewContentInset];
}

#pragma mark - Load More Refreshing Method

- (void)startLoadMoreRefreshing {
    NSLog(@"进入上提多少次");
    //    if (self.loadMoreRefreshedCount < self.autoLoadMoreRefreshedCount) {
    [self callBeginLoadMoreRefreshing];
    //    }
}

- (void)callBeginLoadMoreRefreshing {
    if (self.loadMoreRefreshing)
        return;
    self.loadMoreRefreshing = YES;
    self.loadMoreRefreshedCount ++;
    self.refreshState = XHRefreshStateLoading;
    [self.loadMoreView startLoading];
    [self.delegate beginLoadMoreRefreshing];
}

- (void)endLoadMoreRefresing {
    self.loadMoreRefreshing = NO;
    self.refreshState = XHRefreshStateNormal;
    [self.loadMoreView endLoading];
}

- (void)loadMoreButtonClciked:(UIButton *)sender {
    [self callBeginLoadMoreRefreshing];
}

#pragma mark - Scroll View

- (void)resetScrollViewContentInset {
    UIEdgeInsets contentInset = self.scrollView.contentInset;
    contentInset.top = self.originalTopInset;
    [UIView animateWithDuration:0.3f animations:^{
        [self.scrollView setContentInset:contentInset];
    } completion:^(BOOL finished) {
        
        self.refreshState = XHRefreshStateNormal;
        
        if (self.refreshView.refreshCircleView) {
            [self.refreshView.refreshCircleView.layer removeAllAnimations];
        }
    }];
}

- (void)setScrollViewContentInset:(UIEdgeInsets)contentInset {
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.scrollView.contentInset = contentInset;
                     }
                     completion:^(BOOL finished) {
                         if (self.refreshState == XHRefreshStateStopped) {
                             self.refreshState = XHRefreshStateNormal;
                             
                             if (self.refreshView.refreshCircleView) {
                                 [self.refreshView.refreshCircleView.layer removeAllAnimations];
                             }
                         }
                     }];
}

- (void)setScrollViewContentInsetForLoading {
    UIEdgeInsets currentInsets = self.scrollView.contentInset;
    currentInsets.top = self.refreshTotalPixels;
    [self setScrollViewContentInset:currentInsets];
}

- (void)setScrollViewContentInsetForLoadMore {
    if (self.pullDownRefreshing)
        return;
    UIEdgeInsets currentInsets = self.scrollView.contentInset;
    currentInsets.bottom = kXHLoadMoreViewHeight;
    [self setScrollViewContentInset:currentInsets];
}

#pragma mark - Propertys

- (XHRefreshView *)refreshView {
    if (!_refreshView) {
        _refreshView = [[XHRefreshView alloc] initWithFrame:CGRectMake(0, -kXHDefaultRefreshTotalPixels, CGRectGetWidth([[UIScreen mainScreen] bounds]), kXHDefaultRefreshTotalPixels)];
        _refreshView.refreshCircleView.heightBeginToRefresh = kXHDefaultRefreshTotalPixels - kXHRefreshCircleViewHeight;
        _refreshView.refreshCircleView.offsetY = 0;
    }
    return _refreshView;
}

- (XHLoadMoreView *)loadMoreView {
    if (!_loadMoreView) {
        _loadMoreView = [[XHLoadMoreView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([[UIScreen mainScreen] bounds]), kXHLoadMoreViewHeight)];
        [_loadMoreView.loadMoreButton addTarget:self action:@selector(loadMoreButtonClciked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loadMoreView;
}

#pragma mark - Getter Method

- (BOOL)isLoading {
    return [self.delegate isLoading];
}

- (BOOL)isPullDownRefreshed {
    if ([self.delegate respondsToSelector:@selector(isPullDownRefreshed)]) {
        return [self.delegate isPullDownRefreshed];
    }
    return YES;
}

- (BOOL)isLoadMoreRefreshed {
    if ([self.delegate respondsToSelector:@selector(isLoadMoreRefreshed)]) {
        return [self.delegate isLoadMoreRefreshed];
    }
    return YES;
}

- (CGFloat)refreshTotalPixels {
    return kXHDefaultRefreshTotalPixels + [self getAdaptorHeight];
}

- (CGFloat)getAdaptorHeight {
    if ([self.delegate respondsToSelector:@selector(keepiOS7NewApiCharacter)]) {
        return ([self.delegate keepiOS7NewApiCharacter] ? 64 : 0);
    } else {
        return 0;
    }
}

- (NSInteger)autoLoadMoreRefreshedCount {
    if ([self.delegate respondsToSelector:@selector(autoLoadMoreRefreshedCountConverManual)]) {
        return [self.delegate autoLoadMoreRefreshedCountConverManual];
    }
    return kXHAutoLoadMoreRefreshedCount;
}

#pragma mark - Setter Method

- (void)setRefreshState:(XHRefreshState)refreshState {
    switch (refreshState) {
        case XHRefreshStateStopped:
        case XHRefreshStateNormal: {
            self.refreshView.stateLabel.text = @"下拉刷新";
            break;
        }
        case XHRefreshStateLoading: {
            
            if (self.pullDownRefreshing) {
                self.refreshView.stateLabel.text = @"正在加载";
                [self setScrollViewContentInsetForLoading];
                
                if(_refreshState == XHRefreshStatePulling) {
                    [self animationRefreshCircleView];
                }
            }
            break;
        }
        case XHRefreshStatePulling:
            self.refreshView.stateLabel.text = @"释放立即刷新";
            break;
        default:
            break;
    }
    
    _refreshState = refreshState;
}

#pragma mark - Life Cycle

- (void)configuraObserverWithScrollView:(UIScrollView *)scrollView {
    [scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    [scrollView addObserver:self forKeyPath:@"contentInset" options:NSKeyValueObservingOptionNew context:nil];
    [scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)removeObserverWithScrollView:(UIScrollView *)scrollView {
    [scrollView removeObserver:self forKeyPath:@"contentOffset" context:nil];
    [scrollView removeObserver:self forKeyPath:@"contentInset" context:nil];
    [scrollView removeObserver:self forKeyPath:@"contentSize" context:nil];
}

- (void)setup {
    self.refreshState = XHRefreshStateNormal;
    
    [self configuraObserverWithScrollView:self.scrollView];
    
    [self.scrollView addSubview:self.refreshView];
    [self.scrollView addSubview:self.loadMoreView];
    
    self.originalTopInset = self.scrollView.contentInset.top;
}

- (id)initWithScrollView:(UIScrollView *)scrollView {
    self = [super init];
    if (self) {
        self.scrollView = scrollView;
        [self setup];
    }
    return self;
}

- (void)dealloc {
    self.delegate = nil;
    [self removeObserverWithScrollView:self.scrollView];
    self.scrollView = nil;
    
    self.refreshView = nil;
    
    self.loadMoreView = nil;
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentOffset"]) {
        CGPoint contentOffset = [[change valueForKey:NSKeyValueChangeNewKey] CGPointValue];
        
        
        // 上提加载更多的逻辑方法
        int currentPostion = contentOffset.y;
        
        if (currentPostion > 0) {
            
            CGRect bounds = self.scrollView.bounds;//边界
            
            CGSize size = self.scrollView.contentSize;//滚动视图内容区域size
            
            UIEdgeInsets inset = self.scrollView.contentInset;//视图周围额外的滚动视图区域
            
            float y = currentPostion + bounds.size.height + inset. bottom;
            
            //判断是否滚动到底部
            if((y - size.height) > kXHLoadMoreViewHeight && self.refreshState != XHRefreshStateLoading && self.isLoadMoreRefreshed && !self.loadMoreRefreshing) {
                [self startLoadMoreRefreshing];
            }
        }
        
        if (!self.loadMoreRefreshing) {
            // 下拉刷新的逻辑方法
            if(self.refreshState != XHRefreshStateLoading) {
                // 如果不是加载状态的时候
                
                if (ABS(self.scrollView.contentOffset.y + [self getAdaptorHeight]) >= kXHRefreshCircleViewHeight) {
                    self.refreshView.refreshCircleView.offsetY = MIN(ABS(self.scrollView.contentOffset.y + [self getAdaptorHeight]), kXHDefaultRefreshTotalPixels) - kXHRefreshCircleViewHeight;
                    [self.refreshView.refreshCircleView setNeedsDisplay];
                }
                
                CGFloat scrollOffsetThreshold;
                scrollOffsetThreshold = -(kXHDefaultRefreshTotalPixels + self.originalTopInset);
                
                if(!self.scrollView.isDragging && self.refreshState == XHRefreshStatePulling) {
                    self.pullDownRefreshing = YES;
                    self.refreshState = XHRefreshStateLoading;
                } else if(contentOffset.y < scrollOffsetThreshold && self.scrollView.isDragging && self.refreshState == XHRefreshStateStopped) {
                    self.refreshState = XHRefreshStatePulling;
                } else if(contentOffset.y >= scrollOffsetThreshold && self.refreshState != XHRefreshStateStopped) {
                    self.refreshState = XHRefreshStateStopped;
                }
            } else {
                CGFloat offset;
                UIEdgeInsets contentInset;
                offset = MAX(self.scrollView.contentOffset.y * -1, 0.0f);
                offset = MIN(offset, self.refreshTotalPixels);
                contentInset = self.scrollView.contentInset;
                self.scrollView.contentInset = UIEdgeInsetsMake(offset, contentInset.left, contentInset.bottom, contentInset.right);
            }
        }
    } else if ([keyPath isEqualToString:@"contentInset"]) {
        UIEdgeInsets contentInset = [[change valueForKey:NSKeyValueChangeNewKey] UIEdgeInsetsValue];
        NSLog(@"contentInset : %@", NSStringFromUIEdgeInsets(contentInset));
    } else if ([keyPath isEqualToString:@"contentSize"]) {
        CGSize contentSize = [[change valueForKey:NSKeyValueChangeNewKey] CGSizeValue];
        NSLog(@"contentSize : %@", NSStringFromCGSize(contentSize));
        if (contentSize.height > CGRectGetHeight(self.scrollView.frame)) {
            CGRect loadMoreViewFrame = self.loadMoreView.frame;
            loadMoreViewFrame.origin.y = contentSize.height;
            self.loadMoreView.frame = loadMoreViewFrame;
            [self setScrollViewContentInsetForLoadMore];
        }
    }
}

@end
