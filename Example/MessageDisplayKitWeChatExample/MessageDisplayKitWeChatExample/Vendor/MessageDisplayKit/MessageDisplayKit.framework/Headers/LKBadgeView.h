//
// Copyright (c) 2011 Hiroshi Hashiguchi
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import <UIKit/UIKit.h>

// Enums
typedef enum {
    LKBadgeViewHorizontalAlignmentLeft = 0,
    LKBadgeViewHorizontalAlignmentCenter,
    LKBadgeViewHorizontalAlignmentRight
    
} LKBadgeViewHorizontalAlignment;

typedef enum {
    LKBadgeViewWidthModeStandard = 0,     // 30x20
    LKBadgeViewWidthModeSmall            // 22x20
} LKBadgeViewWidthMode;

typedef enum {
    LKBadgeViewHeightModeStandard = 0,    // 20
    LKBadgeViewHeightModeLarge             // 30
} LKBadgeViewHeightMode;


// Constants
#define LK_BADGE_VIEW_STANDARD_HEIGHT       20.0
#define LK_BADGE_VIEW_LARGE_HEIGHT          30.0
#define LK_BADGE_VIEw_STANDARD_WIDTH        30.0
#define LK_BADGE_VIEw_MINIMUM_WIDTH         22.0
#define LK_BADGE_VIEW_FONT_SIZE             16.0


@interface LKBadgeView : UIView

@property (nonatomic, copy) NSString* text;
@property (nonatomic, strong) UIColor* textColor;
@property (nonatomic, strong) UIFont* font;
@property (nonatomic, strong) UIColor* badgeColor;
@property (nonatomic, strong) UIColor* outlineColor;
@property (nonatomic, assign) CGFloat outlineWidth;
@property (nonatomic, assign) BOOL outline;
@property (nonatomic, assign) LKBadgeViewHorizontalAlignment horizontalAlignment;
@property (nonatomic, assign) LKBadgeViewWidthMode widthMode;
@property (nonatomic, assign) LKBadgeViewHeightMode heightMode;
@property (nonatomic, assign) BOOL shadow;
@property (nonatomic, assign) CGSize shadowOffset;
@property (nonatomic, assign) CGFloat shadowBlur;
@property (nonatomic, strong) UIColor* shadowColor;
@property (nonatomic, assign) BOOL shadowOfOutline;
@property (nonatomic, assign) BOOL shadowOfText;
@property (nonatomic, assign) CGSize textOffset;

+ (CGFloat)badgeHeight; // @depricated
- (CGFloat)badgeHeight;

@end
