//
//  SETextView.m
//  SECoreTextView
//
//  Created by kishikawa katsumi on 2013/04/19.
//  Copyright (c) 2013 kishikawa katsumi. All rights reserved.
//

#import "SETextLayout.h"
#import "SELineLayout.h"
#import "SETextSelection.h"
#import "SELinkText.h"
#import "SETextGeometry.h"

@interface SETextLayout () {
    CTFramesetterRef _framesetter;
    CTFrameRef _frame;
    
    /* Unused */
    CTTypesetterRef _typesetter;
    CFMutableArrayRef _lines;
}

@end

@implementation SETextLayout

- (id)init
{
    self = [super init];
    if (self) {
        [self commonInit];
    }
    
    return self;
}

- (id)initWithAttributedString:(NSAttributedString *)attributedString
{
    self = [super init];
    if (self) {
        [self commonInit];
        self.attributedString = attributedString.copy;
    }
    
    return self;
}

- (void)commonInit
{
    self.markedTextRange = NSMakeRange(NSNotFound, 0);
    _lines = CFArrayCreateMutable(NULL, 0, NULL);
}

- (void)dealloc
{
    if (_framesetter) {
        CFRelease(_framesetter);
    }
    if (_frame) {
        CFRelease(_frame);
    }
    if (_lines) {
        CFRelease(_lines);
    }
}

+ (CGRect)frameRectWithAttributtedString:(NSAttributedString *)attributedString
                          constraintSize:(CGSize)constraintSize
{
    SETextLayout *textLayout = [[SETextLayout alloc] initWithAttributedString:attributedString];
    
    CGRect bounds = CGRectZero;
    bounds.size = constraintSize;
    
    textLayout.bounds = bounds;
    
    [textLayout createFramesetter];
    [textLayout createFrame];
    
    return textLayout.frameRect;
}

#pragma mark -

- (void)createFramesetter
{
    if (_framesetter) {
        CFRelease(_framesetter);
    }
    
    CFAttributedStringRef attributedString = (__bridge CFAttributedStringRef)self.attributedString;
    if (attributedString) {
        _framesetter = CTFramesetterCreateWithAttributedString(attributedString);
    } else {
        attributedString = CFAttributedStringCreate(NULL, CFSTR(""), NULL);
        _framesetter = CTFramesetterCreateWithAttributedString(attributedString);
        CFRelease(attributedString);
    }
}

/* laying out with CTFramesetterRef */
- (void)createFrame
{
    if (_frame) {
        CFRelease(_frame);
    }
    
    CGRect frameRect = _bounds;
    CGSize frameSize = CTFramesetterSuggestFrameSizeWithConstraints(_framesetter,
                                                                    CFRangeMake(0, _attributedString.length),
                                                                    NULL,
                                                                    CGSizeMake(frameRect.size.width, CGFLOAT_MAX),
                                                                    NULL);
    if (self.isEditing) {
        frameSize.height += [[UIFont systemFontOfSize:[UIFont labelFontSize]] leading]; // Workaround
    }
    frameRect.origin.y = CGRectGetMaxY(frameRect) - frameSize.height;
    frameRect.size.height = frameSize.height;
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, frameRect);
    _frame = CTFramesetterCreateFrame(_framesetter, CFRangeMake(0, 0), path, NULL);
    CGPathRelease(path);
    
    _frameRect = frameRect;
#if TARGET_OS_IPHONE
    _frameRect.origin.y = 0.0f;
#endif
}

- (void)createTypesetter
{
    if (_typesetter) {
        CFRelease(_typesetter);
    }
    
    CFAttributedStringRef attributedString = (__bridge CFAttributedStringRef)self.attributedString;
    if (attributedString) {
        _typesetter = CTTypesetterCreateWithAttributedString(attributedString);
    } else {
        attributedString = CFAttributedStringCreate(NULL, CFSTR(""), NULL);
        _typesetter = CTTypesetterCreateWithAttributedString(attributedString);
        CFRelease(attributedString);
    }
}

