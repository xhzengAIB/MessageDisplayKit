//
//  XHConfigurationHelper.h
//  MessageDisplayKit
//
//  Created by Jack_iMac on 15/6/30.
//  Copyright (c) 2015年 iOS软件开发工程师 曾宪华 热衷于简洁的UI QQ:543413507 http://www.pailixiu.com/blog   http://www.pailixiu.com/Jack/personal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XHConfigurationHelper : NSObject

@property (nonatomic, strong, readonly) NSArray *popMenuTitles;

+ (instancetype)appearance;

- (void)setupPopMenuTitles:(NSArray *)popMenuTitles;

@end
