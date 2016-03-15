//
//  XHAnnotation.m
//  MessageDisplayExample
//
//  Created by HUAJIE-1 on 14-5-9.
//  Copyright (c) 2014年 嗨，我是曾宪华(@xhzengAIB)，曾加入YY Inc.担任高级移动开发工程师，拍立秀App联合创始人，热衷于简洁、而富有理性的事物 QQ:543413507 主页:http://zengxianhua.com All rights reserved.
//

#import "XHAnnotation.h"

@implementation XHAnnotation

- (id)initWithCLRegion:(CLRegion *)newRegion title:(NSString *)title subtitle:(NSString *)subtitle {
	self = [super init];
	if (self) {
		self.region = newRegion;
        _coordinate = _region.center;
		self.radius = _region.radius;
        self.title = title;
        self.subtitle = subtitle;
	}
    
	return self;
}


/*
 This method provides a custom setter so that the model is notified when the subtitle value has changed.
 */
- (void)setRadius:(CLLocationDistance)newRadius {
	[self willChangeValueForKey:@"subtitle"];
	
	_radius = newRadius;
	
	[self didChangeValueForKey:@"subtitle"];
}

- (void)dealloc {
	_region = nil;
     _title = nil;
    _subtitle = nil;
}

@end
