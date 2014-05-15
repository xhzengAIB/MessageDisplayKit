//
//  SELine.m
//  SECoreTextView
//
//  Created by kishikawa katsumi on 2013/04/20.
//  Copyright (c) 2013 kishikawa katsumi. All rights reserved.
//

#import "SELineLayout.h"
#import "SELinkText.h"
#import "SETextGeometry.h"

@implementation SELineLayout

- (id)initWithLine:(CTLineRef)line index:(NSInteger)index rect:(CGRect)rect metrics:(SELineMetrics)metrics
{
    self = [super init];
    if (self) {
        _line = CFRetain(line);
        _index = index;
        _rect = rect;
        _metrics = metrics;
        
        _links = [[NSArray alloc] init];
    }
    return self;
}

-(void)dealloc
{
    CFRelease(_line);
}

- (NSRange)stringRange
{
    CFRange stringRange = CTLineGetStringRange(self.line);
    return NSMakeRange(stringRange.location, stringRange.length);
}

- (BOOL)containsPoint:(CGPoint)point
{
    return CGRectContainsPoint(self.rect, point);
}

- (CFIndex)stringIndexForPosition:(CGPoint)point
{
    point.x -= self.rect.origin.x;
    CFIndex index = CTLineGetStringIndexForPosition(self.line, point);
    return index;
}

- (CGRect)rectOfStringWithRange:(NSRange)range
{
    CGRect rect = CGRectZero;
    NSRange intersectionRange = NSIntersectionRange(self.stringRange, range);
    
    if (intersectionRange.length > 0) {
        CTLineRef line = self.line;
        CGFloat startOffset = CTLineGetOffsetForStringIndex(line, intersectionRange.location, NULL);
        CGFloat endOffset = CTLineGetOffsetForStringIndex(line, NSMaxRange(intersectionRange), NULL);
        
        rect = self.rect;
        rect.origin.x += startOffset;
        rect.size.width -= (rect.size.width - endOffset);
        rect.size.width = rect.size.width - startOffset;
    }
    
    return rect;
}

- (void)addLink:(SELinkText *)link
{
    _links = [self.links arrayByAddingObject:link];
}

- (SELinkText *)linkAtPoint:(CGPoint)point
{
    for (SELinkText *link in self.links) {
        for (SETextGeometry *geometry in link.geometries) {
            if (CGRectContainsPoint(geometry.rect, point)) {
                return link;
            }
        }
    }
    
    return nil;
}

- (BOOL)containsLink
{
    return self.links.count > 0;
}

- (NSUInteger)numberOfLinks
{
    return self.links.count;
}

@end
