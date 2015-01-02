//
//  XHPullRefreshTableViewController.h
//  MessageDisplayExample
//
//  Created by 曾 宪华 on 14-6-6.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHBaseTableViewController.h"

@interface XHPullRefreshTableViewController : XHBaseTableViewController

@property (nonatomic, assign) BOOL isDataLoading;

@property (nonatomic, assign) NSInteger requestCurrentPage;

- (void)startPullDownRefreshing;

- (void)endPullDownRefreshing;

- (void)endLoadMoreRefreshing;

@end
