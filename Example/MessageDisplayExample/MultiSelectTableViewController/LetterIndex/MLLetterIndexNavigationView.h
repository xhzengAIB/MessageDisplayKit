//
//  MLLetterIndexNavigationView.h
//  SecondhandCar
//
//  Created by molon on 14-1-8.
//  Copyright (c) 2014年 Molon. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MLLetterIndexNavigationView;

@protocol MLLetterIndexNavigationViewDelegate <NSObject>

-(void)mlLetterIndexNavigationView:(MLLetterIndexNavigationView *)mlLetterIndexNavigationView didSelectIndex:(NSInteger)index;

@end

@interface MLLetterIndexNavigationView : UIView

@property (nonatomic, strong) NSArray *keys; //即为sections
@property (nonatomic, weak) id<MLLetterIndexNavigationViewDelegate> delegate;

//PS：需要搜索图标显示的话，delegate返回的index要注意下。搜索图标index为0。
@property (nonatomic, assign) BOOL isNeedSearchIcon;

@end
