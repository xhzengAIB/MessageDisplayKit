//
//  LeanChatManager.m
//  MessageDisplayKitLeanchatExample
//
//  Created by Jack_iMac on 15/3/21.
//  Copyright (c) 2015年 iOS软件开发工程师 曾宪华 热衷于简洁的UI QQ:543413507 http://www.pailixiu.com/blog   http://www.pailixiu.com/Jack/personal. All rights reserved.
//

#import "LeanChatManager.h"

#define kApplicationId @"3zkueubi18r0r0n47rc9revnlun0xuajsfv5byo17kdodut8"
#define kClientKey @"ujtz5q7cl84iqhtawjnbk32c4rqtjel3pz6xctekak054cje"

// 有常量定义：
const int kConversationTypeOneToOne = 0; // 表示一对一的单聊
const int kConversationTypeGroup = 1;  // 表示多人群聊

@interface LeanChatManager () <AVIMClientDelegate>

@property (nonatomic, strong) AVIMClient *learnClient;

@property (nonatomic, copy) NSString *selfClientID;

@property (nonatomic, copy) DidReceiveCommonMessageBlock didReceiveCommonMessageCompletion;
@property (nonatomic, copy) DidReceiveTypedMessageBlock didReceiveTypedMessageCompletion;

@end

@implementation LeanChatManager

+ (void)setupApplication {
    [AVOSCloud setApplicationId:kApplicationId clientKey:kClientKey];
}

+ (instancetype)manager {
    static LeanChatManager *leanChatManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        leanChatManager = [[LeanChatManager alloc] init];
    });
    return leanChatManager;
}

- (void)setup {
    self.learnClient = [[AVIMClient alloc] init];
    self.learnClient.delegate = self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setupDidReceiveCommonMessageCompletion:(DidReceiveCommonMessageBlock)didReceiveCommonMessageCompletion {
    _didReceiveCommonMessageCompletion = nil;
    _didReceiveCommonMessageCompletion = [didReceiveCommonMessageCompletion copy];
}

- (void)setupDidReceiveTypedMessageCompletion:(DidReceiveTypedMessageBlock)didReceiveTypedMessageCompletion {
    _didReceiveTypedMessageCompletion = nil;
    _didReceiveTypedMessageCompletion = [didReceiveTypedMessageCompletion copy];
}

- (void)openSessionWithClientID:(NSString *)clientID
                     completion:(void (^)(BOOL succeeded, NSError *error))completion {
    self.selfClientID = clientID;
    if (self.learnClient.status == AVIMClientStatusNone) {
        [self.learnClient openWithClientId:clientID callback:completion];
    } else {
        [self.learnClient closeWithCallback:^(BOOL succeeded, NSError *error) {
            [self.learnClient openWithClientId:clientID callback:completion];
        }];
    }
}

- (void)createConversationsWithClientIDs:(NSArray *)clientIDs
                        conversationType:(ConversationType)conversationType
                              completion:(void (^)(BOOL succeeded, AVIMConversation *createConversation))completion {
    NSMutableArray *targetClientIDs = [[NSMutableArray alloc] initWithArray:clientIDs];
    [targetClientIDs insertObject:self.selfClientID atIndex:0];
    [self createConversationsOnClientIDs:targetClientIDs conversationType:conversationType completion:completion];
}

- (void)createConversationsOnClientIDs:(NSArray *)clientIDs
                      conversationType:(int)conversationType
                            completion:(void (^)(BOOL, AVIMConversation *))completion {
    AVIMConversationQuery *query = [self.learnClient conversationQuery];
    NSMutableArray *queryClientIDs = [[NSMutableArray alloc] initWithArray:clientIDs];
    [queryClientIDs insertObject:self.selfClientID atIndex:0];
    [query whereKey:kAVIMKeyMember containsAllObjectsInArray:queryClientIDs];
    [query whereKey:AVIMAttr(@"type") equalTo:[NSNumber numberWithInt:conversationType]];
    [query findConversationsWithCallback:^(NSArray *objects, NSError *error) {
        if (error) {
            // 出错了，请稍候重试
            if (completion) {
                completion(NO, nil);
            }
        } else if (!objects || [objects count] < 1) {
            // 新建一个对话
            [self.learnClient createConversationWithName:nil
                                               clientIds:queryClientIDs
                                              attributes:@{@"type":[NSNumber numberWithInt:conversationType]}
                                                 options:AVIMConversationOptionNone
                                                callback:^(AVIMConversation *conversation, NSError *error) {
                                                    BOOL succeeded = YES;
                                                    if (error) {
                                                        succeeded = NO;
                                                    }
                                                    if (completion) {
                                                        completion(succeeded, conversation);
                                                    }
                                                }];
        } else {
            // 已经有一个对话存在，继续在这一对话中聊天
            AVIMConversation *conversation = [objects lastObject];
            if (completion) {
                completion(YES, conversation);
            }
        }
    }];
}

#pragma mark - AVIMClientDelegate

- (void)conversation:(AVIMConversation *)conversation didReceiveCommonMessage:(AVIMMessage *)message {
    // 接收到新的普通消息。
    if (self.didReceiveCommonMessageCompletion) {
        self.didReceiveCommonMessageCompletion(message);
    }
}

- (void)conversation:(AVIMConversation *)conversation didReceiveTypedMessage:(AVIMTypedMessage *)message {
    // 接收到新的富媒体消息。
    if (self.didReceiveTypedMessageCompletion) {
        self.didReceiveTypedMessageCompletion(message);
    }
}

@end
