//
//  XHStoreManager.h
//  MessageDisplayExample
//
//  Created by qtone-1 on 14-5-18.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XHStoreManager : NSObject

+ (instancetype)shareStoreManager;

- (NSMutableArray *)getDiscoverConfigureArray;

- (NSMutableArray *)getContactConfigureArray;

- (NSMutableArray *)getAlbumConfigureArray;

- (NSMutableArray *)getProfileConfigureArray;

- (NSMutableArray *)getLocationServiceArray;

- (NSMutableArray *)getSettingConfigureArray;

@end
