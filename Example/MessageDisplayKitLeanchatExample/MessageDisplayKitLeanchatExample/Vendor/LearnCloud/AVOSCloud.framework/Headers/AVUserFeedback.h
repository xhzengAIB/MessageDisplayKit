//
//  AVUserFeedback.h
//  paas
//
//  Created by yang chaozhong on 4/21/14.
//  Copyright (c) 2014 AVOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AVConstants.h"
@interface AVUserFeedback : NSObject

@property(nonatomic, retain) NSString *objectId;
@property(nonatomic, retain) NSString *content;
@property(nonatomic, retain) NSString *contact;

+(void)feedbackWithContent:(NSString *)content contact:(NSString *)contact withBlock:(AVIdResultBlock)block;

+(void)updateFeedback:(AVUserFeedback *)feedback withBlock:(AVIdResultBlock)block;

+(void)deleteFeedback:(AVUserFeedback *)feedback withBlock:(AVIdResultBlock)block;

@end
