//
//  LeanChatCoreDataManager.m
//  MessageDisplayKitLeanchatExample
//
//  Created by lzw on 15/4/17.
//  Copyright (c) 2015年 iOS软件开发工程师 曾宪华 热衷于简洁的UI QQ:543413507 http://www.pailixiu.com/blog   http://www.pailixiu.com/Jack/personal. All rights reserved.
//

#import "LeanChatCoreDataManager.h"

#define kConversationEntityName @"Conversation"
#define kConversationIdKey @"conversationId"
#define kUnreadCountKey @"unreadCount"

@implementation LeanChatCoreDataManager


@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

+ (instancetype)manager {
    static LeanChatCoreDataManager *leanChatManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        leanChatManager = [[LeanChatCoreDataManager alloc] init];
    });
    return leanChatManager;
}

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.HUAJIE.MessageDisplayKitLeanchatExample" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"MessageDisplayKitLeanchatExample" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"MessageDisplayKitLeanchatExample.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data With Conversation

- (NSManagedObject*)fetchConversationEntityByConversationId:(NSString*)conversationId{
    NSManagedObjectContext *context=self.managedObjectContext;
    NSFetchRequest *request=[[NSFetchRequest alloc] initWithEntityName:kConversationEntityName];
    [request setPredicate:[NSPredicate predicateWithFormat:@"%K = %@",kConversationIdKey,conversationId]];
    NSError *error;
    NSArray *objects=[context executeFetchRequest:request error:&error];
    if(error){
        NSLog(@"%@",error);
    }
    if(objects.count>0){
        return objects[0];
    }else{
        return nil;
    }
}

- (void)increaseUnreadCountByConversationId:(NSString*)conversationId{
    NSManagedObjectContext *context=self.managedObjectContext;
    NSManagedObject *theConversation=[self fetchConversationEntityByConversationId:conversationId];
    NSInteger theUnreadCount;
    if(theConversation==nil){
        theConversation=[NSEntityDescription insertNewObjectForEntityForName:kConversationEntityName inManagedObjectContext:context];
        theUnreadCount=1;
    }else{
        theUnreadCount=[[theConversation valueForKey:kUnreadCountKey] intValue]+1;
    }
    [theConversation setValue:conversationId forKey:kConversationIdKey];
    [theConversation setValue:@(theUnreadCount) forKey:kUnreadCountKey];
    [self saveContext];
}

- (NSInteger)fetchUnreadCountByConversationId:(NSString*)conversationId{
    NSManagedObject *conversation=[self fetchConversationEntityByConversationId:conversationId];
    if(conversation){
        return [[conversation valueForKey:kUnreadCountKey] intValue];
    }else{
        return 0;
    }
}

- (void)clearUnreadCountByConversationId:(NSString*)conversationId{
    NSManagedObject *conversation=[self fetchConversationEntityByConversationId:conversationId];
    if(conversation==nil){
        return;
    }
    [conversation setValue:@0 forKey:kUnreadCountKey];
    [self saveContext];
}

@end
