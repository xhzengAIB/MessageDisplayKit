//
//  SELine.h
//  SECoreTextView
//
//  Created by kishikawa katsumi on 2013/04/20.
//  Copyright (c) 2013 kishikawa katsumi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>

@class SELinkText;

typedef struct {
    CGFloat ascent;
    CGFloat descent;
    CGFloat width;
    CGFloat leading;
    double trailingWhitespaceWidth;
} SELineMetrics;

@interface SELineLayout : NSObject

@property (nonatomic, readonly) CTLineRef line;
@property (nonatomic, readonly) NSInteger index;
@property (nonatomic, readonly) CGRect rect;
@property (nonatomic) CGRect drawingRect;
@property (nonatomic) CGFloat truncationTokenWidth;
@property (nonatomic, readonly) SELineMetrics metrics;

@property (nonatomic, readonly) NSRange stringRange;

@property (nonatomic, readonly) NSArray *links;
@property (nonatomic, readonly) BOOL containsLink;
@property (nonatomic, readonly) NSUInteger numberOfLinks;

@property (nonatomic, getter = isTruncated) BOOL truncated;

- (id)initWithLine:(CTLineRef)line index:(NSInteger)index rect:(CGRect)rect metrics:(SELineMetrics)metrics;

- (NSRange)stringRange;

- (BOOL)containsPoint:(CGPoint)point;
- (CFIndex)stringIndexForPosition:(CGPoint)point;

- (CGRect)rectOfStringWithRange:(NSRange)range;

- (void)addLink:(SELinkText *)link;
- (SELinkText *)linkAtPoint:(CGPoint)point;

@end
