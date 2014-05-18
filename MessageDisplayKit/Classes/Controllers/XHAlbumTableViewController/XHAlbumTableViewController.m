//
//  XHAlbumTableViewController.m
//  MessageDisplayExample
//
//  Created by qtone-1 on 14-5-17.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHAlbumTableViewController.h"

#import "XHAlbumHeaderContainerView.h"
#import "XHAlbumTableViewCell.h"

@interface XHAlbumTableViewController ()

@property (nonatomic, strong) XHAlbumHeaderContainerView *albumHeaderContainerView;

@end

@implementation XHAlbumTableViewController

#pragma mark - Propertys

- (XHAlbumHeaderContainerView *)albumHeaderContainerView {
    if (!_albumHeaderContainerView) {
        _albumHeaderContainerView = [[XHAlbumHeaderContainerView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 200)];
    }
    return _albumHeaderContainerView;
}

#pragma mark - DataSource Manager

- (void)loadDataSource {
    WEAKSELF
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray *dataSource = [[XHStoreManager shareStoreManager] getAlbumConfigureArray];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.dataSource = dataSource;
            [weakSelf.tableView reloadData];
        });
    });
}

#pragma Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedStringFromTable(@"Album", @"MessageDisplayKitString", @"个人信息");
    
    self.tableView.tableHeaderView = self.albumHeaderContainerView;
    [self.view addSubview:self.tableView];
    [self configuraTableViewnNormalSeparatorInset];
    
    [self loadDataSource];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView DataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"albumTableViewCellIdentifier";
    
    XHAlbumTableViewCell *albumTableViewCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!albumTableViewCell) {
        albumTableViewCell = [[XHAlbumTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    if (indexPath.row < self.dataSource.count) {
        albumTableViewCell.currentAlbum = self.dataSource[indexPath.row];
    }
    
    return albumTableViewCell;
}

#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

@end
