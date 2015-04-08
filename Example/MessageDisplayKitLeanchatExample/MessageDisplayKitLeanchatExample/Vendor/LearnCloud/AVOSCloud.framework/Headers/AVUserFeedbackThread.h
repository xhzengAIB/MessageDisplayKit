//
//  AVUserFeedbackThread.h
//  paas
//
//  Created by yang chaozhong on 4/21/14.
//  Copyright (c) 2014 AVOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AVConstants.h"
#import "AVUserFeedback.h"

@interface AVUserFeedbackThread : NSObject

@property(nonatomic, retain) AVUserFeedback *feedback;
@property(nonatomic, retain) NSString *content;
@property(nonatomic, retain) NSString *type;
@property(nonatomic, retain) NSString *createAt;

+ (instancetype)feedbackThread:(NSString *)content
                         type:(NSString *)type
                 withFeedback:(AVUserFeedback *)feedback;

+ (void)saveFeedbackThread:(AVUserFeedbackThread *)feedbackThread;

+ (void)saveFeedbackThread:(AVUserFeedbackThread *)feedbackThread withBlock:(AVIdResultBlock)block;

+ (void)saveFeedbackThreadInBackground:(AVUserFeedbackThread *)feedbackThread withBlock:(AVIdResultBlock)block;

+ (void)fetchFeedbackThreadsInBackground:(AVUserFeedback *)feedback withBlock:(AVArrayResultBlock)block;

@end
