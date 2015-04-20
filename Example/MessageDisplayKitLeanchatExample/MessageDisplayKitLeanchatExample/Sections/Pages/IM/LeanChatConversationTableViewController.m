//
//  LeanChatConversationTableViewController.m
//  MessageDisplayKitLeanchatExample
//
//  Created by lzw on 15/4/13.
//  Copyright (c) 2015年 iOS软件开发工程师 曾宪华 热衷于简洁的UI QQ:543413507 http://www.pailixiu.com/blog   http://www.pailixiu.com/Jack/personal. All rights reserved.
//

#import "LeanChatConversationTableViewController.h"
#import "LeanChatManager.h"
#import "LeanChatMessageTableViewController.h"
#import "AVIMConversation+Custom.h"
#import "JSBadgeView.h"
#import "LeanChatConversationTableViewCell.h"

@interface LeanChatConversationTableViewController ()

@property (nonatomic, strong) NSArray *conversations;

@end

@implementation LeanChatConversationTableViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.title = @"消息";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[LeanChatConversationTableViewCell class] forCellReuseIdentifier:[LeanChatConversationTableViewCell indentifier]];
    [self loadData];
}

- (void)loadData {
    [[LeanChatManager manager] findRecentConversationsWithBlock: ^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"%@", error);
        }
        else {
            self.conversations = objects;
            [self.tableView reloadData];
        }
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    WEAKSELF
    [[LeanChatManager manager] setupDidReceiveTypedMessageCompletion : ^(AVIMConversation *conversation, AVIMTypedMessage *message) {
        BOOL found = NO;
        for (AVIMConversation *theConversation in self.conversations) {
            if ([theConversation.conversationId isEqualToString:
                 theConversation.conversationId]) {
                found = YES;
                break;
            }
        }
        if (found) {
            [weakSelf.tableView reloadData];
        }
        else {
            [weakSelf loadData];
        }
    }];
    [self.tableView reloadData];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[LeanChatManager manager] setupDidReceiveTypedMessageCompletion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.conversations.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [LeanChatConversationTableViewCell heightOfConversationTableViewCell];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LeanChatConversationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[LeanChatConversationTableViewCell indentifier]];
    if (cell == nil) {
        cell = [[LeanChatConversationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[LeanChatConversationTableViewCell indentifier]];
    }
    AVIMConversation *conversation = self.conversations[indexPath.row];
    cell.conversation = conversation;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AVIMConversation *conversation = self.conversations[indexPath.row];
    NSMutableArray *clientIds = [conversation.members mutableCopy];
    [clientIds removeObject:kJackClientID];
    LeanChatMessageTableViewController *leanChatMessageTableViewController = [[LeanChatMessageTableViewController alloc] initWithClientIDs:clientIds];
    [conversation clearUnreadCount];
    [self.navigationController pushViewController:leanChatMessageTableViewController animated:YES];
}

@end
