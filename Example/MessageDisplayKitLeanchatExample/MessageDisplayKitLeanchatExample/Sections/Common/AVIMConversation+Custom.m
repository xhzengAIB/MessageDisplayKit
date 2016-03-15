//
//  AVIMConversation+Custom.m
//  MessageDisplayKitLeanchatExample
//
//  Created by lzw on 15/4/17.
//  Copyright (c) 2015年 嗨，我是曾宪华(@xhzengAIB)，曾加入YY Inc.担任高级移动开发工程师，拍立秀App联合创始人，热衷于简洁、而富有理性的事物 QQ:543413507 主页:http://zengxianhua.com All rights reserved.
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
