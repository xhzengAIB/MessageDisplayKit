//
//  ViewController.m
//  MessageDisplayKitLeanchatExample
//
//  Created by Jack_iMac on 15/3/21.
//  Copyright (c) 2015年 iOS软件开发工程师 曾宪华 热衷于简洁的UI QQ:543413507 http://www.pailixiu.com/blog   http://www.pailixiu.com/Jack/personal. All rights reserved.
//

#import "ViewController.h"

#import "LeanChatMessageTableViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)enterSingleIM:(id)sender {
    [self navigationToIM];
}

- (IBAction)enterMultipleIM:(id)sender {
    [self navigationToIM];
}

- (void)navigationToIM {
    LeanChatMessageTableViewController *leanChatMessageTableViewController = [[LeanChatMessageTableViewController alloc] init];
    [self.navigationController pushViewController:leanChatMessageTableViewController animated:YES];
}

@end
