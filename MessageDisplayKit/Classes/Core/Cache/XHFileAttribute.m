//
//  XHFileAttribute.m
//  XHImageViewer
//
//  Created by 曾 宪华 on 14-2-18.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHFileAttribute.h"

@implementation XHFileAttribute

- (id)initWithPath:(NSString *)filePath attributes:(NSDictionary *)attributes {
    self = [super init];
    if(self){
        self.filePath = filePath;
        self.fileAttributes = attributes;
    }
    return self;
}

- (NSDate *)fileModificationDate {
    return [_fileAttributes fileModificationDate];
}

- (NSString *)description {
    return self.filePath;
}

@end
