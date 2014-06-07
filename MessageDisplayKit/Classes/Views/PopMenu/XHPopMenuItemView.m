//
//  XHPopMenuItemView.m
//  MessageDisplayExample
//
//  Created by dw_iOS on 14-6-7.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHPopMenuItemView.h"

@interface XHPopMenuItemView ()

@property (nonatomic, strong) UIView *menuSelectedBackgroundView;

@property (nonatomic, strong) UIImageView *separatorLineImageView;

@end

@implementation XHPopMenuItemView

#pragma mark - Propertys

- (void)setPopMenuItem:(XHPopMenuItem *)popMenuItem {
    if (_popMenuItem == popMenuItem)
        return;
    _popMenuItem = popMenuItem;
    
    self.textLabel.text = popMenuItem.title;
    self.imageView.image = popMenuItem.image;
}

- (UIView *)menuSelectedBackgroundView {
    if (!_menuSelectedBackgroundView) {
        _menuSelectedBackgroundView = [[UIView alloc] initWithFrame:self.contentView.bounds];
        _menuSelectedBackgroundView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _menuSelectedBackgroundView.backgroundColor = [UIColor whiteColor];
    }
    return _menuSelectedBackgroundView;
}

- (UIImageView *)separatorLineImageView {
    if (!_separatorLineImageView) {
        _separatorLineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, CGRectGetHeight(self.contentView.bounds) - 0.5, CGRectGetWidth(self.contentView.bounds) - 16, 0.5)];
        _separatorLineImageView.backgroundColor = [UIColor whiteColor];
        _separatorLineImageView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
    }
    return _separatorLineImageView;
}

#pragma mark - Life Cycle

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectedBackgroundView = self.menuSelectedBackgroundView;
        [self.contentView addSubview:self.separatorLineImageView];
    }
    return self;
}

@end
