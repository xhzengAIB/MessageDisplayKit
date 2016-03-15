//
//  ViewController.m
//  MessageDisplayKitLeanchatExample
//
//  Created by Jack_iMac on 15/3/21.
//  Copyright (c) 2015年 嗨，我是曾宪华(@xhzengAIB)，曾加入YY Inc.担任高级移动开发工程师，拍立秀App联合创始人，热衷于简洁、而富有理性的事物 QQ:543413507 主页:http://zengxianhua.com All rights reserved.
//

#import "LeanChatViewController.h"
#import "LeanChatMessageTableViewController.h"
#import "LeanChatManager.h"
#import "LeanChatConversationTableViewController.h"


@interface LeanChatViewController ()

@end

@implementation LeanChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [[XHConfigurationHelper appearance] setupPopMenuTitles:@[NSLocalizedStringFromTable(@"copy", @"MessageDisplayKitString", @"复制文本消息")]];
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

- (IBAction)enterRecentConversations:(id)sender {
    [[LeanChatManager manager] openSessionWithClientID:kJackClientID completion:^(BOOL succeeded, NSError *error) {
        LeanChatConversationTableViewController* conversationTableViewController=[[LeanChatConversationTableViewController alloc] init];
        [self.navigationController pushViewController:conversationTableViewController animated:YES];
    }];
}

- (void)navigationToIMWithTargetClientIDs:(NSArray *)clientIDs {
    LeanChatMessageTableViewController *leanChatMessageTableViewController = [[LeanChatMessageTableViewController alloc] initWithClientIDs:clientIDs];
    [self.navigationController pushViewController:leanChatMessageTableViewController animated:YES];
}

@end
