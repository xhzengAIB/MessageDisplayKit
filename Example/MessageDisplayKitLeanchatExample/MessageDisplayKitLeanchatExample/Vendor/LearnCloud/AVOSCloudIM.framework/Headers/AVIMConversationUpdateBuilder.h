//
//  AVIMConversationUpdateBuilder.h
//  AVOSCloudIM
//
//  Created by Qihe Bian on 1/8/15.
//  Copyright (c) 2015 LeanCloud Inc. All rights reserved.
//

#import "AVIMCommon.h"

@interface AVIMConversationUpdateBuilder : NSObject
/*!
 名称
 */
@property(nonatomic, strong)NSString *name;

/*!
 属性合集，修改此属性会覆盖 setObject:forKey: 和 removeObjectForKey: 所做的修改
 */
@property(nonatomic, strong)NSDictionary *attributes;

/*!
 生成更新字典
 @return 更新用的字典
 */
- (NSDictionary *)dictionary;

/*!
 获取 attributes 中 key 对应的值
 @param key 获取数据的 key 值
 @return key 对应的值
 */
- (id)objectForKey:(NSString *)key;

/*!
 设置 attributes 中 key 对应的值为 object
 @param object 设置的对象，传 [NSNull null] 将在服务器端删除对应的 key
 @param key 设置的 key 值
 */
- (void)setObject:(id)object forKey:(NSString *)key;

/*!
 移除 attributes 中的 key
 @param key 移除的 key 值
 */
- (void)removeObjectForKey:(NSString *)key;

@end
