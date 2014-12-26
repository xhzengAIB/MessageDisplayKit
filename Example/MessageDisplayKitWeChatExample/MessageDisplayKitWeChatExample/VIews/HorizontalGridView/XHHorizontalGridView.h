//
//  XHHorizontalGridView.h
//  MessageDisplayExample
//
//  Created by 曾 宪华 on 14-5-31.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XHHorizontalGridItem.h"
#import "XHHorizontalGridItemView.h"

@interface XHHorizontalGridView : UIView

@property (nonatomic, strong) UIScrollView *horizontalScrollView;
@property (nonatomic, strong) NSArray *gridItems;

- (void)reloadData;

@end
