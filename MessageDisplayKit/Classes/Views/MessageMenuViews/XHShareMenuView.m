//
//  XHShareMenuView.m
//  MessageDisplayExample
//
//  Created by qtone-1 on 14-5-1.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHShareMenuView.h"
#import "XHMacro.h"

// 每行有4个
#define kXHShareMenuPerRowItemCount (kIsiPad ? 10 : 4)
#define kXHShareMenuPerColum 2

@interface XHShareMenuItemView : UIView

/**
 *  第三方按钮
 */
@property (nonatomic, weak) UIButton *shareMenuItemButton;
/**
 *  第三方按钮的标题
 */
@property (nonatomic, weak) UILabel *shareMenuItemTitleLabel;

/**
 *  配置默认控件的方法
 */
- (void)setup;
@end

@implementation XHShareMenuItemView

- (void)setup {
    if (!_shareMenuItemButton) {
        UIButton *shareMenuItemButton = [UIButton buttonWithType:UIButtonTypeCustom];
        shareMenuItemButton.frame = CGRectMake(0, 0, kXHShareMenuItemIconSize, kXHShareMenuItemIconSize);
        shareMenuItemButton.backgroundColor = [UIColor clearColor];
        [self addSubview:shareMenuItemButton];
        
        self.shareMenuItemButton = shareMenuItemButton;
    }
    
    if (!_shareMenuItemTitleLabel) {
        UILabel *shareMenuItemTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.shareMenuItemButton.frame), kXHShareMenuItemIconSize, KXHShareMenuItemHeight - kXHShareMenuItemIconSize)];
        shareMenuItemTitleLabel.backgroundColor = [UIColor clearColor];
        shareMenuItemTitleLabel.textColor = [UIColor blackColor];
        shareMenuItemTitleLabel.font = [UIFont systemFontOfSize:12];
        shareMenuItemTitleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:shareMenuItemTitleLabel];
        
        self.shareMenuItemTitleLabel = shareMenuItemTitleLabel;
    }
}

- (void)awakeFromNib {
    [self setup];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

@end

@interface XHShareMenuView () <UIScrollViewDelegate>

/**
 *  这是背景滚动视图
 */
@property (nonatomic, weak) UIScrollView *shareMenuScrollView;

/**
 *  显示页码的视图
 */
@property (nonatomic, weak) UIPageControl *shareMenuPageControl;

/**
 *  第三方按钮点击的事件
 *
 *  @param sender 第三方按钮对象
 */
- (void)shareMenuItemButtonClicked:(UIButton *)sender;

/**
 *  配置默认控件
 */
- (void)setup;

@end

@implementation XHShareMenuView

- (void)shareMenuItemButtonClicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(didSelecteShareMenuItem:atIndex:)]) {
        NSInteger index = sender.tag;
        if (index < self.shareMenuItems.count) {
            [self.delegate didSelecteShareMenuItem:[self.shareMenuItems objectAtIndex:index] atIndex:index];
        }
    }
}

- (void)reloadData {
    if (!_shareMenuItems.count)
        return;
    
    [self.shareMenuScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    CGFloat paddingX = 16;
    CGFloat paddingY = 10;
    for (XHShareMenuItem *shareMenuItem in self.shareMenuItems) {
        NSInteger index = [self.shareMenuItems indexOfObject:shareMenuItem];
        NSInteger page = index / (kXHShareMenuPerRowItemCount * 2);
        CGRect shareMenuItemViewFrame = CGRectMake((index % kXHShareMenuPerRowItemCount) * (kXHShareMenuItemIconSize + paddingX) + paddingX + (page * CGRectGetWidth(self.bounds)), ((index / kXHShareMenuPerRowItemCount) - kXHShareMenuPerColum * page) * (KXHShareMenuItemHeight + paddingY) + paddingY, kXHShareMenuItemIconSize, KXHShareMenuItemHeight);
        XHShareMenuItemView *shareMenuItemView = [[XHShareMenuItemView alloc] initWithFrame:shareMenuItemViewFrame];
        
        shareMenuItemView.shareMenuItemButton.tag = index;
        [shareMenuItemView.shareMenuItemButton addTarget:self action:@selector(shareMenuItemButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [shareMenuItemView.shareMenuItemButton setImage:shareMenuItem.normalIconImage forState:UIControlStateNormal];
        shareMenuItemView.shareMenuItemTitleLabel.text = shareMenuItem.title;
        
        [self.shareMenuScrollView addSubview:shareMenuItemView];
    }
    
    self.shareMenuPageControl.numberOfPages = (self.shareMenuItems.count / (kXHShareMenuPerRowItemCount * 2) + (self.shareMenuItems.count % (kXHShareMenuPerRowItemCount * 2) ? 1 : 0));
    [self.shareMenuScrollView setContentSize:CGSizeMake(((self.shareMenuItems.count / (kXHShareMenuPerRowItemCount * 2) + (self.shareMenuItems.count % (kXHShareMenuPerRowItemCount * 2) ? 1 : 0)) * CGRectGetWidth(self.bounds)), CGRectGetHeight(self.shareMenuScrollView.bounds))];
}

#pragma mark - Life cycle

- (void)setup {
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    if (!_shareMenuScrollView) {
        UIScrollView *shareMenuScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - kXHShareMenuPageControlHeight)];
        shareMenuScrollView.delegate = self;
        shareMenuScrollView.canCancelContentTouches = NO;
        shareMenuScrollView.delaysContentTouches = YES;
        shareMenuScrollView.backgroundColor = self.backgroundColor;
        shareMenuScrollView.showsHorizontalScrollIndicator = NO;
        shareMenuScrollView.showsVerticalScrollIndicator = NO;
        [shareMenuScrollView setScrollsToTop:NO];
        shareMenuScrollView.pagingEnabled = YES;
        [self addSubview:shareMenuScrollView];
        
        self.shareMenuScrollView = shareMenuScrollView;
    }
    
    if (!_shareMenuPageControl) {
        UIPageControl *shareMenuPageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.shareMenuScrollView.frame), CGRectGetWidth(self.bounds), kXHShareMenuPageControlHeight)];
        shareMenuPageControl.backgroundColor = self.backgroundColor;
        shareMenuPageControl.hidesForSinglePage = YES;
        shareMenuPageControl.defersCurrentPageDisplay = YES;
        [self addSubview:shareMenuPageControl];
        
        self.shareMenuPageControl = shareMenuPageControl;
    }
}

- (void)awakeFromNib {
    [self setup];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}

- (void)dealloc {
    self.shareMenuItems = nil;
    self.shareMenuScrollView.delegate = self;
    self.shareMenuScrollView = nil;
    self.shareMenuPageControl = nil;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (newSuperview) {
        [self reloadData];
    }
}

#pragma mark - UIScrollView delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    //每页宽度
    CGFloat pageWidth = scrollView.frame.size.width;
    //根据当前的坐标与页宽计算当前页码
    NSInteger currentPage = floor((scrollView.contentOffset.x - pageWidth/2)/pageWidth)+1;
    [self.shareMenuPageControl setCurrentPage:currentPage];
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
