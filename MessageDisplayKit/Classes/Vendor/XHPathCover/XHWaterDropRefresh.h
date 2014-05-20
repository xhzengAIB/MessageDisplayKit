//
//  XHWaterDropRefresh.h
//  XHPathCover
//
//  Created by 曾 宪华 on 14-2-7.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XHWaterDropRefresh : UIView

@property (nonatomic, assign) CGFloat radius; // default is 5.
@property (nonatomic, assign) CGFloat maxOffset; // default is 70
@property (nonatomic, assign) CGFloat deformationLength; // default is 0.4 (between 0.1 -- 0.9)
@property (nonatomic, assign) CGFloat offsetHeight;
@property (nonatomic, strong) UIImage *refreshCircleImage;
@property (nonatomic, readonly) BOOL isRefreshing;

- (void)stopRefresh;
- (void)startRefreshAnimation;

@property (nonatomic, copy) void(^handleRefreshEvent)(void) ;
@property (nonatomic) float currentOffset;

@end
