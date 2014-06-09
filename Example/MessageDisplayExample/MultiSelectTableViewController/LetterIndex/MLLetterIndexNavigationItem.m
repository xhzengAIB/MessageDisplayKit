//
//  MLLetterIndexNavigationItem.m
//  SecondhandCar
//
//  Created by molon on 14-1-8.
//  Copyright (c) 2014年 Molon. All rights reserved.
//

#import "MLLetterIndexNavigationItem.h"

@implementation MLLetterIndexNavigationItem
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setUp];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        [self setUp];
    }
    return self;
}

- (void)setUp
{
    self.exclusiveTouch = YES;
    self.multipleTouchEnabled = NO;
    self.backgroundColor = [UIColor clearColor];
    
    self.textAlignment = NSTextAlignmentCenter;
    self.font = [UIFont boldSystemFontOfSize:11];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)setIsHighlighted:(BOOL)isHighlighted
{
    _isHighlighted = isHighlighted;
    
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.isHighlighted) {
        self.textColor = [UIColor redColor];
    }else{
        self.textColor = [UIColor darkGrayColor];
    }
}

@end
