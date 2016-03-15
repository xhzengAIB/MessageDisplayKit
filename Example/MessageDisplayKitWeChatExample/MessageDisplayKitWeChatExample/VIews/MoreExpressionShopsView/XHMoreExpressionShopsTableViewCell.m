//
//  XHMoreExpressionShopsTableViewCell.m
//  MessageDisplayExample
//
//  Created by 曾 宪华 on 14-5-29.
//  Copyright (c) 2014年 嗨，我是曾宪华(@xhzengAIB)，曾加入YY Inc.担任高级移动开发工程师，拍立秀App联合创始人，热衷于简洁、而富有理性的事物 QQ:543413507 主页:http://zengxianhua.com All rights reserved.
//

#import "XHMoreExpressionShopsTableViewCell.h"

@interface XHMoreExpressionShopsTableViewCell ()

@property (nonatomic, strong) UIImageView *emotionListNewTipsImageView;

@property (nonatomic, strong) UIButton *accessButton;

@end

@implementation XHMoreExpressionShopsTableViewCell

- (void)setupFreeExpressionAccessView {
    [self.accessButton setTitle:@"免费" forState:UIControlStateNormal];
    [self setupNormalBackgroundImageView];
}

- (void)setupRemoteExpressionAccessView {
    [self deleteTitle];
    [self.accessButton setImage:[UIImage imageNamed:@"EmotionDownload"] forState:UIControlStateNormal];
    [self.accessButton setBackgroundImage:XH_STRETCH_IMAGE([UIImage imageNamed:@"GreenBtn"], UIEdgeInsetsMake(5, 5, 5, 5)) forState:UIControlStateNormal];
}

- (void)setupDownloadedExpressionAccessView {
    [self deleteTitle];
    [self.accessButton setImage:[UIImage imageNamed:@"EmotionDownloadComplete"] forState:UIControlStateNormal];
    [self.accessButton setBackgroundImage:nil forState:UIControlStateNormal];
    [self.accessButton setBackgroundImage:nil forState:UIControlStateHighlighted];
}

- (void)setupPaymentExpressionAccessView {
    [self.accessButton setTitle:@"￥6.00" forState:UIControlStateNormal];
    [self setupNormalBackgroundImageView];
}

- (void)deleteTitle {
    [self.accessButton setTitle:nil forState:UIControlStateNormal];
}

- (void)setupNormalBackgroundImageView {
    [self.accessButton setBackgroundImage:XH_STRETCH_IMAGE([UIImage imageNamed:@"EmoStoreDownloadBtn"], UIEdgeInsetsMake(5, 5, 5, 5)) forState:UIControlStateNormal];
    [self.accessButton setBackgroundImage:XH_STRETCH_IMAGE([UIImage imageNamed:@"EmoStoreDownloadBtnHL"], UIEdgeInsetsMake(5, 5, 5, 5)) forState:UIControlStateHighlighted];
}

#pragma mark - Propertys

- (UIImageView *)emotionListNewTipsImageView {
    if (!_emotionListNewTipsImageView) {
        _emotionListNewTipsImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        _emotionListNewTipsImageView.image = [UIImage imageNamed:@"EmotionListNewTips"];
    }
    return _emotionListNewTipsImageView;
}

- (void)setNewExpressionEffect:(BOOL)newExpressionEffect {
    _newExpressionEffect = newExpressionEffect;
    self.emotionListNewTipsImageView.hidden = !newExpressionEffect;
}

- (void)setExpressionStateType:(XHExpressionStateType)expressionStateType {
    switch (expressionStateType) {
        case XHExpressionStateTypeFreeExpression: {
            [self setupFreeExpressionAccessView];
            break;
        }
        case XHExpressionStateTypeRemoteExpression: {
            [self setupRemoteExpressionAccessView];
            break;
        }
        case XHExpressionStateTypeDownloadedExpression: {
            [self setupDownloadedExpressionAccessView];
            break;
        }
        case XHExpressionStateTypePaymentExpression: {
            [self setupPaymentExpressionAccessView];
            break;
        }
        default:
            break;
    }
}

- (UIButton *)accessButton {
    if (!_accessButton) {
        _accessButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 25)];
        _accessButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_accessButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
    return _accessButton;
}

#pragma mark - Life Cycle

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self.contentView addSubview:self.emotionListNewTipsImageView];
        self.newExpressionEffect = NO;
        self.accessoryView = self.accessButton;
        self.expressionStateType = XHExpressionStateTypeFreeExpression;
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
