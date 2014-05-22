//
//  XHDiscoverTableViewController.m
//  MessageDisplayExample
//
//  Created by qtone-1 on 14-5-17.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHDiscoverTableViewController.h"

#import "XHAlbumTableViewController.h"
#import "XHQRCodeViewController.h"
#import "XHShakeViewController.h"
#import "XHLocationServiceTableViewController.h"
#import "XHBottleViewController.h"
#import "XHMoreGameTableViewController.h"

#import "XHStoreManager.h"

@interface XHDiscoverTableViewController ()

@end

@implementation XHDiscoverTableViewController

#pragma mark - DataSource

- (void)loadDataSource {
    self.dataSource = [[XHStoreManager shareStoreManager] getDiscoverConfigureArray];
    
    
}

#pragma mark - Life Cycle

- (id)init {
    self = [super init];
    if (self) {
        self.tableViewStyle = UITableViewStyleGrouped;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!self.dataSource.count)
        [self loadDataSource];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    [self configuraTableViewnNormalSeparatorInset];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    if (indexPath.row < self.dataSource.count) {
        NSDictionary *disconverDictionary = self.dataSource[indexPath.section];
        cell.imageView.image = [UIImage imageNamed:[disconverDictionary valueForKey:@"image"][indexPath.row]];
        cell.textLabel.text = [disconverDictionary valueForKey:@"title"][indexPath.row];
    }
    
    return cell;
}

#pragma markr - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 14;
            break;
        case 1:
        case 2:
        case 3:
            return 4;
            break;
        default:
            break;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0: {
            [self pushNewViewController:[[XHAlbumTableViewController alloc] init]];
            break;
        }
        case 1: {
            if (indexPath.row) {
                [self pushNewViewController:[[XHShakeViewController alloc] init]];
            } else {
                [self pushNewViewController:[[XHQRCodeViewController alloc] init]];
            }
            break;
        }
        case 2: {
            if (indexPath.row) {
                [self pushNewViewController:[[XHBottleViewController alloc] init]];
            } else {
                [self pushNewViewController:[[XHLocationServiceTableViewController alloc] init]];
            }
            break;
        }
        default:
            break;
    }
}

@end
