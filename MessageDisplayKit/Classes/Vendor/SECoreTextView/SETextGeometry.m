//
//  SETextGeometry.m
//  SECoreTextView
//
//  Created by kishikawa katsumi on 2013/04/20.
//  Copyright (c) 2013 kishikawa katsumi. All rights reserved.
//

#import "SETextGeometry.h"
#import "SECompatibility.h"

@implementation SETextGeometry

- (id)init
{
    return [self initWithRect:CGRectZero lineNumber:NSNotFound];
}

- (id)initWithRect:(CGRect)rect lineNumber:(NSInteger)lineNumber
{
    self = [super init];
    if (self) {
        _rect = rect;
        _lineNumber = lineNumber;
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"Line: %@, Range: %@", @(self.lineNumber), NSStringFromRect(self.rect)];
}

@end
