//
//  AVIMConversation+Custom.m
//  MessageDisplayKitLeanchatExample
//
//  Created by lzw on 15/4/17.
//  Copyright (c) 2015年 iOS软件开发工程师 曾宪华 热衷于简洁的UI QQ:543413507 http://www.pailixiu.com/blog   http://www.pailixiu.com/Jack/personal. All rights reserved.
//

#import "AVIMConversation+Custom.h"
#import "LeanChatCoreDataManager.h"

@implementation AVIMConversation(Custom)


-(void)checkConversationId{
    if(self.conversationId==nil){
        [NSException raise:@"AVIMConversation" format:@"conversation is nil"];
    }
}

-(NSInteger)unreadCount{
    [self checkConversationId];
    return [[LeanChatCoreDataManager manager] fetchUnreadCountByConversationId:self.conversationId];
}

-(void)clearUnreadCount{
    [self checkConversationId];
    [[LeanChatCoreDataManager manager] clearUnreadCountByConversationId:self.conversationId];
}

@end
