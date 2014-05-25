//
//  XHContact.h
//  MessageDisplayExample
//
//  Created by 曾 宪华 on 14-5-22.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kXHContactAvatorSize 80
#define kXHContactNameLabelHeight 30

#define kXHContactButtonHeight 44
#define kXHContactButtonSpacing 20

@interface XHContact : NSObject

@property (nonatomic, copy) NSString *contactName;

@property (nonatomic, copy) NSString *contactUserId;

@property (nonatomic, copy) NSString *contactRegion;

@property (nonatomic, copy) NSString *contactIntroduction;

@property (nonatomic, copy) NSArray *contactMyAlbums;

@end
