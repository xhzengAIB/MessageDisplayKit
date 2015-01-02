//
//  SELinkText.h
//  SECoreTextView
//
//  Created by kishikawa katsumi on 2013/04/20.
//  Copyright (c) 2013 kishikawa katsumi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SETextGeometry;

@interface SELinkText : NSObject

@property (nonatomic, readonly) NSString *text;
@property (nonatomic, readonly) id object;
@property (nonatomic, readonly) NSRange range;
@property (nonatomic, readonly) NSArray *geometries;

- (id)initWithText:(NSString *)text object:(id)object range:(NSRange)range;
- (void)addLinkGeometry:(SETextGeometry *)geometry;

@end
