//
//  AVSearchSortBuilder.h
//  paas
//
//  Created by yang chaozhong on 6/13/14.
//  Copyright (c) 2014 AVOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AVGeoPoint;

/*!
 *  应用搜索的排序对象产生器
 */
@interface AVSearchSortBuilder : NSObject

@property (nonatomic, readonly) NSMutableArray *sortFields;

/*!
 *  新建 AVSearchSortBuilder 实例
 *  @return AVSearchSortBuilder 实例
 */
+ (instancetype)newBuilder;

/*!
 *  按照key升序排序
 *  @param key 排序的key
 *  @param mode 数组或者多值字段的排序模式，min表示取最小值，max取最大值，sum取综合，avg取平均值，默认值是avg
 *  @param missing 当搜索匹配的文档没有排序的key的时候，设置本选项决定文档放在开头还是末尾，取值是"last"或者"first"，默认是"last"表示在末尾
 */
- (void)orderByAscending:(NSString *)key withMode:(NSString *)mode andMissing:(NSString *)missing;

/*!
 *  @see orderByAscending:withMode:andMissing
 *  @param key
 *  @param mode
 */
- (void)orderByAscending:(NSString *)key withMode:(NSString *)mode;

/*!
 *  @see orderByAscending:withMode:andMissing
 *  @param key
 */
- (void)orderByAscending:(NSString *)key;

/*!
 * 按照key降序排序
 *
 *  @param key 排序的key
 *  @param mode 数组或者多值字段的排序模式，min表示取最小值，max取最大值，sum取综合，avg取平均值，默认值是avg。
 *  @param missing 当搜索匹配的文档没有排序的key的时候，设置本选项决定文档放在开头还是末尾，取值是"last"或者"first"，默认是"last"表示在末尾。
 */
- (void)orderByDescending:(NSString *)key withMode:(NSString *)mode andMissing:(NSString *)missing;

/*!
 *  @see orderByDescending:withMode:andMissing
 *  @param key
 *  @param mode
 */
- (void)orderByDescending:(NSString *)key withMode:(NSString *)mode;

/*!
 *  @see orderByDescending:withMode:andMissing
 *  @param key
 */
- (void)orderByDescending:(NSString *)key;

/*!
 * 按照地理位置信息远近排序,key对应的字段类型必须是GeoPoint。
 *
 *  @param key 排序的字段key
 *  @param point GeoPoint经纬度对象
 *  @param order 排序顺序，升序"asc"，降序"desc"，默认升序，也就是从近到远。
 *  @param mode 数组或者多值字段的排序模式，min表示取最小值，max取最大值，avg取平均值，默认值是avg。
 *  @param unit 距离单位，"m"表示米，"cm"表示厘米，"mm"表示毫米，"km"表示公里，"mi"表示英里，"in"表示英寸，"yd"表示英亩，默认"km"。
 */
- (void)whereNear:(NSString *)key point:(AVGeoPoint *)point inOrder:(NSString *)order withMode:(NSString *)mode andUnit:(NSString *)unit;

/*!
 *  @see whereNear:point:inOrder:withMode:andUnit
 *  @param key
 *  @param point
 *  @param order
 */
- (void)whereNear:(NSString *)key point:(AVGeoPoint *)point inOrder:(NSString *)order;

/*!
 *  @see whereNear:point:inOrder:withMode:andUnit
 *  @param key
 *  @param point
 */
- (void)whereNear:(NSString *)key point:(AVGeoPoint *)point;

@end
