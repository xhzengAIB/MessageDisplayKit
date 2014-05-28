//
//  XHLocationServiceTableViewController.m
//  MessageDisplayExample
//
//  Created by qtone-1 on 14-5-17.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHLocationServiceTableViewController.h"

#import "XHStoreManager.h"

#import "XHLocationServiceTableViewCell.h"

#import "XHContactDetailTableViewController.h"

@interface XHLocationServiceTableViewController ()

@end

@implementation XHLocationServiceTableViewController

#pragma mark - DataSource

- (void)loadDataSource {
    self.dataSource = [[XHStoreManager shareStoreManager] getLocationServiceArray];
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedStringFromTable(@"NearbyPeople", @"MessageDisplayKitString", @"附近的人");
    
    [self loadDataSource];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView DataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";
    XHLocationServiceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[XHLocationServiceTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    [cell configureCellWithItem:self.dataSource[indexPath.row] atIndexPath:indexPath];
    
    return cell;
}

#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (kXHNearAvatorSize + kXHNearAvatorSpacing * 2);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XHContact *contact = [[XHContact alloc] init];
    contact.contactName = self.dataSource[indexPath.row];
    XHContactDetailTableViewController *contactDetailTableViewController = [[XHContactDetailTableViewController alloc] initWithContact:contact];
    [self pushNewViewController:contactDetailTableViewController];
}

@end
