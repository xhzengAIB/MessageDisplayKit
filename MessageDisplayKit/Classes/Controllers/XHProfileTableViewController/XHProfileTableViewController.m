//
//  XHProfileTableViewController.m
//  MessageDisplayExample
//
//  Created by qtone-1 on 14-5-10.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHProfileTableViewController.h"

@interface XHProfileTableViewController ()

@end

@implementation XHProfileTableViewController

#pragma Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedStringFromTable(@"Profile", @"MessageDisplayKitString", @"个人信息");
    
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
