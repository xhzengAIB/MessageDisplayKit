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

@interface LeanChatConversationTableViewController ()

@property (nonatomic,strong) NSArray *conversations;

@end

@implementation LeanChatConversationTableViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title=@"消息";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[LeanChatManager manager] findRecentConversationsWithBlock:^(NSArray *objects, NSError *error) {
        if(error){
            NSLog(@"%@",error);
        }else{
            self.conversations=objects;
            [self.tableView reloadData];
        }
    }];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier=@"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell==nil){
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.textLabel.font=[UIFont systemFontOfSize:15];
    }
    cell.imageView.image=[UIImage imageNamed:@"avator"];
    AVIMConversation *conversation=self.conversations[indexPath.row];
    cell.textLabel.text=[conversation.members componentsJoinedByString:@"、"];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AVIMConversation *conversation=self.conversations[indexPath.row];
    NSMutableArray *clientIds=[conversation.members mutableCopy];
    [clientIds removeObject:kJackClientID];
    LeanChatMessageTableViewController *leanChatMessageTableViewController = [[LeanChatMessageTableViewController alloc] initWithClientIDs:clientIds];
    [self.navigationController pushViewController:leanChatMessageTableViewController animated:YES];
}

@end
