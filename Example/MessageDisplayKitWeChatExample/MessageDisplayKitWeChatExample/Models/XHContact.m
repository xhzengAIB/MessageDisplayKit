//
//  XHContact.m
//  MessageDisplayExample
//
//  Created by 曾 宪华 on 14-5-22.
//  Copyright (c) 2014年 嗨，我是曾宪华(@xhzengAIB)，曾加入YY Inc.担任高级移动开发工程师，拍立秀App联合创始人，热衷于简洁、而富有理性的事物 QQ:543413507 主页:http://zengxianhua.com All rights reserved.
//

#import "XHContact.h"

@implementation XHContact

- (NSArray *)contactMyAlbums {
    if (!_contactMyAlbums) {
        _contactMyAlbums = [[NSArray alloc] initWithObjects:[UIImage imageNamed:@"bottleButtonFish"], [UIImage imageNamed:@"avatar"], [UIImage imageNamed:@"MeIcon"], nil];
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
