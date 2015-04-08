//
//  AVStatus.h
//  paas
//
//  Created by Travis on 13-12-23.
//  Copyright (c) 2013年 AVOS. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AVUser.h"
#import "AVQuery.h"


extern NSString * const kAVStatusTypeTimeline;
extern NSString * const kAVStatusTypePrivateMessage;

typedef NSString AVStatusType;

@class AVStatus,AVStatusQuery;
typedef void (^AVStatusResultBlock)(AVStatus *status, NSError *error);


/**
 *  发送和获取状态更新和消息
 */
@interface AVStatus : NSObject

/**
 *  此状态的ID 具有唯一性
 */
@property(nonatomic,readonly) NSString *objectId;

/**
 *  此状态在用户某个Type的收件箱中的ID
 *  @warning 仅用于分片查询,不具有唯一性,同一条状态在不同的inbox里的messageId也是不同的
 */
@property(nonatomic,readonly) NSUInteger messageId;

/**
 *  状态的创建时间
 */
@property(nonatomic,readonly) NSDate *createdAt;

/**
 *  状态的内容
 */
@property(nonatomic,strong) NSDictionary *data;

/**
 *  状态的发出"人",可以是AVUser 也可以是任意的AVObject,也可能是nil
 */
@property(nonatomic,strong) AVObject *source;

/**
 *  状态类型,默认是kAVStatusTypeTimeline, 可以是任意自定义字符串
 */
@property(nonatomic,strong) AVStatusType *type;



/** @name 针对某条状态的操作 */

/**
 *  获取某条状态
 *
 *  @param objectId 状态的objectId
 *  @param callback 回调结果
 */
+(void)getStatusWithID:(NSString *)objectId andCallback:(AVStatusResultBlock)callback;

/**
 *  删除当前用户发布的某条状态
 *
 *  @param objectId 状态的objectId
 *  @param callback 回调结果
 */
+(void)deleteStatusWithID:(NSString*)objectId andCallback:(AVBooleanResultBlock)callback;

/**
 *  设置受众群体
 *
 *  @param query 限定条件
 */
-(void)setQuery:(AVQuery*)query;


/** @name 获取状态 */

/**
 *  获取当前用户收件箱里的状态
 *
 *  @param inboxType 收件箱类型
 *  @return 用于查询的AVStatusQuery
 */
+(AVStatusQuery*)inboxQuery:(AVStatusType *)inboxType;

/**
 *  获取当前用户发出的状态
 *
 *  @return 用于查询的AVStatusQuery
 */
+(AVStatusQuery*)statusQuery;


/**
 *  获取当前用户特定类型未读状态条数
 *  @param type 收件箱类型
 *  @param callback 回调结果
 */
+(void)getUnreadStatusesCountWithType:(AVStatusType*)type andCallback:(AVIntegerResultBlock)callback;

/**
 *  获取当前用户接收到的状态
 *  @param type     状态类型,默认是kAVStatusTypeTimeline, 可以是任意自定义字符串
 *  @param skip     跳过条数
 *  @param limit    需要返回的条数 默认`100`，最大`100`
 *  @param callback 回调结果
 */
+(void)getStatusesWithType:(AVStatusType*)type skip:(NSUInteger)skip limit:(NSUInteger)limit andCallback:(AVArrayResultBlock)callback AVDeprecated("2.3.2以后不再需要，请使用inboxQuery类方法");

/**
 *  获取当前用户发布的状态
 *
 *  @param type     状态类型,默认是kAVStatusTypeTimeline, 可以是任意自定义字符串
 *  @param skip     跳过条数
 *  @param limit    需要返回的条数 默认`100`，最大`100`
 *  @param callback 回调结果
 */
+(void) getStatusesFromCurrentUserWithType:(AVStatusType*)type skip:(NSUInteger)skip limit:(NSUInteger)limit andCallback:(AVArrayResultBlock)callback AVDeprecated("2.3.2以后不再需要，请使用statusQuery类方法");

/**
 *  通过用户ID获取其发布的公开的状态列表
 *
 *  @param userId   用户的objectId
 *  @param skip     跳过条数
 *  @param limit    需要返回的条数 默认`100`，最大`100`
 *  @param callback 回调结果
 */
