//
//  MDKMessage.h
//  MessageDisplayKitCoreDataExample
//
//  Created by 曾 宪华 on 14-5-30.
//  Copyright (c) 2014年 曾宪华 QQ群: (142557668) QQ:543413507  Gmail:xhzengAIB@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MDKMessage : NSManagedObject

@property (nonatomic, retain) NSString * sender;
@property (nonatomic, retain) NSData * photo;
@property (nonatomic, retain) NSDate * timestamp;
@property (nonatomic, retain) NSString * text;

@end
