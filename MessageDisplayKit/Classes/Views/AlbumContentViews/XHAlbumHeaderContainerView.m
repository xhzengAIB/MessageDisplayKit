//
//  XHAlbumHeaderContainerView.m
//  MessageDisplayExample
//
//  Created by qtone-1 on 14-5-19.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHAlbumHeaderContainerView.h"

@implementation XHAlbumHeaderContainerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        backgroundImageView.image = [UIImage imageNamed:@"AlbumHeaderBackgrounImage"];
        [self addSubview:backgroundImageView];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
