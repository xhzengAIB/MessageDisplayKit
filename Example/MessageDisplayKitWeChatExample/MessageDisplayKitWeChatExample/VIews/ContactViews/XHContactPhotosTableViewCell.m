//
//  XHContactPhotosTableViewCell.m
//  MessageDisplayExample
//
//  Created by 曾 宪华 on 14-5-24.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHContactPhotosTableViewCell.h"

#import "XHContactPhotosView.h"

@interface XHContactPhotosTableViewCell ()

@property (nonatomic, strong) XHContactPhotosView *contactPhotosView;

@end

@implementation XHContactPhotosTableViewCell

- (void)configureCellWithContactInfo:(id)info atIndexPath:(NSIndexPath *)indexPath {
    NSString *placeholder;
    
    self.accessoryType = UITableViewCellAccessoryNone;
    self.contactPhotosView.hidden = YES;
    switch (indexPath.row) {
        case 0:
            placeholder = @"地区";
            break;
        case 1:
            placeholder = @"个人签名";
            break;
        case 2:
            placeholder = @"腾讯微博";
            break;
        case 3: {
            placeholder = @"个人相册";
            self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        }
        default:
            break;
    }
    self.textLabel.text = placeholder;
    if ([info isKindOfClass:[NSString class]]) {
        self.detailTextLabel.text = info;
    } else if ([info isKindOfClass:[NSArray class]]) {
        self.contactPhotosView.hidden = NO;
        self.contactPhotosView.photos = info;
        [self.contactPhotosView reloadData];
    }
}

#pragma mark - Propertys

- (XHContactPhotosView *)contactPhotosView {
    if (!_contactPhotosView) {
        CGFloat contactPhotosViewWidht = kXHAlbumPhotoSize * 3 + kXHAlbumPhotoInsets * 2;
        _contactPhotosView = [[XHContactPhotosView alloc] initWithFrame:CGRectMake(CGRectGetWidth([[UIScreen mainScreen] bounds]) - (contactPhotosViewWidht + 40), kXHAlbumPhotoInsets, contactPhotosViewWidht, kXHAlbumPhotoSize)];
        _contactPhotosView.backgroundColor = self.contentView.backgroundColor;
        _contactPhotosView.hidden = YES;
    }
    return _contactPhotosView;
}

#pragma mark - Life Cycle

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.textLabel.font = [UIFont systemFontOfSize:16];
        self.detailTextLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        self.detailTextLabel.numberOfLines = 2;
        self.detailTextLabel.font = [UIFont systemFontOfSize:13];
        
        [self.contentView addSubview:self.contactPhotosView];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)prepareForReuse {
    self.contactPhotosView.photos = nil;
    self.textLabel.text = nil;
    self.detailTextLabel.text = nil;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
