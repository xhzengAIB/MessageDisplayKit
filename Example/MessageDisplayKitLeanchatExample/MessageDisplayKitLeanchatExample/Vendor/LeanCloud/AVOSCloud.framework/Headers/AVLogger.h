//
//  AVLogger.h
//  AVOS
//
//  Created by Qihe Bian on 9/9/14.
//
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    AVLoggerLevelNone = 0,
    AVLoggerLevelInfo = 1,
    AVLoggerLevelDebug = 1 << 1,
    AVLoggerLevelError = 1 << 2,
    AVLoggerLevelAll = AVLoggerLevelInfo | AVLoggerLevelDebug | AVLoggerLevelError,
} AVLoggerLevel;

extern NSString *const AVLoggerDomainCURL;
extern NSString *const AVLoggerDomainIM;
@interface AVLogger : NSObject
+ (void)setLoggerLevelMask:(NSUInteger)levelMask;
+ (void)addLoggerDomain:(NSString *)domain;
+ (void)removeLoggerDomain:(NSString *)domain;
+ (void)logFunc:(const char *)func domain:(NSString *)domain level:(AVLoggerLevel)level message:(NSString *)fmt, ... NS_FORMAT_FUNCTION(4, 5);
@end

#define _AVLoggerInfo(_domain, ...) [AVLogger logFunc:__func__ domain:_domain level:AVLoggerLevelInfo message:__VA_ARGS__]
#define _AVLoggerDebug(_domain, ...) [AVLogger logFunc:__func__ domain:_domain level:AVLoggerLevelDebug message:__VA_ARGS__]
#define _AVLoggerError(_domain, ...) [AVLogger logFunc:__func__ domain:_domain level:AVLoggerLevelError message:__VA_ARGS__]

#define AVLoggerInfo(domain, ...) _AVLoggerInfo(domain, __VA_ARGS__)
#define AVLoggerDebug(domain, ...) _AVLoggerDebug(domain, __VA_ARGS__)
#define AVLoggerError(domain, ...) _AVLoggerError(domain, __VA_ARGS__)