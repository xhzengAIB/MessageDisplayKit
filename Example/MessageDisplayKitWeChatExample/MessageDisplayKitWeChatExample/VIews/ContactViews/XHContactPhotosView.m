//
//  XHContactPhotosView.m
//  MessageDisplayExample
//
//  Created by 曾 宪华 on 14-5-24.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHContactPhotosView.h"

@implementation XHContactPhotosView

- (UIButton *)crateButton {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectZero];
    return button;
}

- (UIButton *)configurePhotoWithPhoto:(UIImage *)photo {
    UIButton *photoButton = [self crateButton];
    [photoButton setImage:photo forState:UIControlStateNormal];
    
    return photoButton;
}

- (UIButton *)configurePhotoWithPhotoUrlString:(NSString *)photoUrlString {
    return [self crateButton];
}

- (void)reloadData {
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    for (id photo in self.photos) {
        NSInteger index = [self.photos indexOfObject:photo];
        CGRect buttonFrame = CGRectMake(index * (kXHAlbumPhotoSize + kXHAlbumPhotoInsets), 0, kXHAlbumPhotoSize, kXHAlbumPhotoSize);
        UIButton *photoButton;
        if ([photo isKindOfClass:[NSString class]]) {
            photoButton = [self configurePhotoWithPhotoUrlString:photo];
        } else if ([photo isKindOfClass:[UIImage class]]) {
            photoButton = [self configurePhotoWithPhoto:photo];
            photoButton.frame = buttonFrame;
        }
        
        [self addSubview:photoButton];
    }
}

#pragma mark - Life Cycle

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
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
