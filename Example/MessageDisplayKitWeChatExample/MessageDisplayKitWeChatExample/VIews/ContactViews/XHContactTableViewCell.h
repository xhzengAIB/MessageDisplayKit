//
//  XHContactTableViewCell.h
//  MessageDisplayExample
//
//  Created by dw_iOS on 14-5-22.
//  Copyright (c) 2014年 嗨，我是曾宪华(@xhzengAIB)，曾加入YY Inc.担任高级移动开发工程师，拍立秀App联合创始人，热衷于简洁、而富有理性的事物 QQ:543413507 主页:http://zengxianhua.com All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XHContact.h"

typedef NS_ENUM(NSInteger, XHContactType) {
    XHContactTypeNormal = 0,
    XHContactTypeFilter,
};

@interface XHContactTableViewCell : UITableViewCell

@property (nonatomic, strong) XHContact *currentContact;

- (void)configureContact:(XHContact *)contact inContactType:(XHContactType)contactType searchBarText:(NSString *)searchBarText;

@end
