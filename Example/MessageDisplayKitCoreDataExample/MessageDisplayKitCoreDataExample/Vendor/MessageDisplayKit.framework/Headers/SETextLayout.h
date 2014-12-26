//
//  SETextView.h
//  SECoreTextView
//
//  Created by kishikawa katsumi on 2013/04/19.
//  Copyright (c) 2013 kishikawa katsumi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>
#import "SECompatibility.h"

@class SETextSelection, SELinkText;

@interface SETextLayout : NSObject

@property (nonatomic, copy) NSAttributedString *attributedString;

@property (nonatomic) CGRect bounds;

@property (nonatomic, readonly) CGRect frameRect;
@property (nonatomic, readonly) NSArray *lineLayouts;

@property (nonatomic) SETextSelection *textSelection;
@property (nonatomic, readonly) NSArray *links;

@property (nonatomic) NSRange markedTextRange;
@property (nonatomic, getter = isEditing) BOOL editing;

@property (nonatomic) CTTextAlignment textAlignment;
@property (nonatomic) CTLineBreakMode lineBreakMode;

- (id)initWithAttributedString:(NSAttributedString *)attributedString;
- (void)update;
- (void)drawInContext:(CGContextRef)context;

- (CFIndex)stringIndexForPosition:(CGPoint)point;
- (CFIndex)stringIndexForClosestPosition:(CGPoint)point;
- (CGRect)rectOfStringForIndex:(CFIndex)index;
- (CGRect)rectOfStringForLastLine;

- (void)setSelectionStartWithPoint:(CGPoint)point;
- (void)setSelectionEndWithPoint:(CGPoint)point;
- (void)setSelectionEndWithClosestPoint:(CGPoint)point;
- (void)setSelectionStartWithFirstPoint:(CGPoint)firstPoint;

- (void)setSelectionWithPoint:(CGPoint)point;
- (void)setSelectionWithFirstPoint:(CGPoint)firstPoint secondPoint:(CGPoint)secondPoint;

- (void)selectAll;
- (void)clearSelection;

+ (CGRect)frameRectWithAttributtedString:(NSAttributedString *)attributedString
                          constraintSize:(CGSize)constraintSize;

@end
