//
//  XHLocationHelper.h
//  MessageDisplayExample
//
//  Created by HUAJIE-1 on 14-5-8.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef void(^DidGetGeolocationsCompledBlock)(NSArray *placemarks);

@interface XHLocationHelper : NSObject

- (void)getCurrentGeolocationsCompled:(DidGetGeolocationsCompledBlock)compled;

@end