/* laying out with CTTypesetterRef (Unused) */
- (void)layoutLines
{
    CGRect frameRect = _bounds;
    CGFloat width = CGRectGetWidth(frameRect);
    CGPoint textPosition = CGPointMake(floor(CGRectGetMinX(frameRect)),
                                       floor(CGRectGetMaxY(frameRect)));
    CFIndex start = 0;
    NSUInteger length = _attributedString.length;
    while (start < length && textPosition.y > frameRect.origin.y) {
        CFIndex count = CTTypesetterSuggestLineBreak(_typesetter, start, width);
        CTLineRef line = CTTypesetterCreateLine(_typesetter, CFRangeMake(start, count));
        CFArrayAppendValue(_lines, line);
        CFRelease(line);
        
        CGFloat ascent;
        CGFloat descent;
        CGFloat leading;
        CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
        
        textPosition.y -= ceil(ascent);
        textPosition.y -= ceilf(descent + leading + 1); // +1 matches best to CTFramesetter's behavior
        
        start += count;
    }
} /* Unused */

- (void)detectLinks
{
    NSMutableArray *links = [[NSMutableArray alloc] init];
    
    NSUInteger length = self.attributedString.length;
    [self.attributedString enumerateAttribute:NSLinkAttributeName
                                      inRange:NSMakeRange(0, length)
                                      options:0
                                   usingBlock:^(id value, NSRange range, BOOL *stop)
     {
         if (value) {
             NSString *linkText = [self.attributedString.string substringWithRange:range];
             SELinkText *link = [[SELinkText alloc] initWithText:linkText object:value range:range];
             [links addObject:link];
         }
     }];
    
    _links = links.copy;
}

