//
//  LeanChatManager.h
//  MessageDisplayKitLeanchatExample
//
//  Created by Jack_iMac on 15/3/21.
//  Copyright (c) 2015年 嗨，我是曾宪华(@xhzengAIB)，曾加入YY Inc.担任高级移动开发工程师，拍立秀App联合创始人，热衷于简洁、而富有理性的事物 QQ:543413507 主页:http://zengxianhua.com All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVOSCloud/AVOSCloud.h>
#import <AVOSCloudIM/AVOSCloudIM.h>
#import "AVIMEmotionMessage.h"

#define kJackClientID @"Jack"
#define kDarcyClientID @"Darcy"
#define kJaysonClientID @"Jayson"

#define kDidReceiveCommonMessageNotification @"didReceiveCommonMessageNotification"
#define kDidReceiveTypedMessageNotification @"didReceiveTypedMessageNotification"

typedef enum : NSInteger{
    ConversationTypeOneToOne = 0,
    ConversationTypeGroup = 1,
}ConversationType;

typedef void(^DidReceiveCommonMessageBlock)(AVIMConversation *conversation, AVIMMessage *message);
typedef void(^DidReceiveTypedMessageBlock)(AVIMConversation *conversation, AVIMTypedMessage *message);

@interface LeanChatManager : NSObject

+ (void)setupApplication;

+ (instancetype)manager;

- (NSString *)selfClientID;

- (void)setupDidReceiveCommonMessageCompletion:(DidReceiveCommonMessageBlock)didReceiveCommonMessageCompletion;

- (void)setupDidReceiveTypedMessageCompletion:(DidReceiveTypedMessageBlock)didReceiveTypedMessageCompletion;

- (void)openSessionWithClientID:(NSString *)clientID
                     completion:(void (^)(BOOL succeeded, NSError *error))completion;

- (void)createConversationsWithClientIDs:(NSArray *)clientIDs
                        conversationType:(ConversationType)conversationType
                              completion:(void (^)(BOOL succeeded, AVIMConversation *createConversation))completion;

-(void)findRecentConversationsWithBlock:(AVIMArrayResultBlock)block;

@end
