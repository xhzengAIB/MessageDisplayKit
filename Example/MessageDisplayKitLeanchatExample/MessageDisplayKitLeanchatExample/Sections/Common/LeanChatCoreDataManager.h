//
//  LeanChatCoreDataManager.h
//  MessageDisplayKitLeanchatExample
//
//  Created by lzw on 15/4/17.
//  Copyright (c) 2015年 iOS软件开发工程师 曾宪华 热衷于简洁的UI QQ:543413507 http://www.pailixiu.com/blog   http://www.pailixiu.com/Jack/personal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface LeanChatCoreDataManager : NSObject

+ (instancetype)manager;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;

- (NSURL *)applicationDocumentsDirectory;

- (void)increaseUnreadCountByConversationId:(NSString*)conversationId;

- (NSInteger)fetchUnreadCountByConversationId:(NSString*)conversationId;

- (void)clearUnreadCountByConversationId:(NSString*)conversationId;

@end
