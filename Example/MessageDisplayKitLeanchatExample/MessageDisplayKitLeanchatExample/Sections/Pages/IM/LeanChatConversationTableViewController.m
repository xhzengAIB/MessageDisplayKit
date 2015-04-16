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
    [self loadData];
}

-(void)loadData{
    [[LeanChatManager manager] findRecentConversationsWithBlock:^(NSArray *objects, NSError *error) {
        if(error){
            NSLog(@"%@",error);
        }else{
            self.conversations=objects;
            [self.tableView reloadData];
        }
    }];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    WEAKSELF
    [[LeanChatManager manager] setupDidReceiveTypedMessageCompletion:^(AVIMConversation *conversation, AVIMTypedMessage *message) {
        BOOL found=NO;
        for(AVIMConversation* theConversation in self.conversations){
            if([theConversation.conversationId isEqualToString:
                theConversation.conversationId]){
                found=YES;
                break;
            }
        }
        if(found){
            [weakSelf.tableView reloadData];
        }else{
            [weakSelf loadData];
        }
    }];
    [self.tableView reloadData];
}

-(void)viewDidDisappear:(BOOL)animated{
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier=@"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell==nil){
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.textLabel.font=[UIFont systemFontOfSize:15];
        CGFloat imageInset=8;
        UIImageView *imgView=[[UIImageView alloc] initWithFrame:CGRectMake(10, imageInset, 44-imageInset*2, 44-imageInset*2)];
        imgView.backgroundColor=[UIColor clearColor];
        [imgView.layer setCornerRadius:4.0f];
        imgView.tag=100;
        JSBadgeView *badgeView=[[JSBadgeView alloc] initWithParentView:imgView alignment:JSBadgeViewAlignmentTopRight];
        badgeView.tag=101;
        [cell.contentView addSubview:imgView];
    }
    UIImageView* imageView=(UIImageView*)[cell viewWithTag:100];
    imageView.image=[UIImage imageNamed:@"avator"];
    AVIMConversation *conversation=self.conversations[indexPath.row];
    JSBadgeView *badgeView=(JSBadgeView*)[cell viewWithTag:101];
    if(conversation.unreadCount>0){
        badgeView.badgeText=[NSString stringWithFormat:@"%ld",(long)conversation.unreadCount];
    }else{
        badgeView.badgeText=nil;
    }
    cell.textLabel.text=[conversation.members componentsJoinedByString:@"、"];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AVIMConversation *conversation=self.conversations[indexPath.row];
    NSMutableArray *clientIds=[conversation.members mutableCopy];
    [clientIds removeObject:kJackClientID];
    LeanChatMessageTableViewController *leanChatMessageTableViewController = [[LeanChatMessageTableViewController alloc] initWithClientIDs:clientIds];
    [conversation clearUnreadCount];
    [self.navigationController pushViewController:leanChatMessageTableViewController animated:YES];
}

@end
