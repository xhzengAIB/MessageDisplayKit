//
//  UIButton+XHButtonTitlePosition.m
//  MessageDisplayExample
//
//  Created by 曾 宪华 on 14-5-25.
//  Copyright (c) 2014年 嗨，我是曾宪华(@xhzengAIB)，曾加入YY Inc.担任高级移动开发工程师，拍立秀App联合创始人，热衷于简洁、而富有理性的事物 QQ:543413507 主页:http://zengxianhua.com All rights reserved.
//

#import "UIButton+XHButtonTitlePosition.h"

@implementation UIButton (XHButtonTitlePosition)

- (void)setTitlePositionWithType:(XHButtonTitlePostionType)type {
    switch (type) {
        case XHButtonTitlePostionTypeBottom: {
            // the space between the image and text
            CGFloat spacing = 2.0;
            
            // lower the text and push it left so it appears centered
            //  below the image
            CGSize imageSize = self.imageView.frame.size;
            self.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width, - (imageSize.height + spacing), 0.0);
            
            // raise the image and push it right so it appears centered
            //  above the text
            CGSize titleSize = self.titleLabel.frame.size;
            self.imageEdgeInsets = UIEdgeInsetsMake(-(titleSize.height + spacing), 0.0, 0.0, - titleSize.width);
            break;
        }
        default:
            break;
    }
}

@end
