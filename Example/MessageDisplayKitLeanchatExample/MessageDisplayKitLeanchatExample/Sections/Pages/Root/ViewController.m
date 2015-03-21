//
//  ViewController.m
//  MessageDisplayKitLeanchatExample
//
//  Created by Jack_iMac on 15/3/21.
//  Copyright (c) 2015年 iOS软件开发工程师 曾宪华 热衷于简洁的UI QQ:543413507 http://www.pailixiu.com/blog   http://www.pailixiu.com/Jack/personal. All rights reserved.
//

#import "ViewController.h"

#import "LeanChatMessageTableViewController.h"

#import "LeanChatManager.h"

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

- (IBAction)enterJackToDarcySingleIM:(id)sender {
    // 打开通信链路
    [[LeanChatManager manager] openSessionWithClientID:kJackClientID completion:^(BOOL succeeded, NSError *error) {
        NSLog(@"成功与否 : %d  错误 : %@", succeeded, error);
        [self navigationToIMWithTargetClientIDs:@[kDarcyClientID]];
    }];
}

- (IBAction)enterDarcyToJackSingleIM:(id)sender {
    // 打开通信链路
    [[LeanChatManager manager] openSessionWithClientID:kDarcyClientID completion:^(BOOL succeeded, NSError *error) {
        NSLog(@"成功与否 : %d  错误 : %@", succeeded, error);
        [self navigationToIMWithTargetClientIDs:@[kJackClientID]];
    }];
}

- (IBAction)enterMultipleIM:(id)sender {
    // 打开通信链路
    [[LeanChatManager manager] openSessionWithClientID:kJackClientID completion:^(BOOL succeeded, NSError *error) {
        NSLog(@"成功与否 : %d  错误 : %@", succeeded, error);
        [self navigationToIMWithTargetClientIDs:@[kJackClientID, kDarcyClientID, kJaysonClientID]];
    }];
}

- (void)navigationToIMWithTargetClientIDs:(NSArray *)clientIDs {
    LeanChatMessageTableViewController *leanChatMessageTableViewController = [[LeanChatMessageTableViewController alloc] initWithClientIDs:clientIDs];
    [self.navigationController pushViewController:leanChatMessageTableViewController animated:YES];
}

@end
