//
//  XHHTTPClient.h
//  MessageDisplayExample
//
//  Created by 曾 宪华 on 14-5-30.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "XHOperationNetworkKit.h"

#define kXHBaseHomeURL @"http://.......set there"

#define XHHTTPClientTimeoutInterval 30

@interface XHHTTPClient : NSObject

+ (void)GETPath:(NSString *)urlString parameters:(NSDictionary *)parameters jsonSuccessHandler:(XHJSONSuccessHandler)jsonSuccessHandler
 failureHandler:(XHHTTPFailureHandler)failureHandler;

+ (void)POSTPath:(NSString *)urlString parameters:(NSDictionary *)parameters jsonSuccessHandler:(XHJSONSuccessHandler)jsonSuccessHandler
  failureHandler:(XHHTTPFailureHandler)failureHandler;

+ (void)DELETEPath:(NSString *)urlString parameters:(NSDictionary *)parameters jsonSuccessHandler:(XHJSONSuccessHandler)jsonSuccessHandler
    failureHandler:(XHHTTPFailureHandler)failureHandler;

@end
