//
//  XHOperationNetworkKit.h
//  MessageDisplayExample
//
//  Created by 曾 宪华 on 14-6-10.
//  Copyright (c) 2014年 嗨，我是曾宪华(@xhzengAIB)，曾加入YY Inc.担任高级移动开发工程师，拍立秀App联合创始人，热衷于简洁、而富有理性的事物 QQ:543413507 主页:http://zengxianhua.com All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^XHHTTPProgressHandler)(CGFloat progress, unsigned long long total);
typedef void (^XHJSONSuccessHandler)(id json);
typedef void (^XHHTTPSuccessHandler)(NSData *responseData, NSURLResponse *response);
typedef void (^XHHTTPFailureHandler)(NSData *responseData, NSURLResponse *response, NSError *error);

@interface XHOperationNetworkKit : NSOperation

- (id)initWithRequest:(NSURLRequest *)request;
- (id)initWithRequest:(NSURLRequest *)request
   jsonSuccessHandler:(XHJSONSuccessHandler)jsonSuccessHandler
       failureHandler:(XHHTTPFailureHandler)failureHandler;
- (id)initWithRequest:(NSURLRequest *)request
       successHandler:(XHHTTPSuccessHandler)successHandler
       failureHandler:(XHHTTPFailureHandler)failureHandler;


- (void)setSuccessHandler:(XHHTTPSuccessHandler)successHandler;
- (void)setFailureHandler:(XHHTTPFailureHandler)failureHandler;
- (void)setProgressHandler:(XHHTTPProgressHandler)progressHandler;

- (void)startRequest;

@end
