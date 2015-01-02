//
//  XHRefreshView.h
//  MessageDisplayExample
//
//  Created by 曾 宪华 on 14-6-6.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XHRefreshCircleView.h"

@interface XHRefreshView : UIView

@property (nonatomic, strong) XHRefreshCircleView *refreshCircleView;

@property (nonatomic, strong) UILabel *stateLabel;

@property (nonatomic, strong) UILabel *timeLabel;

@end
