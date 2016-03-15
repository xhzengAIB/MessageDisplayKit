//
//  XHHorizontalGridView.m
//  MessageDisplayExample
//
//  Created by 曾 宪华 on 14-5-31.
//  Copyright (c) 2014年 嗨，我是曾宪华(@xhzengAIB)，曾加入YY Inc.担任高级移动开发工程师，拍立秀App联合创始人，热衷于简洁、而富有理性的事物 QQ:543413507 主页:http://zengxianhua.com All rights reserved.
//

#import "XHHorizontalGridView.h"

#define kXHGridItemBaseTag 100

@implementation XHHorizontalGridView

- (void)reloadData {
    for (int i = 0; i < self.gridItems.count; i ++) {
        XHHorizontalGridItemView *gridItemView = (XHHorizontalGridItemView *)[self.horizontalScrollView viewWithTag:i + kXHGridItemBaseTag];
        if (!gridItemView) {
            gridItemView = [[XHHorizontalGridItemView alloc] initWithFrame:CGRectMake(i * (80 + 10), 0, 80, 120)];
            gridItemView.tag = kXHGridItemBaseTag + i;
            [self.horizontalScrollView addSubview:gridItemView];
        }
        XHHorizontalGridItem *gridItem = [self.gridItems objectAtIndex:i];
        gridItemView.gridItem = gridItem;
    }
    [self.horizontalScrollView setContentSize:CGSizeMake(self.gridItems.count * (80 + 10), CGRectGetHeight(self.bounds))];
}

#pragma mark - Propertys

- (UIScrollView *)horizontalScrollView {
    if (!_horizontalScrollView) {
        _horizontalScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        [_horizontalScrollView setScrollsToTop:NO];
        _horizontalScrollView.showsVerticalScrollIndicator = NO;
        _horizontalScrollView.showsHorizontalScrollIndicator = NO;
    }
    return _horizontalScrollView;
}

#pragma mark - Life Cycle

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self addSubview:self.horizontalScrollView];
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
