//
//  UIButton+XHButtonTitlePosition.m
//  MessageDisplayExample
//
//  Created by 曾 宪华 on 14-5-25.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
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
