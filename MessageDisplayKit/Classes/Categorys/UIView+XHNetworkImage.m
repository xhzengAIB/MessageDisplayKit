//
//  UIView+XHNetworkImage.m
//  MessageDisplayExample
//
//  Created by qtone-1 on 14-5-9.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "UIView+XHNetworkImage.h"
#import "XHMessageAvatorFactory.h"
#import "XHMacro.h"

@implementation UIView (XHNetworkImage)

- (NSOperationQueue *)networkQueue {
    static NSOperationQueue *currentQueue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        currentQueue = [[NSOperationQueue alloc] init];
        currentQueue.maxConcurrentOperationCount = 1;
    });
    return currentQueue;
}

- (void)setImageUrl:(NSString *)imageUrl {
    WEAKSELF
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:imageUrl]];
    [NSURLConnection sendAsynchronousRequest:request queue:[self networkQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (!connectionError) {
            UIImage *image = [UIImage imageWithData:data];
            image = [XHMessageAvatorFactory avatarImageNamed:image messageAvatorType:XHMessageAvatorSquare];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([weakSelf isKindOfClass:[UIButton class]]) {
                        UIButton *currentButton = (UIButton *)weakSelf;
                        [currentButton setImage:image forState:UIControlStateNormal];
                    } else if ([weakSelf isKindOfClass:[UIImageView class]]) {
                        UIImageView *currentImageView = (UIImageView *)weakSelf;
                        currentImageView.image = image;
                    }
                });
            }
        }
    }];
}

@end
