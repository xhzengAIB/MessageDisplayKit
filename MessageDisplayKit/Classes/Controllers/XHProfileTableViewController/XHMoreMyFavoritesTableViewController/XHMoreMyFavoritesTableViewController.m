//
//  XHMoreMyFavoritesTableViewController.m
//  MessageDisplayExample
//
//  Created by 曾 宪华 on 14-5-22.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHMoreMyFavoritesTableViewController.h"

@interface XHMoreMyFavoritesTableViewController ()

@end

@implementation XHMoreMyFavoritesTableViewController

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedStringFromTable(@"MyFavorites", @"MessageDisplayKitString", @"");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
