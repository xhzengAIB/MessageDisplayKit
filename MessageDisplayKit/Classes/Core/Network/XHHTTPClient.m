//
//  XHHTTPClient.m
//  MessageDisplayExample
//
//  Created by 曾 宪华 on 14-5-30.
//  Copyright (c) 2014年 嗨，我是曾宪华(@xhzengAIB)，曾加入YY Inc.担任高级移动开发工程师，拍立秀App联合创始人，热衷于简洁、而富有理性的事物 QQ:543413507 主页:http://zengxianhua.com All rights reserved.
//

#import "XHHTTPClient.h"

#import "XHHTTPClient.h"

@interface NSString (URLEncoding)

- (NSString *)urlEncodedUTF8String;

@end

@interface NSURLRequest (DictionaryPost)

+ (NSURLRequest *)postRequestWithURL:(NSURL *)url
                          parameters:(NSDictionary *)parameters;

@end

@implementation NSString (URLEncoding)

- (NSString *)urlEncodedUTF8String {
    return (id)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(0, (CFStringRef)self, 0,
                                                                         (CFStringRef)@";/?:@&=$+{}<>,", kCFStringEncodingUTF8));
}

@end

@implementation XHHTTPClient

+ (void)GETPath:(NSString *)urlString parameters:(NSDictionary *)parameters jsonSuccessHandler:(XHJSONSuccessHandler)jsonSuccessHandler
 failureHandler:(XHHTTPFailureHandler)failureHandler {
    XHOperationNetworkKit *operation = [[XHOperationNetworkKit alloc] initWithRequest:[self requestWithURLString:[NSString stringWithFormat:@"%@%@", kXHBaseHomeURL, urlString] HTTPMethod:@"GET" parameters:parameters] jsonSuccessHandler:jsonSuccessHandler failureHandler:failureHandler];
    [operation startRequest];
}

+ (void)POSTPath:(NSString *)urlString parameters:(NSDictionary *)parameters jsonSuccessHandler:(XHJSONSuccessHandler)jsonSuccessHandler
  failureHandler:(XHHTTPFailureHandler)failureHandler {
    XHOperationNetworkKit *operation = [[XHOperationNetworkKit alloc] initWithRequest:[self requestWithURLString:[NSString stringWithFormat:@"%@%@", kXHBaseHomeURL, urlString] HTTPMethod:@"POST" parameters:parameters] jsonSuccessHandler:jsonSuccessHandler failureHandler:failureHandler];
    [operation startRequest];
}

+ (void)DELETEPath:(NSString *)urlString parameters:(NSDictionary *)parameters jsonSuccessHandler:(XHJSONSuccessHandler)jsonSuccessHandler
    failureHandler:(XHHTTPFailureHandler)failureHandler {
    XHOperationNetworkKit *operation = [[XHOperationNetworkKit alloc] initWithRequest:[self requestWithURLString:urlString HTTPMethod:@"POST" parameters:parameters] jsonSuccessHandler:jsonSuccessHandler failureHandler:failureHandler];
    [operation startRequest];
}

+ (NSMutableURLRequest *)requestWithURLString:(NSString *)urlString HTTPMethod:(NSString *)method parameters:(NSDictionary *)parameters {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:method];
    [request setTimeoutInterval:XHHTTPClientTimeoutInterval];
    
    NSMutableString *body = [NSMutableString string];
    for (NSString *key in parameters) {
        NSString *val = [parameters objectForKey:key];
        if ([body length])
            [body appendString:@"&"];
        [body appendFormat:@"%@=%@", [[key description] urlEncodedUTF8String],
         [[val description] urlEncodedUTF8String]];
    }
    [request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

@end
