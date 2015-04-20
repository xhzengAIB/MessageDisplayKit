//
//  LeanChatConversationTableViewCell.h
//  MessageDisplayKitLeanchatExample
//
//  Created by lzw on 15/4/17.
//  Copyright (c) 2015年 iOS软件开发工程师 曾宪华 热衷于简洁的UI QQ:543413507 http://www.pailixiu.com/blog   http://www.pailixiu.com/Jack/personal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVOSCloudIM/AVOSCloudIM.h>

static CGFloat kConversationTableViewCellImageSize=35;
static CGFloat kConversationTableViewCellVerticalSpacing=8;
static CGFloat kConversationTableViewCellHorizontalSpacing=10;

@interface LeanChatConversationTableViewCell : UITableViewCell

+(NSString*)indentifier;

+(CGFloat)heightOfConversationTableViewCell;

@property (nonatomic, strong) AVIMConversation *conversation;

@end
