//
//  XHContactTableViewCell.h
//  MessageDisplayExample
//
//  Created by dw_iOS on 14-5-22.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
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
