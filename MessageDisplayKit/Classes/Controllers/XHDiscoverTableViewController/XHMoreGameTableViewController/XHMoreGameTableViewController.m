//
//  XHMoreGameTableViewController.m
//  MessageDisplayExample
//
//  Created by qtone-1 on 14-5-17.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHMoreGameTableViewController.h"

#import "XHMacro.h"

@interface XHMoreGameTableViewController ()

@end

@implementation XHMoreGameTableViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedStringFromTable(@"Gamge", @"MessageDisplayKitString", @"游戏");
    
    [self configureBarbuttonItemStyle:kXHBarbuttonItemMoreStyle action:^{
        DLog(@"游戏更多");
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
