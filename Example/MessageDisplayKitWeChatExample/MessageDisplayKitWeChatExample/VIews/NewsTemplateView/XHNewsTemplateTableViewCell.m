//
//  XHNewsTemplateTableViewCell.m
//  MessageDisplayExample
//
//  Created by 曾 宪华 on 14-5-29.
//  Copyright (c) 2014年 嗨，我是曾宪华(@xhzengAIB)，曾加入YY Inc.担任高级移动开发工程师，拍立秀App联合创始人，热衷于简洁、而富有理性的事物 QQ:543413507 主页:http://zengxianhua.com All rights reserved.
//

#import "XHNewsTemplateTableViewCell.h"

@implementation XHNewsTemplateTableViewCell

#pragma mark - Properrtys

- (XHNewsTemplateContainerView *)newsTemplateContainerView {
    if (!_newsTemplateContainerView) {
        _newsTemplateContainerView = [[XHNewsTemplateContainerView alloc] initWithFrame:CGRectMake(kXHNewsTemplateContainerViewSpacing, kXHNewsTemplateContainerViewSpacing, CGRectGetWidth([[UIScreen mainScreen] bounds]) - kXHNewsTemplateContainerViewSpacing * 2, kXHNewsTemplateContainerViewHeight)];
    }
    return _newsTemplateContainerView;
}

#pragma mark - Life Cycle

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self.contentView addSubview:self.newsTemplateContainerView];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
