//
//  XHContactDetailTableViewController.m
//  MessageDisplayExample
//
//  Created by dw_iOS on 14-5-23.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHContactDetailTableViewController.h"

#import "XHContactView.h"

@interface XHContactDetailTableViewController ()

@property (nonatomic, strong) XHContact *contact;

@property (nonatomic, strong) XHContactView *contactUserInfoView;

@end

@implementation XHContactDetailTableViewController

#pragma mark - Propertys

- (XHContactView *)contactUserInfoView {
    if (!_contactUserInfoView) {
        _contactUserInfoView = [[XHContactView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 100)];
    }
    _contactUserInfoView.displayContact = self.contact;
    return _contactUserInfoView;
}

#pragma mark - Life Cycle

- (instancetype)initWithContact:(XHContact *)contact {
    self = [super init];
    if (self) {
        self.contact = contact;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.contact.contactName;
    
    self.tableView.tableHeaderView = self.contactUserInfoView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureCellWithIndexPath:(NSIndexPath *)indexPath onTableViewCell:(UITableViewCell *)cell {
    NSString *placeholder;
    NSString *detailText;
    switch (indexPath.row) {
        case 0:
            placeholder = @"地区";
            detailText = @"广州";
            break;
        case 1:
            placeholder = @"个人签名";
            detailText = @"目标：哈哈客户多久啊上课";
            break;
        case 2:
            placeholder = @"腾讯微博";
            detailText = @"@xhzengAIB@gmail.com";
            break;
        case 3:
            placeholder = @"个人相册";
            break;
        default:
            break;
    }
    cell.textLabel.text = placeholder;
    cell.detailTextLabel.text = detailText;
}

#pragma mark - UITableView DataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = self.contact.contactName;
    cell.detailTextLabel.text = self.contact.userId;
    
    return cell;
}

@end
