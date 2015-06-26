//
//  AVLocationManager.h
//  paas
//
//  Created by Summer on 13-3-16.
//  Copyright (c) 2013年 AVOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AVGeoPoint,CLLocation,CLLocationManager;


/**
 *  管理地理位置
 */
@interface AVLocationManager : NSObject

/**
 *  系统的 CLLocationManager
 */
@property (nonatomic, strong, readonly) CLLocationManager *locationManager;

/**
 *  最后一次获取到的地理位置
 */
@property (nonatomic, strong, readonly) CLLocation *lastLocation;

+ (AVLocationManager *)sharedInstance;

/**
 *  请求“使用应用程序期间”开启定位服务
 *  iOS 8.0 新加，之前版本什么都不做
 *  需要在Info.plist里面添加 NSLocationWhenInUseUsageDescription
 */
- (void)requestWhenInUseAuthorization;

/**
 *  请求“始终”开启定位服务，即应用退到后台也可使用定位服务
 *  iOS 8.0 新加，之前版本什么都不做
 *  需要在Info.plist里面添加 NSLocationAlwaysUsageDescription
 */
- (void)requestAlwaysAuthorization;

/**
 *  刷新当前地理位置
 *
 *  @param block 回调结果
 */
- (void)updateWithBlock:(void(^)(AVGeoPoint *geoPoint, NSError *error))block;

@end
