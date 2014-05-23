//
//  XHContactDetailTableViewController.m
//  MessageDisplayExample
//
//  Created by dw_iOS on 14-5-23.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHContactDetailTableViewController.h"

@interface XHContactDetailTableViewController ()

@property (nonatomic, strong) XHContact *contact;

@end

@implementation XHContactDetailTableViewController

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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
