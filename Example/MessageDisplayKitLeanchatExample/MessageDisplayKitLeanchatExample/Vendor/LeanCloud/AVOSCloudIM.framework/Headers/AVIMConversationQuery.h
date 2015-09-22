//
//  AVIMConversationQuery.h
//  AVOSCloudIM
//
//  Created by Qihe Bian on 2/3/15.
//  Copyright (c) 2015 LeanCloud Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AVIMCommon.h"

#define AVIMAttr(attr) ([NSString stringWithFormat:@"attr.%@", attr])

extern NSString *const kAVIMKeyName;
extern NSString *const kAVIMKeyMember;
extern NSString *const kAVIMKeyCreator;
extern NSString *const kAVIMKeyConversationId;

@interface AVIMConversationQuery : NSObject

/*!
 限制结果数量
 */
@property (nonatomic) NSInteger limit;

/*!
 返回此位置开始的结果
 */
@property (nonatomic) NSInteger skip;

/*!
 设置缓存策略，默认是 kAVCachePolicyCacheElseNetwork
 */
@property (nonatomic) AVCachePolicy cachePolicy;

/*!
 设置缓存的过期时间，默认是 1 小时（1 * 60 * 60）
 */
@property (nonatomic) NSTimeInterval cacheMaxAge;

/*!
 添加等于条件
 @param key 添加条件的 key
 @param object 需要等于的 object
 */
- (void)whereKey:(NSString *)key equalTo:(id)object;

/*!
 添加小于条件
 @param key 添加条件的 key
 @param object 需要小于的 object
 */
- (void)whereKey:(NSString *)key lessThan:(id)object;

/*!
 添加小于或等于条件
 @param key 添加条件的 key
 @param object 需要小于或等于的 object
 */
- (void)whereKey:(NSString *)key lessThanOrEqualTo:(id)object;

/*!
 添加大于条件
 @param key 添加条件的 key
 @param object 需要大于的 object
 */
- (void)whereKey:(NSString *)key greaterThan:(id)object;

/*!
 添加大于或等于条件
 @param key 添加条件的 key
 @param object 需要大于或等于的 object
 */
- (void)whereKey:(NSString *)key greaterThanOrEqualTo:(id)object;

/*!
 添加不等于条件
 @param key 添加条件的 key
 @param object 需要不等于的 object
 */
- (void)whereKey:(NSString *)key notEqualTo:(id)object;

/*!
 添加被包含条件
 @param key 添加条件的 key
 @param array key 对应的值被 array 包含
 */
- (void)whereKey:(NSString *)key containedIn:(NSArray *)array;

/*!
 添加不被包含条件
 @param key 添加条件的 key
 @param array key 对应的值不被 array 包含
 */
- (void)whereKey:(NSString *)key notContainedIn:(NSArray *)array;

/*!
 添加包含条件
 @param key 添加条件的 key
 @param array key 对应的值包含 array 里所有对象
 */
- (void)whereKey:(NSString *)key containsAllObjectsInArray:(NSArray *)array;

/*!
 添加位置条件，结果将按与参考点位置的距离由近到远排序
 @param key 添加条件的 key
 @param geopoint 参考点位置
 */
- (void)whereKey:(NSString *)key nearGeoPoint:(AVGeoPoint *)geopoint;

/*!
 添加位置条件，结果将按与参考点位置的距离由近到远排序
 @param key 添加条件的 key
 @param geopoint 参考点位置
 @param maxDistance 最大距离，单位英里
 */
- (void)whereKey:(NSString *)key nearGeoPoint:(AVGeoPoint *)geopoint withinMiles:(double)maxDistance;

/*!
 添加位置条件，结果将按与参考点位置的距离由近到远排序
 @param key 添加条件的 key
 @param geopoint 参考点位置
 @param maxDistance 最大距离，单位千米
 */
- (void)whereKey:(NSString *)key nearGeoPoint:(AVGeoPoint *)geopoint withinKilometers:(double)maxDistance;

/*!
 添加位置条件，结果将按与参考点位置的距离由近到远排序
 @param key 添加条件的 key
 @param geopoint 参考点位置
 @param maxDistance 最大距离，单位弧度
 */
- (void)whereKey:(NSString *)key nearGeoPoint:(AVGeoPoint *)geopoint withinRadians:(double)maxDistance;

/*!
 添加位置条件，获取位置在 southwest 和 northeast 构成的方形区域的所有记录
 @param key 添加条件的 key
 @param southwest 区域的左下角位置
 @param northeast 区域的右上角位置
 */
- (void)whereKey:(NSString *)key withinGeoBoxFromSouthwest:(AVGeoPoint *)southwest toNortheast:(AVGeoPoint *)northeast;

/*!
 添加正则条件，此条件可能影响性能
 @param key 添加条件的 key
 @param regex 需要匹配的正则
 */
- (void)whereKey:(NSString *)key matchesRegex:(NSString *)regex;

/*!
 添加正则条件，此条件可能影响性能
 @param key 添加条件的 key
 @param regex 需要匹配的正则
 @param modifiers 支持 PCRE 修饰：<br><code>i</code> - 忽略大小写<br><code>m</code> - 跨行匹配
 */
- (void)whereKey:(NSString *)key matchesRegex:(NSString *)regex modifiers:(NSString *)modifiers;

/*!
 添加字符串包含条件
 @param key 添加条件的 key
 @param substring 需要包含的字符串
 */
- (void)whereKey:(NSString *)key containsString:(NSString *)substring;

/*!
 添加字符串前缀匹配条件
 @param key 添加条件的 key
 @param prefix 需要匹配的前缀
 */
- (void)whereKey:(NSString *)key hasPrefix:(NSString *)prefix;

/*!
 添加字符串后缀匹配条件
 @param key 添加条件的 key
 @param suffix 需要匹配的后缀
 */
- (void)whereKey:(NSString *)key hasSuffix:(NSString *)suffix;

/*!
 添加数组元素数量匹配条件
 @param key 添加条件的 key
 @param count 需要匹配的数组元素数量
 */
- (void)whereKey:(NSString *)key sizeEqualTo:(NSUInteger)count;


/*!
 升序排序
 @param key 升序的 key
 */
- (void)orderByAscending:(NSString *)key;

/*!
 添加升序排序
 @param key 升序的 key
 */
- (void)addAscendingOrder:(NSString *)key;

/*!
 降序排序
 @param key 降序的 key
 */
- (void)orderByDescending:(NSString *)key;

/*!
 添加降序排序
 @param key 降序的 key
 */
- (void)addDescendingOrder:(NSString *)key;

/*!
 使用 sortDescriptor 排序
 @param sortDescriptor NSSortDescriptor 对象
 */
- (void)orderBySortDescriptor:(NSSortDescriptor *)sortDescriptor;

/*!
 使用 sortDescriptors 排序
 @param sortDescriptors NSSortDescriptor 对象数组
 */
- (void)orderBySortDescriptors:(NSArray *)sortDescriptors;

/*!
 通过 conversationId 查询服务器，获取一个 AVIMConversation 对象
 @param conversationId 查询使用的对话 id
 @param callback 查询结果回调
 */
- (void)getConversationById:(NSString *)conversationId
                   callback:(AVIMConversationResultBlock)callback;

/*!
 查询服务器获取一个 AVIMConversation 对象数组
 如果未设置 limit，或 limit 非法，默认返回 10 个结果
 @param callback 查询结果回调
 */
- (void)findConversationsWithCallback:(AVIMArrayResultBlock)callback;

@end
