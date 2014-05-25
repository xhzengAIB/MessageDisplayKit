//
//  SELinkText.m
//  SECoreTextView
//
//  Created by kishikawa katsumi on 2013/04/20.
//  Copyright (c) 2013 kishikawa katsumi. All rights reserved.
//

#import "SELinkText.h"
#import "SETextGeometry.h"

@implementation SELinkText

- (id)init
{
    return [self initWithText:nil object:nil range:NSMakeRange(0, 0)];
}

- (id)initWithText:(NSString *)text object:(id)object range:(NSRange)range
{
    self = [super init];
    if (self) {
        _text = text;
        _object = object;
        _range = range;
        
        _geometries = [[NSArray alloc] init];
    }
    return self;
}

- (void)addLinkGeometry:(SETextGeometry *)geometry
{
    _geometries = [self.geometries arrayByAddingObject:geometry];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ %@ %@ %@", self.text, self.object, NSStringFromRange(self.range), self.geometries];
}

@end
