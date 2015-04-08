//
//  SESelectionGrabber.h
//  SECoreTextView-iOS
//
//  Created by kishikawa katsumi on 2013/04/23.
//  Copyright (c) 2013 kishikawa katsumi. All rights reserved.
//

#import <TargetConditionals.h>

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, SESelectionGrabberDotMetric) {
    SESelectionGrabberDotMetricTop,
    SESelectionGrabberDotMetricBottom
};

@interface SESelectionGrabber : UIView

@property (nonatomic) BOOL dragging;
@property (nonatomic) SESelectionGrabberDotMetric dotMetric;

@end
#endif