- (void)calculateLines
{
    CFArrayRef lines = CTFrameGetLines(_frame);
    CFIndex lineCount = CFArrayGetCount(lines);
    CGPoint lineOrigins[lineCount];
    CTFrameGetLineOrigins(_frame, CFRangeMake(0, 0), lineOrigins);
    
    NSMutableArray *lineLayouts = [[NSMutableArray alloc] initWithCapacity:lineCount];
    NSInteger index = 0;
    BOOL isTruncated = NO;
    for (; index < lineCount; index++) {
        CGPoint origin = lineOrigins[index];
        CTLineRef line = CFArrayGetValueAtIndex(lines, index);
        
        CGFloat ascent;
        CGFloat descent;
        CGFloat leading;
        CGFloat width = CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
        
        SELineMetrics metrics;
        metrics.ascent = ascent;
        metrics.descent = descent;
        metrics.leading = leading;
        metrics.width = width;
        metrics.trailingWhitespaceWidth = CTLineGetTrailingWhitespaceWidth(line);
        
        CGRect lineRect = CGRectMake(origin.x,
                                     origin.y - descent,
                                     width,
                                     ascent + descent);
        lineRect.origin.x += _frameRect.origin.x;
        
#if TARGET_OS_IPHONE
        lineRect.origin.y = CGRectGetHeight(_frameRect) - CGRectGetMaxY(lineRect);
#else
        lineRect.origin.y += _frameRect.origin.y;
#endif
        
        CGRect drawingRect = lineRect;
        if (index > 0) {
#if TARGET_OS_IPHONE
        drawingRect.origin.y = CGRectGetHeight(_bounds) - CGRectGetMaxY(lineRect);
        if (self.lineBreakMode == kCTLineBreakByTruncatingTail && drawingRect.origin.y < 0.0f) {
            isTruncated = YES;
            break;
        }
#else
        if (self.lineBreakMode == kCTLineBreakByTruncatingTail && lineRect.origin.y < 0.0f) {
            isTruncated = YES;
            break;
        }
#endif
        }
        
        SELineLayout *lineLayout = [[SELineLayout alloc] initWithLine:line index:index rect:lineRect metrics:metrics];
        lineLayout.drawingRect = drawingRect;
        
        for (SELinkText *link in self.links) {
            CGRect linkRect = [lineLayout rectOfStringWithRange:link.range];
            if (!CGRectIsEmpty(linkRect)) {
                SETextGeometry *geometry = [[SETextGeometry alloc] initWithRect:linkRect lineNumber:index];
                [link addLinkGeometry:geometry];
                
                [lineLayout addLink:link];
            }
        }
        
        [lineLayouts addObject:lineLayout];
    }
    
    if (isTruncated) {
        NSInteger truncatedLineIndex = index - 1;
        SELineLayout *lineLayout = lineLayouts[truncatedLineIndex];
        
        NSDictionary *attributes = [self.attributedString attributesAtIndex:0 effectiveRange:NULL];
        CFAttributedStringRef truncationText = CFAttributedStringCreate(NULL, CFSTR("\u2026"), (__bridge CFDictionaryRef)attributes);
        CTLineRef truncationToken = CTLineCreateWithAttributedString(truncationText);
        CFRelease(truncationText);
        
        CTLineRef line = lineLayout.line;
        CFRange stringRange = CTLineGetStringRange(line);
        CGFloat offset = CTLineGetOffsetForStringIndex(line, stringRange.location + stringRange.length - 1, NULL);
        
        CTLineRef truncationLine = CTLineCreateTruncatedLine(lineLayout.line, offset - 1.0f, kCTLineTruncationEnd, truncationToken);
        
        CGFloat width = CTLineGetTypographicBounds(truncationLine, NULL, NULL, NULL);
        CGRect rect = lineLayout.rect;
        if (self.textAlignment == kCTTextAlignmentCenter) {
            rect.origin.x += (rect.size.width - width) / 2;
        } else if (self.textAlignment == kCTTextAlignmentRight) {
            rect.origin.x += rect.size.width - width;
        }
        rect.size.width = width;
        
        SELineLayout *truncationLineLayout = [[SELineLayout alloc] initWithLine:truncationLine index:lineLayout.index rect:rect metrics:lineLayout.metrics];
        
        CFRelease(truncationLine);
        
        CGRect drawingRect = lineLayout.drawingRect;
        drawingRect.origin.x = rect.origin.x;
        drawingRect.size.width = rect.size.width;
        truncationLineLayout.drawingRect = drawingRect;
        
        CGFloat truncationTokenWidth = CTLineGetTypographicBounds(truncationToken, NULL, NULL, NULL);
        truncationLineLayout.truncationTokenWidth = truncationTokenWidth;
        
        truncationLineLayout.truncated = YES;
        [lineLayouts replaceObjectAtIndex:truncatedLineIndex withObject:truncationLineLayout];
        CFRelease(truncationToken);
    }
    
    _lineLayouts = lineLayouts.copy;
}

- (void)update
{
    [self createFramesetter];
    [self createFrame];
    
    [self detectLinks];
    
    [self calculateLines];
}

- (void)drawFrameInContext:(CGContextRef)context
{
#if TARGET_OS_IPHONE
    CGContextTranslateCTM(context, 0, CGRectGetHeight(self.bounds));
    CGContextScaleCTM(context, 1.0, -1.0);
#endif

    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    
    if (self.lineBreakMode == kCTLineBreakByTruncatingTail) {
        NSArray *lineLayouts = self.lineLayouts;
        for (SELineLayout *lineLayout in lineLayouts) {
            CGRect lineRect = lineLayout.drawingRect;
            CGContextSetTextPosition(context, lineRect.origin.x, lineRect.origin.y + lineLayout.metrics.descent);
            
            CTLineRef line = lineLayout.line;
            CTLineDraw(line, context);
        }
    } else {
        CTFrameDraw(_frame, context);
    }
}

