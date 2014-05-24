//
//  XHContactDetailTableViewController.m
//  MessageDisplayExample
//
//  Created by dw_iOS on 14-5-23.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHContactDetailTableViewController.h"

#import "XHContactView.h"

#import "XHContactCommunicationView.h"

@interface XHContactDetailTableViewController ()

@property (nonatomic, strong) XHContact *contact;

@property (nonatomic, strong) XHContactView *contactUserInfoView;

@property (nonatomic, strong) XHContactCommunicationView *contactCommunicationView;

@end

@implementation XHContactDetailTableViewController

#pragma mark - Action

- (void)videoCommunicationButtonClicked:(UIButton *)sender {
    
}

- (void)messageCommunicationButtonClicked:(UIButton *)sender {
    
}

#pragma mark - Propertys

- (XHContactView *)contactUserInfoView {
    if (!_contactUserInfoView) {
        _contactUserInfoView = [[XHContactView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), kXHAlbumAvatorSpacing * 2 + kXHContactAvatorSize)];
    }
    _contactUserInfoView.displayContact = self.contact;
    return _contactUserInfoView;
}

- (XHContactCommunicationView *)contactCommunicationView {
    if (!_contactCommunicationView) {
        _contactCommunicationView = [[XHContactCommunicationView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), (kXHContactButtonHeight + kXHContactButtonSpacing) * 2)];
        _contactCommunicationView.backgroundColor = [UIColor clearColor];
        [_contactCommunicationView.videoCommunicationButton addTarget:self action:@selector(videoCommunicationButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_contactCommunicationView.messageCommunicationButton addTarget:self action:@selector(messageCommunicationButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _contactCommunicationView;
}

#pragma mark - DataSource

- (void)loadDataSource {
    self.dataSource = (NSMutableArray *)@[self.contact.local, self.contact.description, self.contact.userId, self.contact.myAlbums];
}

#pragma mark - Life Cycle

- (instancetype)initWithContact:(XHContact *)contact {
    self = [super init];
    if (self) {
        self.tableViewStyle = UITableViewStyleGrouped;
        self.contact = contact;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.contact.contactName;
    
    self.tableView.tableHeaderView = self.contactUserInfoView;
    
    self.tableView.tableFooterView = self.contactCommunicationView;
    
    [self loadDataSource];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    NSString *placeholder;
    NSString *detailText;
    
    cell.accessoryType = UITableViewCellAccessoryNone;
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
        case 3: {
            placeholder = @"个人相册";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        }
        default:
            break;
    }
    cell.textLabel.text = placeholder;
    cell.detailTextLabel.text = detailText;
}

#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 3) {
        return 80;
    } else {
        return 44;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
