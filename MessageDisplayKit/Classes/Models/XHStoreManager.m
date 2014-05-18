//
//  XHStoreManager.m
//  MessageDisplayExample
//
//  Created by qtone-1 on 14-5-18.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHStoreManager.h"

@implementation XHStoreManager

+ (instancetype)shareStoreManager {
    static XHStoreManager *storeManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        storeManager = [[XHStoreManager alloc] init];
    });
    return storeManager;
}

- (NSMutableArray *)getDiscoverConfigureArray {
    NSMutableArray *discoverConfigureArray = [[NSMutableArray alloc] initWithCapacity:3];
    
    NSDictionary *AlbumDictionary = @{@"title": @"朋友圈", @"image" : @"ff_IconShowAlbum"};
    [discoverConfigureArray addObject:@[AlbumDictionary]];
    
    NSDictionary *QRCodeDictionary = @{@"title": @"扫一扫", @"image" : @"ff_IconQRCode"};
    NSDictionary *ShakeDictionary = @{@"title": @"摇一摇", @"image" : @"ff_IconShake"};
    [discoverConfigureArray addObject:@[QRCodeDictionary, ShakeDictionary]];
    
    NSDictionary *LocationServiceDictionary = @{@"title": @"附近的人", @"image" : @"ff_IconLocationService"};
    NSDictionary *BottleDictionary = @{@"title": @"漂流瓶", @"image" : @"ff_IconBottle"};
    [discoverConfigureArray addObject:@[LocationServiceDictionary, BottleDictionary]];
    
    NSDictionary *MoreGameDictionary = @{@"title": @"扫一扫", @"image" : @"MoreGame"};
    [discoverConfigureArray addObject:@[MoreGameDictionary]];
    return discoverConfigureArray;
}

@end
