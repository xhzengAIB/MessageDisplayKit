//
//  MDKMessage.h
//  MessageDisplayKitCoreDataExample
//
//  Created by 曾 宪华 on 14-5-30.
//  Copyright (c) 2014年 嗨，我是曾宪华(@xhzengAIB)，曾加入YY Inc.担任高级移动开发工程师，拍立秀App联合创始人，热衷于简洁、而富有理性的事物 QQ:543413507 主页:http://zengxianhua.com All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MDKMessage : NSManagedObject

@property (nonatomic, retain) NSString * sender;
@property (nonatomic, retain) NSData * photo;
@property (nonatomic, retain) NSDate * timestamp;
@property (nonatomic, retain) NSString * text;

@end
