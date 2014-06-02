//
//  XHStoreManager.m
//  MessageDisplayExample
//
//  Created by qtone-1 on 14-5-18.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHStoreManager.h"

#import "XHContact.h"
#import "XHAlbum.h"

#import "XHCacheManager.h"

#import "NSString+XHDiskSizeTransfrom.h"

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
    
    NSDictionary *MoreGameDictionary = @{@"title": @"游戏", @"image" : @"MoreGame"};
    [discoverConfigureArray addObject:@[MoreGameDictionary]];
    
    return discoverConfigureArray;
}

- (NSMutableArray *)getContactConfigureArray {
    NSMutableArray *contacts = [[NSMutableArray alloc] init];
    
    for (int i = 0; i <= 26; i ++) {
        XHContact *contact = [[XHContact alloc] init];
        
        NSString *contactName;
        switch (i) {
            case 0:
                contactName = @"apple";
                break;
            case 1:
                contactName = @"bpple";
                break;
            case 2:
                contactName = @"cpple";
                break;
            case 3:
                contactName = @"dpple";
                break;
            case 4:
                contactName = @"epple";
                break;
            case 5:
                contactName = @"fpple";
                break;
            case 6:
                contactName = @"gpple";
                break;
            case 7:
                contactName = @"hpple";
                break;
            case 8:
                contactName = @"ipple";
                break;
            case 9:
                contactName = @"jpple";
                break;
            case 10:
                contactName = @"kpple";
                break;
            case 11:
                contactName = @"rpple";
                break;
            case 12:
                contactName = @"mpple";
                break;
            case 13:
                contactName = @"npple";
                break;
            case 14:
                contactName = @"opple";
                break;
            case 15:
                contactName = @"ppple";
                break;
            case 16:
                contactName = @"qpple";
                break;
            case 17:
                contactName = @"rpple";
                break;
            case 18:
                contactName = @"spple";
                break;
            case 19:
                contactName = @"tpple";
                break;
            case 20:
                contactName = @"upple";
                break;
            case 21:
                contactName = @"vpple";
                break;
            case 22:
                contactName = @"wpple";
                break;
            case 23:
                contactName = @"xpple";
                break;
            case 24:
                contactName = @"ypple";
                break;
            case 25:
                contactName = @"zpple";
                break;
            case 26:
                contactName = @"#pple";
                break;
            default:
                break;
        }
        
        contact.contactName = contactName;
        
        [contacts addObject:@[contact, contact]];
    }
    
    return contacts;
}

- (NSMutableArray *)getAlbumConfigureArray {
    NSMutableArray *albumConfigureArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < 60; i ++) {
        XHAlbum *currnetAlbum = [[XHAlbum alloc] init];
        currnetAlbum.userName = @"Jack";
        currnetAlbum.profileAvatorUrlString = @"http://www.pailixiu.com/jack/meIcon@2x.png";
        currnetAlbum.albumShareContent = @"朋友圈分享内容，😗😗😗😗😗这里做图片加载，😗😗😗😗😗还是混排好呢？😜😜😜😜😜如果不混排，感觉CoreText派不上场啊！😄😄😄你说是不是？😗😗😗😗😗如果有混排的需要就更好了！😗😗😗😗😗";
        currnetAlbum.albumSharePhotos = [NSArray arrayWithObjects:@"http://www.pailixiu.com/jack/JieIcon@2x.png", @"http://www.pailixiu.com/jack/JieIcon@2x.png", @"http://www.pailixiu.com/jack/JieIcon@2x.png", @"http://www.pailixiu.com/jack/JieIcon@2x.png", @"http://www.pailixiu.com/jack/JieIcon@2x.png", @"http://www.pailixiu.com/jack/JieIcon@2x.png", @"http://www.pailixiu.com/jack/JieIcon@2x.png", @"http://www.pailixiu.com/jack/JieIcon@2x.png", @"http://www.pailixiu.com/jack/JieIcon@2x.png", nil];
        currnetAlbum.timestamp = [NSDate date];
        [albumConfigureArray addObject:currnetAlbum];
    }
    
    return albumConfigureArray;
}

- (NSMutableArray *)getProfileConfigureArray {
    NSMutableArray *profiles = [[NSMutableArray alloc] initWithCapacity:1];
    
    NSString *titleKey = @"title";
    NSString *imageKey = @"image";
    
    NSMutableDictionary *userInfoDictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Jack", titleKey, @"15915895880", @"WeChatNumber", @"MeIcon", imageKey, nil];
    [profiles addObject:@[userInfoDictionary]];
    
    NSMutableArray *rows = [[NSMutableArray alloc] initWithCapacity:1];
    for (int i = 0; i < 3; i ++) {
        NSString *title;
        NSString *imageName;
        switch (i) {
            case 0:
                title = @"我的相册";
                imageName = @"MoreMyAlbum";
                break;
            case 1:
                title = @"我的收藏";
                imageName = @"MoreMyFavorites";
                break;
            case 2:
                title = @"我的银行卡";
                imageName = @"MoreMyBankCard";
                break;
            default:
                break;
        }
        
        NSMutableDictionary *sectionDictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:title, titleKey, imageName, imageKey, nil];
        [rows addObject:sectionDictionary];
    }
    [profiles addObject:rows];
    
    [profiles addObject:@[[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"表情", titleKey, @"MoreExpressionShops", imageKey, nil]]];
    
    [profiles addObject:@[[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"设置", titleKey, @"MoreSetting", imageKey, nil]]];
    
    return profiles;
}

- (NSMutableArray *)getLocationServiceArray {
    NSMutableArray *locationServices = [[NSMutableArray alloc] init];
    
    for (int i = 0 ; i < 20; i ++) {
        if (i % 2) {
            [locationServices addObject:@"杨仁捷"];
        } else {
            [locationServices addObject:@"吴盛潮"];
        }
    }
    
    return locationServices;
}

- (NSMutableArray *)getSettingConfigureArray {
    NSMutableArray *settings = [[NSMutableArray alloc] initWithCapacity:1];
    
    NSString *titleKey = @"title";
    
    [settings addObject:@[@{titleKey: @"帐号与安全"}]];
    
    [settings addObject:@[@{titleKey: @"新消息通知"}, @{titleKey: @"隐私"}, @{titleKey: @"通用"}]];
    
    [settings addObject:@[@{titleKey: @"关于微信"}, @{titleKey: [NSString stringWithFormat:@"离线缓存大小 %@", [NSString transformedValue:[XHCacheManager diskSize]]]}]];
    
    [settings addObject:@[@{titleKey: @"退出登录"}]];
    
    return settings;
}

@end
