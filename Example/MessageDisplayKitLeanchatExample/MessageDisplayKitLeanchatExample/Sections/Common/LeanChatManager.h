//
//  LeanChatManager.h
//  MessageDisplayKitLeanchatExample
//
//  Created by Jack_iMac on 15/3/21.
//  Copyright (c) 2015年 iOS软件开发工程师 曾宪华 热衷于简洁的UI QQ:543413507 http://www.pailixiu.com/blog   http://www.pailixiu.com/Jack/personal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVOSCloud/AVOSCloud.h>
#import <AVOSCloudIM/AVOSCloudIM.h>

#define kJackClientID @"Jack"
#define kDarcyClientID @"Darcy"
#define kJaysonClientID @"Jayson"

typedef NS_ENUM(int, ConversationType) {
    ConversationTypeOneToOne = 0,
    ConversationTypeGrop = 1,
};

typedef void(^DidReceiveCommonMessageBlock)(AVIMMessage *message);
typedef void(^DidReceiveTypedMessageBlock)(AVIMTypedMessage *message);

@interface LeanChatManager : NSObject

+ (void)setupApplication;

+ (instancetype)manager;

- (void)setupDidReceiveCommonMessageCompletion:(DidReceiveCommonMessageBlock)didReceiveCommonMessageCompletion;
- (void)setupDidReceiveTypedMessageCompletion:(DidReceiveTypedMessageBlock)didReceiveTypedMessageCompletion;

- (void)openSessionWithClientID:(NSString *)clientID
                     completion:(void (^)(BOOL succeeded, NSError *error))completion;

- (void)createConversationsWithClientIDs:(NSArray *)clientIDs
                        conversationType:(ConversationType)conversationType
                              completion:(void (^)(BOOL succeeded, AVIMConversation *createConversation))completion;

@end
