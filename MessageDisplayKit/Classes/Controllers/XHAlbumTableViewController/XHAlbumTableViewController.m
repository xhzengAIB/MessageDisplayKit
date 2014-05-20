//
//  XHAlbumTableViewController.m
//  MessageDisplayExample
//
//  Created by qtone-1 on 14-5-17.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHAlbumTableViewController.h"

#import "XHPathCover.h"
#import "XHAlbumHeaderContainerView.h"
#import "XHAlbumTableViewCell.h"

#import "XHStoreManager.h"

@interface XHAlbumTableViewController ()

@property (nonatomic, strong) XHPathCover *pathCover;
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

- (XHPathCover *)pathCover {
    if (!_pathCover) {
        _pathCover = [[XHPathCover alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 250)];
        [_pathCover setBackgroundImage:[UIImage imageNamed:@"AlbumHeaderBackgrounImage"]];
        [_pathCover setAvatarImage:[UIImage imageNamed:@"avator"]];
        [_pathCover setInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Jack xhzengAIB", XHUserNameKey, @"1990-10-19", XHBirthdayKey, nil]];
        _pathCover.isZoomingEffect = YES;
        
        WEAKSELF
        [_pathCover setHandleRefreshEvent:^{
            [weakSelf loadDataSource];
        }];
    }
    return _pathCover;
}

#pragma mark - DataSource Manager

- (void)loadDataSource {
    WEAKSELF
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray *dataSource = [[XHStoreManager shareStoreManager] getAlbumConfigureArray];
        sleep(3);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.pathCover stopRefresh];
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
    
    
    self.tableView.tableHeaderView = self.pathCover;
    [self.view addSubview:self.tableView];
    
    [self configuraTableViewnNormalSeparatorInset];
    
    [self loadDataSource];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
}

#pragma mark- UIScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_pathCover scrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [_pathCover scrollViewDidEndDecelerating:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [_pathCover scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [_pathCover scrollViewWillBeginDragging:scrollView];
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
