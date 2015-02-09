//
//  XHOperationNetworkKit.m
//  MessageDisplayExample
//
//  Created by 曾 宪华 on 14-6-10.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHOperationNetworkKit.h"

@interface XHOperationNetworkKit () <NSURLConnectionDelegate, NSURLConnectionDataDelegate> {
    __block unsigned long long _total;
    __block unsigned long long _currentSize;
    
    NSURLConnection *_connection;
    NSMutableData *_responseData;
    NSURLResponse *_response;
    XHJSONSuccessHandler _jsonSuccessHandler;
    XHHTTPSuccessHandler _successHandler;
    XHHTTPFailureHandler _failureHandler;
    XHHTTPProgressHandler _progressHandler;
}

+ (NSOperationQueue *)queue;

@property (nonatomic, copy) NSURLRequest *request;
@property (nonatomic, readwrite, getter = isFinished) BOOL finished;

@end

@implementation XHOperationNetworkKit
@synthesize finished = _finished;

+ (NSOperationQueue *)queue {
    static NSOperationQueue *queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = [[NSOperationQueue alloc] init];
    });
    return queue;
}

- (void)startRequest {
    [[XHOperationNetworkKit queue] addOperation:self];
}

#pragma mark - NSOperation Overrides

- (void)main {
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    
    _connection = [[NSURLConnection alloc] initWithRequest:[self request] delegate:self startImmediately:NO];
    [_connection scheduleInRunLoop:runLoop forMode:NSDefaultRunLoopMode];
    [_connection start];
    
    while (![self isFinished] && [runLoop runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]) {
        
    };
}

#pragma mark - Instance Methods

- (void)setProgressHandler:(XHHTTPProgressHandler)progressHandler {
    _progressHandler = [progressHandler copy];
}

- (void)setJSONSuccessHandler:(XHJSONSuccessHandler)jsonSuccessHandler {
    _jsonSuccessHandler = [jsonSuccessHandler copy];
}

- (void)setSuccessHandler:(XHHTTPSuccessHandler)successHandler {
    _successHandler = [successHandler copy];
}

- (void)setFailureHandler:(XHHTTPFailureHandler)failureHandler {
    _failureHandler = [failureHandler copy];
}

- (id)initWithRequest:(NSURLRequest *)request
   jsonSuccessHandler:(XHJSONSuccessHandler)jsonSuccessHandler
       failureHandler:(XHHTTPFailureHandler)failureHandle {
    self = [super init];
    if (self) {
        [self setRequest:request];
        [self setJSONSuccessHandler:jsonSuccessHandler];
        [self setFailureHandler:failureHandle];
    }
    return self;
}

- (id)initWithRequest:(NSURLRequest *)request successHandler:(XHHTTPSuccessHandler)successHandler failureHandler:(XHHTTPFailureHandler)failureHandler {
    self = [super init];
    if (self) {
        [self setRequest:request];
        [self setSuccessHandler:successHandler];
        [self setFailureHandler:failureHandler];
    }
    return self;
}

- (id)initWithRequest:(NSURLRequest *)request {
    return [self initWithRequest:request successHandler:nil failureHandler:nil];
}

#pragma mark - NSURLConnectionDelegate Methods

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    if (_failureHandler)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            _failureHandler(_responseData, _response, error);
        });
    }
    [self setFinished:YES];
}

#pragma mark - NSURLConnectionDataDelegate Methods

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSHTTPURLResponse *response = (NSHTTPURLResponse *)_response;
    BOOL success = [[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(200, 100)] containsIndex:[response statusCode]];
    
    if ((success && _successHandler)) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _successHandler(_responseData, _response);
        });
    } else if ((success && _jsonSuccessHandler)) {
        NSError *parseError;
        __block NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:_responseData options:0 error:&parseError];
        dispatch_async(dispatch_get_main_queue(), ^{
            _jsonSuccessHandler(JSON);
        });
    } else if (!success && _failureHandler) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _failureHandler(_responseData, _response, nil);
        });
    }
    
    [self setFinished:YES];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    if (_progressHandler) {
        NSUInteger realLength = data.length;
        _currentSize += (unsigned long long)realLength;
        CGFloat progress = (float)_currentSize / (float)_total;
        if (progress < 0) {
            progress = 0;
        } else if (progress > 1) {
            progress = 1;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            _progressHandler(progress, _total);
        });
    }
    [_responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    if (_progressHandler) {
        NSHTTPURLResponse *httpURLResponse = (NSHTTPURLResponse *)response;
        if ([httpURLResponse statusCode] == 200) {
            _total = (unsigned long long)[httpURLResponse expectedContentLength];
        }
    }
    
    _responseData = [NSMutableData new];
    _response = response;
}

@end
