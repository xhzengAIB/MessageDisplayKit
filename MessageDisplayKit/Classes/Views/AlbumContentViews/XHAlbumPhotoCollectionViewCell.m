//
//  XHAlbumPhotoCollectionViewCell.m
//  MessageDisplayExample
//
//  Created by 曾 宪华 on 14-5-20.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHAlbumPhotoCollectionViewCell.h"

@implementation XHAlbumPhotoCollectionViewCell

#pragma mark - Propertys

- (UIImageView *)photoImageView {
    if (!_photoImageView) {
        _photoImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _photoImageView.image = [UIImage imageNamed:@"MeIcon"];
    }
    return _photoImageView;
}

#pragma mark - Life Cycle

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self.contentView addSubview:self.photoImageView];
    }
    return self;
}

@end
