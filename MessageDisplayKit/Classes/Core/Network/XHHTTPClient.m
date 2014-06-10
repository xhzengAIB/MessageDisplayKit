//
//  XHHTTPClient.m
//  MessageDisplayExample
//
//  Created by 曾 宪华 on 14-5-30.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
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
