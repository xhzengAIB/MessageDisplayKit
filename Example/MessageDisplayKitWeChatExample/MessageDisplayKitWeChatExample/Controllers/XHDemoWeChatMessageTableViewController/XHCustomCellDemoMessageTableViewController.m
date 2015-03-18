//
//  XHCustomCellDemoMessageTableViewController.m
//  MessageDisplayKitWeChatExample
//
//  Created by Jack_iMac on 15/2/11.
//  Copyright (c) 2015年 iOS软件开发工程师 曾宪华 热衷于简洁的UI QQ:543413507 http://www.pailixiu.com/blog   http://www.pailixiu.com/Jack/personal. All rights reserved.
//

#import "XHCustomCellDemoMessageTableViewController.h"

@implementation XHCustomCellDemoMessageTableViewController

- (XHMessage *)getTextMessageWithBubbleMessageType:(XHBubbleMessageType)bubbleMessageType {
    XHMessage *textMessage = [[XHMessage alloc] initWithText:@"Call Me 15915895880.这是华捷微信，为什么模仿这个页面效果呢？希望微信团队能看到我们在努力，请微信团队给个机会，让我好好的努力靠近大神，希望自己也能发亮，好像有点过分的希望了，如果大家喜欢这个开源库，请大家帮帮忙支持这个开源库吧！我是Jack，叫华仔也行，曾宪华就是我啦！" sender:@"华仔" timestamp:[NSDate distantPast]];
    textMessage.avatar = [UIImage imageNamed:@"avatar"];
    textMessage.avatarUrl = @"http://www.pailixiu.com/jack/meIcon@2x.png";
    textMessage.bubbleMessageType = bubbleMessageType;
    
    return textMessage;
}

- (NSMutableArray *)customDataSource {
    NSMutableArray *dataSource = [[NSMutableArray alloc] init];
    for (int i = 0; i < 20; i ++) {
        [dataSource addObject:[self getTextMessageWithBubbleMessageType:(i % 2) ? XHBubbleMessageTypeSending : XHBubbleMessageTypeReceiving]];
    }
    return dataSource;
}

- (void)loadDemoDataSource {
    WEAKSELF
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray *messages = [weakSelf customDataSource];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.messages = messages;
            [weakSelf.messageTableView reloadData];
            
            [weakSelf scrollToBottomAnimated:NO];
        });
    });
}

#pragma mark - XHMessageTableViewController Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath targetMessage:(id<XHMessageModel>)message {
    CGFloat maxWidth = CGRectGetWidth([[UIScreen mainScreen] bounds]);
    CGSize textSize = [[message text] sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(maxWidth, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    
    CGFloat cellHeight = textSize.height + 44;
    
    return cellHeight;
}

#pragma mark - XHMessageTableViewController DataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath targetMessage:(id<XHMessageModel>)message {
    UITableViewCell *tableViewCell = [tableView dequeueReusableCellWithIdentifier:@"Identifier"];
    
    if (!tableViewCell) {
        tableViewCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Identifier"];
        tableViewCell.textLabel.textColor = [UIColor redColor];
        tableViewCell.detailTextLabel.textColor = [UIColor grayColor];
        tableViewCell.detailTextLabel.font = [UIFont systemFontOfSize:14];
        tableViewCell.detailTextLabel.numberOfLines = 0;
        tableViewCell.detailTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
    }
    tableViewCell.textLabel.text = [message sender];
    tableViewCell.detailTextLabel.text = [message text];
    
    return tableViewCell;
}

@end
