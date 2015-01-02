//
//  XHPullRefreshTableViewController.m
//  MessageDisplayExample
//
//  Created by 曾 宪华 on 14-6-6.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHPullRefreshTableViewController.h"

#import "XHRefreshControl.h"

@interface XHPullRefreshTableViewController () <XHRefreshControlDelegate>

@property (nonatomic, strong) XHRefreshControl *refreshControl;

@end

@implementation XHPullRefreshTableViewController

- (void)startPullDownRefreshing {
    [self.refreshControl startPullDownRefreshing];
}

- (void)endPullDownRefreshing {
    [self.refreshControl endPullDownRefreshing];
}

- (void)endLoadMoreRefreshing {
    [self.refreshControl endLoadMoreRefresing];
}

#pragma mark - Propertys

- (XHRefreshControl *)refreshControl {
    if (!_refreshControl) {
        _refreshControl = [[XHRefreshControl alloc] initWithScrollView:self.tableView delegate:self];
    }
    return _refreshControl;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - XHRefreshControl Delegate

- (BOOL)isLoading {
    return self.isDataLoading;
}

- (void)beginPullDownRefreshing {
    self.requestCurrentPage = 0;
    [self loadDataSource];
}

- (void)beginLoadMoreRefreshing {
    self.requestCurrentPage ++;
    [self loadDataSource];
}

- (NSDate *)lastUpdateTime {
    return [NSDate date];
}

- (BOOL)keepiOS7NewApiCharacter {
    if (!self.navigationController)
        return NO;
    BOOL keeped = [[[UIDevice currentDevice] systemVersion] integerValue] >= 7.0;
    return keeped;
}

- (NSInteger)autoLoadMoreRefreshedCountConverManual {
    return 2;
}

- (XHRefreshViewLayerType)refreshViewLayerType {
    return XHRefreshViewLayerTypeOnSuperView;
}

@end
