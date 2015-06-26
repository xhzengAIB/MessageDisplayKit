//
//  AVHelpers.h
//  paas
//
//  Created by Travis on 13-12-17.
//  Copyright (c) 2013年 AVOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (AVServerTimezone)

/* 根据传入字符串生成服务器时区的时间
 * @warning 目前服务器时区为定值: 东八区 即CST时间
 * @param fullTimeString 需要转换成时间的字符串 格式固定, 如`2013-12-17 00:00:00` 即希望得到服务器时区2013年12月17日零时的NSDate.
 * @return 返回服务器时区NSDate时间. 如 fullTimeString为`2013-08-29 13:28:15` 则返回`2013-08-29 05:28:15 +0000`的标准时间
 */
+(NSDate*)serverTimeZoneDateFromString:(NSString*)fullTimeString;

@end


@interface NSData (AVBase64)

/* 根据传入的base64编码字符串生成NSData
 * @param aString 需要转换的base64格式字符串
 * @return 返回生成的data
 */
+ (NSData *)AVdataFromBase64String:(NSString *)aString;

/* 获得当前data的base64编码字符串 */
- (NSString *)AVbase64EncodedString;

@end

@interface NSString (AVMD5)

/* 返回当前字符串的*大写*MD5值
 * @return 返回当前字符串的*大写*MD5值
 */
- (NSString *)AVMD5String;

@end


@interface NSURLRequest (curl)
/* 获得当前请求的curl命令行代码, 方便命令行调试 对比结果
 * @return 当前请求的curl命令行代码
 */
- (NSString *)cURLCommand;
@end
