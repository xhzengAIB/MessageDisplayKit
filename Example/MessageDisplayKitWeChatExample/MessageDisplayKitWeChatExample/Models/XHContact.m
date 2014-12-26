//
//  XHContact.m
//  MessageDisplayExample
//
//  Created by 曾 宪华 on 14-5-22.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHContact.h"

@implementation XHContact

- (NSArray *)contactMyAlbums {
    if (!_contactMyAlbums) {
        _contactMyAlbums = [[NSArray alloc] initWithObjects:[UIImage imageNamed:@"bottleButtonFish"], [UIImage imageNamed:@"avator"], [UIImage imageNamed:@"MeIcon"], nil];
    }
    return _contactMyAlbums;
}

- (NSString *)contactIntroduction {
    if (!_contactIntroduction) {
        _contactIntroduction = @"我是一名iOS开发者，热衷于简洁的UI，希望大神不要吐槽，多谢支持我的人";
    }
    return _contactIntroduction;
}

- (NSString *)contactUserId {
    if (!_contactUserId) {
        _contactUserId = @"15915895880";
    }
    return _contactUserId;
}

- (NSString *)contactRegion {
    if (!_contactRegion) {
        _contactRegion = @"广州市天河区";
    }
    return _contactRegion;
}

- (NSString *)description {
    return self.contactName;
}

@end