- (void)drawInContext:(CGContextRef)context
{    
    [self drawFrameInContext:context];    
}

#pragma mark -

- (CFIndex)stringIndexForPosition:(CGPoint)point
{
    for (SELineLayout *lineLayout in self.lineLayouts) {
        if ([lineLayout containsPoint:point]) {
            CFIndex index = [lineLayout stringIndexForPosition:point];
            
            if (index != kCFNotFound) {
                return index;
            }
        }
    }
    
    return kCFNotFound;
}

- (CFIndex)stringIndexForClosestPosition:(CGPoint)point
{
    NSString *text = self.attributedString.string;
    
    CFIndex lineNumber = 0;
    for (SELineLayout *lineLayout in self.lineLayouts) {
        if ([lineLayout containsPoint:point]) {
            CFIndex index = [lineLayout stringIndexForPosition:point];
            
            if (index < text.length) {
                unichar c = [text characterAtIndex:index];
                if (CFStringIsSurrogateLowCharacter(c)) {
                    index++;
                    if ((0xDDE6 <= c && c <= 0xDDFF) || c == 0x20E3) {
                        index += 2;
                    }
                }
            }
            
            if (index != kCFNotFound) {
                return index;
            }
        }
        
#if TARGET_OS_IPHONE
        if (lineNumber == 0 && point.y < CGRectGetMinY(lineLayout.rect)) {
            return 0;
        }
        
        if (lineNumber == self.lineLayouts.count - 1 && point.y > CGRectGetMaxY(lineLayout.rect) - lineLayout.metrics.leading) {
            return [lineLayout stringIndexForPosition:CGPointMake(CGRectGetMaxX(lineLayout.rect), CGRectGetMinY(lineLayout.rect))];
        }
        
        if (point.y > CGRectGetMinY(lineLayout.rect) && point.y < CGRectGetMaxY(lineLayout.rect) - lineLayout.metrics.leading) {
            return [lineLayout stringIndexForPosition:CGPointMake(CGRectGetMaxX(lineLayout.rect), CGRectGetMinY(lineLayout.rect))];
        }
#else
        if (lineNumber == 0 && point.y > CGRectGetMaxY(lineLayout.rect)) {
            return 0;
        }
        
        if (lineNumber == self.lineLayouts.count - 1 && point.y < CGRectGetMinY(lineLayout.rect) - lineLayout.metrics.leading) {
            return [lineLayout stringIndexForPosition:CGPointMake(CGRectGetMaxX(lineLayout.rect), CGRectGetMaxY(lineLayout.rect))];
        }
        
        if (point.y < CGRectGetMaxY(lineLayout.rect) && point.y > CGRectGetMinY(lineLayout.rect) - lineLayout.metrics.leading) {
            return [lineLayout stringIndexForPosition:CGPointMake(CGRectGetMaxX(lineLayout.rect), CGRectGetMaxY(lineLayout.rect))];
        }
#endif
        
        lineNumber++;
    }
    
    return kCFNotFound;
}

- (CGRect)rectOfStringForIndex:(CFIndex)index;
{
    CGRect rect = CGRectZero;
    
    if (index != kCFNotFound) {
        for (SELineLayout *lineLayout in self.lineLayouts) {
            NSRange stringRange = lineLayout.stringRange;
            
            if (index >= stringRange.location && index <= stringRange.location + stringRange.length) {
                CTLineRef line = lineLayout.line;
                CGFloat offset = CTLineGetOffsetForStringIndex(line, index, NULL);
                
                CGFloat width = offset;
                if (index > 1) {
                    width = offset - CTLineGetOffsetForStringIndex(line, index - 1, NULL);
                }
                
                rect = lineLayout.rect;
                rect.origin.x += offset - width;
                rect.size.width = width;
                
                break;
            }
        }
    }
    
    return rect;
}

