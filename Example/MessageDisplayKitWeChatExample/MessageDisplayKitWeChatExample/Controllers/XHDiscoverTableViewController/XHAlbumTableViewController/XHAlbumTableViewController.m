//
//  XHAlbumTableViewController.m
//  MessageDisplayExample
//
//  Created by HUAJIE-1 on 14-5-17.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHAlbumTableViewController.h"

#import <MessageDisplayKit/XHMacro.h>
#import <MessageDisplayKit/XHPhotographyHelper.h>

#import "XHPathCover.h"
#import "XHAlbumTableViewCell.h"

#import "XHStoreManager.h"

#import "XHAlbumOperationView.h"

@interface XHAlbumTableViewController () <XHAlbumTableViewCellDelegate>

/**
 *  视觉差的TableViewHeaderView
 */
@property (nonatomic, strong) XHPathCover *albumHeaderContainerViewPathCover;

@property (nonatomic, strong) XHPhotographyHelper *photographyHelper;

@property (nonatomic, strong) XHAlbumOperationView *operationView;

@end

@implementation XHAlbumTableViewController

#pragma mark - Propertys

- (XHPathCover *)albumHeaderContainerViewPathCover {
    if (!_albumHeaderContainerViewPathCover) {
        _albumHeaderContainerViewPathCover = [[XHPathCover alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 200)];
        [_albumHeaderContainerViewPathCover setBackgroundImage:[UIImage imageNamed:@"AlbumHeaderBackgrounImage"]];
        [_albumHeaderContainerViewPathCover setAvatarImage:[UIImage imageNamed:@"MeIcon"]];
        [_albumHeaderContainerViewPathCover setInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Jack xhzengAIB", XHUserNameKey, @"1990-10-19", XHBirthdayKey, nil]];
        _albumHeaderContainerViewPathCover.isZoomingEffect = YES;
        
        WEAKSELF
        [_albumHeaderContainerViewPathCover setHandleRefreshEvent:^{
            [weakSelf loadDataSource];
        }];
        
        [_albumHeaderContainerViewPathCover setHandleTapBackgroundImageEvent:^{
            [weakSelf.photographyHelper showOnPickerViewControllerSourceType:UIImagePickerControllerSourceTypePhotoLibrary onViewController:weakSelf compled:^(UIImage *image, NSDictionary *editingInfo) {
                if (image) {
                    [weakSelf.albumHeaderContainerViewPathCover setBackgroundImage:image];
                } else {
                    if (!editingInfo)
                        return ;
                    [weakSelf.albumHeaderContainerViewPathCover setBackgroundImage:[editingInfo valueForKey:UIImagePickerControllerOriginalImage]];
                }
            }];
        }];
        
    }
    return _albumHeaderContainerViewPathCover;
}

- (XHPhotographyHelper *)photographyHelper {
    if (!_photographyHelper) {
        _photographyHelper = [[XHPhotographyHelper alloc] init];
    }
    return _photographyHelper;
}

- (XHAlbumOperationView *)operationView {
    if (!_operationView) {
        _operationView = [XHAlbumOperationView initailzerAlbumOperationView];
        _operationView.didSelectedOperationCompletion = ^(XHAlbumOperationType operationType) {
            NSLog(@"operationType : %ld", operationType);
        };
    }
    return _operationView;
}

#pragma mark - DataSource

- (void)loadDataSource {
    WEAKSELF
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray *dataSource = [[XHStoreManager shareStoreManager] getAlbumConfigureArray];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.albumHeaderContainerViewPathCover stopRefresh];
            weakSelf.dataSource = dataSource;
            [weakSelf.tableView reloadData];
        });
    });
}

#pragma mark - Life Cycle

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedStringFromTable(@"Album", @"MessageDisplayKitString", @"朋友圈");
    
    [self configureBarbuttonItemStyle:XHBarbuttonItemStyleCamera action:^{
        DLog(@"发送朋友圈");
    }];
    
    self.tableView.tableHeaderView = self.albumHeaderContainerViewPathCover;
    
    [self configuraTableViewNormalSeparatorInset];
    
    [self loadDataSource];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    self.albumHeaderContainerViewPathCover = nil;
}

#pragma mark - XHAlbumTableViewCellDelegate

- (void)didShowOperationView:(UIButton *)sender indexPath:(NSIndexPath *)indexPath {
    CGRect rectInTableView = [self.tableView rectForRowAtIndexPath:indexPath];
    CGFloat origin_Y = rectInTableView.origin.y + sender.frame.origin.y;
    CGRect targetRect = CGRectMake(CGRectGetMinX(sender.frame), origin_Y, CGRectGetWidth(sender.bounds), CGRectGetHeight(sender.bounds));
    if (self.operationView.shouldShowed) {
        [self.operationView dismiss];
        return;
    }
    [self.operationView showAtView:self.tableView rect:targetRect];
}

#pragma mark- UIScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_albumHeaderContainerViewPathCover scrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [_albumHeaderContainerViewPathCover scrollViewDidEndDecelerating:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [_albumHeaderContainerViewPathCover scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.operationView dismiss];
    
    [_albumHeaderContainerViewPathCover scrollViewWillBeginDragging:scrollView];
}

#pragma mark - UITableView DataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"albumTableViewCellIdentifier";
    
    XHAlbumTableViewCell *albumTableViewCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!albumTableViewCell) {
        albumTableViewCell = [[XHAlbumTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        albumTableViewCell.delegate = self;
    }
    
    if (indexPath.row < self.dataSource.count) {
        albumTableViewCell.indexPath = indexPath;
        albumTableViewCell.currentAlbum = self.dataSource[indexPath.row];
    }
    
    return albumTableViewCell;
}

#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [XHAlbumTableViewCell calculateCellHeightWithAlbum:self.dataSource[indexPath.row]];
}

@end
