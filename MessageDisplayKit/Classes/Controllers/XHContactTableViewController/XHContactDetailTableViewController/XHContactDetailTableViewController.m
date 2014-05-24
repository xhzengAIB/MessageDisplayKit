//
//  XHContactDetailTableViewController.m
//  MessageDisplayExample
//
//  Created by dw_iOS on 14-5-23.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHContactDetailTableViewController.h"

#import "XHContactView.h"
#import "XHContactPhotosTableViewCell.h"
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
    self.dataSource = (NSMutableArray *)@[self.contact.contactRegion, self.contact.contactIntroduction, self.contact.contactUserId, self.contact.contactMyAlbums];
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
    XHContactPhotosTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[XHContactPhotosTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    [cell configureCellWithContactInfo:self.dataSource[indexPath.row] atIndexPath:indexPath];
    
    return cell;
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
