//
//  SCRecordView.h
//  SCCaptureCameraDemo
//
//  Created by Aevitx on 14-1-21.
//  Copyright (c) 2014年 Aevitx. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^WhenBeginTouch)(NSSet *touches, UIEvent *event);
typedef void(^WhenMoveTouch)(NSSet *touches, UIEvent *event);
typedef void(^WhenEndTouch)(NSSet *touches, UIEvent *event);
typedef void(^WhenCancleTouch)(NSSet *touches, UIEvent *event);
typedef void(^WhenTrashBtnPressed)();

@protocol SCRecordViewDelegate;

@interface SCRecordView : UIView

@property (nonatomic, assign) int verticalRowNum;   //多少列
@property (nonatomic, assign) int highestRowRectNum; //最高(中间)一列的方块数量
 
@property (nonatomic, assign) CGFloat eachWidth;    //每个方块的宽度
@property (nonatomic, assign) CGFloat eachHeight;   //每个方块的高度


@property (nonatomic, strong) UIColor *rectColor;   //方块的颜色


@property (nonatomic, assign) id <SCRecordViewDelegate> delegate;


- (id)initWithFrame:(CGRect)frame parentView:(UIView*)parentView;
- (void)show:(BOOL)toShow;


//callback
@property (nonatomic, copy) WhenBeginTouch beginBlock;
@property (nonatomic, copy) WhenMoveTouch moveBlock;
@property (nonatomic, copy) WhenEndTouch endBlock;
@property (nonatomic, copy) WhenCancleTouch cancleBlock;


- (void)whenBegin:(WhenBeginTouch)block;
- (void)whenMove:(WhenMoveTouch)block;
- (void)whenEnd:(WhenEndTouch)block;
- (void)whenCancle:(WhenCancleTouch)block;

@property (nonatomic, strong) UIButton *trashBtn;
@property (nonatomic, copy) WhenTrashBtnPressed trashBtnPressedBlock;
- (void)whenTrashBtnPressed:(WhenTrashBtnPressed)block;
- (void)confirmToDelete;

@end





@protocol SCRecordViewDelegate <NSObject>

@optional
- (void)beginTouch:(SCRecordView*)recordView touches:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)moveTouch:(SCRecordView*)recordView touches:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)endTouch:(SCRecordView*)recordView touches:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)cancleTouch:(SCRecordView*)recordView touches:(NSSet *)touches withEvent:(UIEvent *)event;

@end