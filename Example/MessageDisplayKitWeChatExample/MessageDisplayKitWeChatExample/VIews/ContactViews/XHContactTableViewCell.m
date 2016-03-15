//
//  XHContactTableViewCell.m
//  MessageDisplayExample
//
//  Created by dw_iOS on 14-5-22.
//  Copyright (c) 2014年 嗨，我是曾宪华(@xhzengAIB)，曾加入YY Inc.担任高级移动开发工程师，拍立秀App联合创始人，热衷于简洁、而富有理性的事物 QQ:543413507 主页:http://zengxianhua.com All rights reserved.
//

#import "XHContactTableViewCell.h"

@implementation XHContactTableViewCell

- (void)configureContact:(XHContact *)contact inContactType:(XHContactType)contactType searchBarText:(NSString *)searchBarText {
    self.currentContact = contact;
    
    switch (contactType) {
        case XHContactTypeNormal: {
            self.textLabel.text = contact.contactName;
            break;
        }
        case XHContactTypeFilter: {
            NSMutableAttributedString *attributedTitle = [[NSMutableAttributedString alloc] initWithString:contact.contactName attributes:@{NSForegroundColorAttributeName: [UIColor colorWithWhite:0.785 alpha:1.000], NSFontAttributeName:[UIFont preferredFontForTextStyle:UIFontTextStyleBody]}];
            [attributedTitle addAttribute:NSForegroundColorAttributeName
                                    value:[UIColor colorWithRed:0.122 green:0.475 blue:0.992 alpha:1.000]
                                    range:[attributedTitle.string.lowercaseString rangeOfString:searchBarText]];
            
            self.textLabel.attributedText = attributedTitle;
            break;
        }
        default:
            break;
    }
}

#pragma mark - Life Cycle

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
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
