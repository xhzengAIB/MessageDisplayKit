//
//  SETextGeometry.h
//  SECoreTextView
//
//  Created by kishikawa katsumi on 2013/04/20.
//  Copyright (c) 2013 kishikawa katsumi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface SETextGeometry : NSObject

@property (nonatomic, readonly) CGRect rect;
@property (nonatomic, readonly) NSInteger lineNumber;

- (id)initWithRect:(CGRect)rect lineNumber:(NSInteger)lineNumber;

@end