+(void) getStatusesFromUser:(NSString*)userId skip:(NSUInteger)skip limit:(NSUInteger)limit andCallback:(AVArrayResultBlock)callback AVDeprecated("2.3.2以后不再需要，请使用statusQuery");

/** @name 发送状态 */

/**
 *  向用户的粉丝发送新状态
 *
 *  @param  status 状态
 *  @param  callback 回调结果
 */
+(void)sendStatusToFollowers:(AVStatus*)status andCallback:(AVBooleanResultBlock)callback;

/**
 *  向用户发私信
 *
 *  @param  status 状态
 *  @param  userId 接受私信的用户objectId
 *  @param  callback 回调结果
 */
+(void)sendPrivateStatus:(AVStatus*)status toUserWithID:(NSString*)userId andCallback:(AVBooleanResultBlock)callback;

/**
 *  发送
 *
 *  @param block 回调结果
 */
-(void)sendInBackgroundWithBlock:(AVBooleanResultBlock)block;
@end

/**
 *  用户好友关系
 */
@interface AVUser(Friendship)

/* @name 好友关系 */

/**
 *  获取用户粉丝AVQuery
 *
 *  @param userObjectId 用户ID
 *
 *  @return 用于查询的AVQuery
 */
+(AVQuery*)followerQuery:(NSString*)userObjectId;

/**
 *  获取本用户粉丝AVQuery
 *
 *  @return 用于查询的AVQuery
 */
-(AVQuery*)followerQuery;

/**
 *  获取用户关注AVQuery
 *
 *  @param userObjectId 用户ID
 *
 *  @return 用于查询的AVQuery
 */
+(AVQuery*)followeeQuery:(NSString*)userObjectId;

/**
 *  获取本用户关注AVQuery
 *
 *  @return 用于查询的AVQuery
 */
-(AVQuery*)followeeQuery;

/**
 *  通过ID来关注其他用户
 *  @warning 如果需要被关注者收到消息 需要手动给他发送一条AVStatus.
 *  @param userId 要关注的用户objectId
 *  @param callback 回调结果
 */
-(void)follow:(NSString*)userId andCallback:(AVBooleanResultBlock)callback;

/**
 *  通过ID来关注其他用户
 *  @warning 如果需要被关注者收到消息 需要手动给他发送一条AVStatus.
 *  @param userId 要关注的用户objectId
 *  @param dictionary 添加的自定义属性
 *  @param callback 回调结果
 */
-(void)follow:(NSString*)userId userDictionary:(NSDictionary *)dictionary andCallback:(AVBooleanResultBlock)callback;

/**
 *  通过ID来取消关注其他用户
 *
 *  @param userId 要取消关注的用户objectId
 *  @param callback 回调结果
 *
 */
-(void)unfollow:(NSString*)userId andCallback:(AVBooleanResultBlock)callback;

/**
 *  获取当前用户粉丝的列表
 *
 *  @param callback 回调结果
 */
-(void)getFollowers:(AVArrayResultBlock)callback;

/**
 *  获取当前用户所关注的列表
 *
 *  @param callback 回调结果
 *
 */
-(void)getFollowees:(AVArrayResultBlock)callback;

/**
 *  同时获取当前用户的粉丝和关注列表
 *
 *  @param callback 回调结果, 列表字典包含`followers`数组和`followees`数组
 */
-(void)getFollowersAndFollowees:(AVDictionaryResultBlock)callback;


@end

/**
 *  查询AVStatus
 */
@interface AVStatusQuery : AVQuery
/**
 *  设置起始messageId, 仅用于Inbox中的查询
 */
@property(nonatomic, assign) NSUInteger sinceId;

/**
 *  设置最大messageId, 仅用于Inbox中的查询
 */
@property(nonatomic, assign) NSUInteger maxId;

/**
 *  设置查询的Inbox的所有者, 即查询这个"人"的收件箱
 */
@property(nonatomic, strong) AVObject *owner;

/**
 *  设置查询的Inbox的类型
 */
@property(nonatomic, copy) AVStatusType *inboxType;

/**
 *  查询结果是否已经到结尾
 */
@property(nonatomic)BOOL end;
@end