- (CGRect)rectOfStringForLastLine
{
    SELineLayout *lineLayout = self.lineLayouts.lastObject;
    NSRange stringRange = lineLayout.stringRange;
    
    CTLineRef line = lineLayout.line;
    CGFloat offset = CTLineGetOffsetForStringIndex(line, stringRange.location, NULL);
    
    CGRect rect = CGRectZero;
    rect = lineLayout.rect;
    rect.origin.x += offset;
    
    return rect;
}

- (void)setSelectionStartWithPoint:(CGPoint)point;
{
    CFIndex index = [self stringIndexForPosition:point];
    if (index != kCFNotFound) {
        self.textSelection = [[SETextSelection alloc] initWithIndex:index];
    } else {
        self.textSelection = nil;
    }
}

- (void)setSelectionEndWithPoint:(CGPoint)point;
{
    CFIndex index = [self stringIndexForClosestPosition:point];
    if (index != kCFNotFound) {
        [self.textSelection setSelectionEndAtIndex:index];
    }
}

- (void)setSelectionEndWithClosestPoint:(CGPoint)point;
{
    CFIndex index = [self stringIndexForClosestPosition:point];
    [self.textSelection setSelectionEndAtIndex:index];
}

- (void)setSelectionStartWithFirstPoint:(CGPoint)firstPoint
{
    CFIndex start = [self stringIndexForClosestPosition:firstPoint];
    CFIndex end = NSMaxRange(self.textSelection.selectedRange);
    
    if (start != kCFNotFound) {
        if (start < end) {
            self.textSelection = [[SETextSelection alloc] initWithIndex:start];
        } else {
            end = start;
        }
    }
    
    [self.textSelection setSelectionEndAtIndex:end];
}

- (void)setSelectionWithPoint:(CGPoint)point
{
    CFIndex index = [self stringIndexForPosition:point];
    if (index == kCFNotFound) {
        return;
    }
    
    CFStringRef string = (__bridge CFStringRef)self.attributedString.string;
    CFRange range = CFRangeMake(0, CFStringGetLength(string));
    CFStringTokenizerRef tokenizer = CFStringTokenizerCreate(
                                                             NULL,
                                                             string,
                                                             range,
                                                             kCFStringTokenizerUnitWordBoundary,
                                                             NULL);
    CFStringTokenizerTokenType tokenType = CFStringTokenizerGoToTokenAtIndex(tokenizer, 0);
    while (tokenType != kCFStringTokenizerTokenNone) {
        range = CFStringTokenizerGetCurrentTokenRange(tokenizer);
        CFIndex first = range.location;
        CFIndex second = range.location + range.length;
        if (first != kCFNotFound && first <= index && index <= second) {
            self.textSelection = [[SETextSelection alloc] initWithIndex:range.location];
            [self.textSelection setSelectionEndAtIndex:range.location + range.length];
            break;
        }
        
        tokenType = CFStringTokenizerAdvanceToNextToken(tokenizer);
    }
    CFRelease(tokenizer);
}

- (void)setSelectionWithFirstPoint:(CGPoint)firstPoint secondPoint:(CGPoint)secondPoint
{
    CFIndex firstIndex = [self stringIndexForPosition:firstPoint];
    if (firstIndex == kCFNotFound) {
        firstIndex = 0;
    }
    CFIndex secondIndex = [self stringIndexForPosition:secondPoint];
    if (secondIndex == kCFNotFound) {
        secondIndex = self.attributedString.length - firstIndex;
    }
    self.textSelection = [[SETextSelection alloc] initWithIndex:firstIndex];
    [self.textSelection setSelectionEndAtIndex:secondIndex];
}

- (void)selectAll
{
    self.textSelection = [[SETextSelection alloc] initWithIndex:0];
    [self.textSelection setSelectionEndAtIndex:self.attributedString.length];
}

- (void)clearSelection
{
    self.textSelection = nil;
}

@end
