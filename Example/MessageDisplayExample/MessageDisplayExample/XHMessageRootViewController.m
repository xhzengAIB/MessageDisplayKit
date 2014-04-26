//
//  XHMessageRootViewController.m
//  MessageDisplayExample
//
//  Created by qtone-1 on 14-4-26.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHMessageRootViewController.h"

#import "XHMessageTableViewController.h"

@interface XHMessageRootViewController ()

@end

@implementation XHMessageRootViewController

- (void)enterMessage {
    XHMessageTableViewController *messageTableViewController = [[XHMessageTableViewController alloc] init];
    [self.navigationController pushViewController:messageTableViewController animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIButton *enterMessageTableViewControllerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    enterMessageTableViewControllerButton.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds));
    [enterMessageTableViewControllerButton setTitle:@"进入消息页面" forState:UIControlStateNormal];
    [enterMessageTableViewControllerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [enterMessageTableViewControllerButton addTarget:self action:@selector(enterMessage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:enterMessageTableViewControllerButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
