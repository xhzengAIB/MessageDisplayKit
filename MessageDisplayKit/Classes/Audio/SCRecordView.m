//
//  SCRecordView.m
//  SCCaptureCameraDemo
//
//  Created by Aevitx on 14-1-21.
//  Copyright (c) 2014年 Aevitx. All rights reserved.
//

#import "SCRecordView.h"
#import <QuartzCore/QuartzCore.h>

#import "SCDefines.h"

#define RECT_GAP        5 //方块间的间隔

static NSString *kAnimationNameKey = @"animation_name";
static NSString *kScrapDriveUpAnimationName = @"scrap_drive_up_animation";
static NSString *kScrapDriveDownAnimationName = @"scrap_drive_down_animation";
static NSString *kBucketDriveUpAnimationName = @"bucket_drive_up_animation";
static NSString *kBucketDriveDownAnimationName = @"bucket_drive_down_animation";

static const CGFloat kScrapDriveUpAnimationHeight = 200;
static const CGFloat kScrapYOffsetFromBase = 7;

@interface SCRecordView()

@property (nonatomic, strong) UIView *parentView;
@property (nonatomic, assign) CGFloat bottomRectY;
@property (nonatomic, assign) CGFloat firstRowX;


//trash
@property (nonatomic, assign) CGFloat baseviewYOrigin;
@property (nonatomic, strong) CALayer *scrapLayer;
@property (nonatomic, strong) CALayer *bucketContainerLayer;
@property (nonatomic, assign) CFTimeInterval duration;
@property (nonatomic, assign) CGFloat bucketContainerLayerActualYPos;


@end

@implementation SCRecordView

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame parentView:nil];
}

- (id)initWithFrame:(CGRect)frame parentView:(UIView*)parentView {
    self = [super initWithFrame:frame];
    if (self) {
        if (parentView != nil) {
            [parentView addSubview:self];
            self.parentView = parentView;
        }
        
        // Initialization code
        self.opaque = NO;
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6f];
        self.alpha = 0;
        
        self.verticalRowNum = 3;
        self.highestRowRectNum = 4;
        self.eachWidth = 20;
        self.eachHeight = 10;
        self.rectColor = [UIColor whiteColor];
        
    }
    return self;
}

/*
- (CGRect)CGRectIntegralCenteredInRect:(CGRect)innerRect withRect:(CGRect)outerRect
{
    CGFloat originX = floorf((outerRect.size.width - innerRect.size.width) * 0.5f);
    CGFloat originY = floorf((outerRect.size.height - innerRect.size.height) * 0.5f);
    CGRect bounds = CGRectMake(originX, originY, innerRect.size.width, innerRect.size.height);
    return bounds;
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    
    self.duration = 0.4f;
    
    CGRect rect = [self CGRectIntegralCenteredInRect:CGRectMake(0, 0, 200, 40) withRect:self.frame];
    self.baseviewYOrigin = rect.origin.y + 100;
    
    
    // scrap layer
    UIImage *img = [UIImage imageNamed:@"micro.png"];
    rect = [self CGRectIntegralCenteredInRect:CGRectMake(0, 0, img.size.width - 5, img.size.height - 5) withRect:self.frame];
    rect.origin.y = self.baseviewYOrigin - CGRectGetHeight(rect) - kScrapYOffsetFromBase;
    
    self.scrapLayer = [CALayer layer];
    self.scrapLayer.frame = rect;
    self.scrapLayer.bounds = rect;
    [self.scrapLayer setContents:(id)img.CGImage];
    [self.layer addSublayer:self.scrapLayer];
    
    
    // trash layer
    rect = [self CGRectIntegralCenteredInRect:CGRectMake(0, 0, 50, CGRectGetHeight(self.frame)) withRect:self.frame];
    rect.origin.y = self.baseviewYOrigin;
    
    self.bucketContainerLayer = [CALayer layer];
    self.bucketContainerLayer.frame = rect;
    self.bucketContainerLayer.bounds = rect;
    self.bucketContainerLayer.hidden = YES;
    [self.layer addSublayer:self.bucketContainerLayer];
    
    
    // bucket layer
    CGRect centeredRect = [self CGRectIntegralCenteredInRect:CGRectMake(0, 0, 22, 20 + 12) withRect:rect]; //image size(20x32)
    centeredRect.origin.x = CGRectGetMinX(rect) + CGRectGetMinX(centeredRect);
    centeredRect.origin.y = CGRectGetMinY(rect);
    
    self.bucket = [[GLBucket alloc] initWithFrame:centeredRect inLayer:self.bucketContainerLayer];
    self.bucket.bucketStyle = BucketStyle2OpenFromRight;
    
    
    // set bucket-container-layer actual y origin
    self.bucketContainerLayerActualYPos = self.baseviewYOrigin - (self.bucket.actualHeight / 2) - kScrapYOffsetFromBase; //divide by 2 considering center from y-axis
}
*/

- (void)show:(BOOL)toShow {
    [UIView animateWithDuration:0.3f animations:^{
        self.alpha = (toShow ? 1.f : 0.f);
    }];
}

- (void)setEachWidth:(CGFloat)eachWidth {
    if (_eachWidth != eachWidth) {
        _eachWidth = eachWidth;
        
        [self calculateFirstRowX];
    }
}

- (void)setEachHeight:(CGFloat)eachHeight {
    if (_eachHeight != eachHeight) {
        _eachHeight = eachHeight;
        
        _bottomRectY = self.center.y + 2 * _eachHeight + RECT_GAP;
        
        //trash
        if (!_trashBtn) {
            CGFloat btnWidth = 40;
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake((self.frame.size.width - btnWidth) / 2, _bottomRectY + 50, btnWidth, btnWidth);
            [btn setImage:[UIImage imageNamed:@"trash_whole.png"] forState:UIControlStateNormal];
//    [btn addTarget:self action:@selector(trashBtnPressed:) forControlEvents:UIControlEventTouchDown];
            [self addSubview:btn];
            self.trashBtn = btn;
        }
    }
}

- (void)setVerticalRowNum:(int)verticalRowNum {
    if (_verticalRowNum != verticalRowNum) {
        _verticalRowNum = verticalRowNum;
        
        [self calculateFirstRowX];
    }
}

- (void)calculateFirstRowX {
    _firstRowX = self.center.x - (_verticalRowNum / 2.f) * _eachWidth - (_verticalRowNum / 2) * RECT_GAP;
}

- (void)setHighestRowRectNum:(int)highestRowRectNum {
    if (_highestRowRectNum != highestRowRectNum) {
        _highestRowRectNum = highestRowRectNum;
        [self setNeedsDisplay];
    }
}

- (void)drawRect:(CGRect)rect {
    //生成画布
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //从下到上，从左到右画矩形
    for (int i = 0; i < _verticalRowNum; i++) {
        
        int rectNum = [self getRectNumInRow:i];
        
        for (int j = 0; j < rectNum; j++) {
            CGContextSetStrokeColorWithColor(context, [UIColor clearColor].CGColor);//边框颜色
            CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);//填充颜色
            CGContextSetLineWidth(context, 0);//画笔宽度
            CGContextAddRect(context, CGRectMake(_firstRowX + (_eachWidth + RECT_GAP) * i, _bottomRectY - (_eachHeight + RECT_GAP) * j, _eachWidth, _eachHeight));//每个方块的frame
            CGContextDrawPath(context, kCGPathFillStroke);//绘制路径
        }
        
    }
}

/**
 * 每列上的方块数量
 *
 * 只有3列的话
 * 第0列，方块数量：_highestRowRectNum-1
 * 第1列，方块数量：_highestRowRectNum
 * 第2列，方块数量：_highestRowRectNum-2
 *
 *  @param row 第几列
 *
 *  @return 每列上的方块数量
 */
- (int)getRectNumInRow:(int)row {
    if (_verticalRowNum == 3) {
        return (row == 0 ? _highestRowRectNum - 1 : (row == 1 ? _highestRowRectNum : (row == 2 ? _highestRowRectNum - 2 : _highestRowRectNum)));
    } else {
        return MAX(1, arc4random() % _highestRowRectNum);
    }
}

#pragma mark -----------block callback---------
- (void)whenBegin:(WhenBeginTouch)block {
    self.beginBlock = block;
}

- (void)whenMove:(WhenMoveTouch)block {
    self.moveBlock = block;
}

- (void)whenEnd:(WhenEndTouch)block {
    self.endBlock = block;
}

- (void)whenCancle:(WhenCancleTouch)block {
    self.cancleBlock = block;
}

/*
#pragma mark ------------touch------------
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (_trashBtnPressedBlock) {
        _trashBtnPressedBlock();
    }
    
    if (_beginBlock) {
        _beginBlock(touches, event);
    } else if ([self.delegate respondsToSelector:@selector(beginTouch:touches:withEvent:)]) {
        [self.delegate beginTouch:self touches:touches withEvent:event];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint touchPoint = [[touches anyObject] locationInView:self];
    touchPoint = [self convertPoint:touchPoint toView:_trashBtn];
    if (CGRectContainsPoint(_trashBtn.frame, touchPoint) == NO) {
        return;
    }
    if (_moveBlock) {
        _moveBlock(touches, event);
    } else if ([self.delegate respondsToSelector:@selector(moveTouch:touches:withEvent:)]) {
        [self.delegate moveTouch:self touches:touches withEvent:event];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (_endBlock) {
        _endBlock(touches, event);
    } else if ([self.delegate respondsToSelector:@selector(endTouch:touches:withEvent:)]) {
        [self.delegate endTouch:self touches:touches withEvent:event];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    if (_cancleBlock) {
        _cancleBlock(touches, event);
    } else if ([self.delegate respondsToSelector:@selector(cancleTouch:touches:withEvent:)]) {
        [self.delegate cancleTouch:self touches:touches withEvent:event];
    }
}
*/

#pragma mark -----------trashBtnPressed--------
- (void)trashBtnPressed:(id)sender {
    if (_trashBtnPressedBlock) {
        _trashBtnPressedBlock();
    }
}

- (void)confirmToDelete {
//    [_trashBtn setEnabled:NO];
//    [self scrapDriveUpAnimation];
}

- (void)whenTrashBtnPressed:(WhenTrashBtnPressed)block {
    if (block) {
        self.trashBtnPressedBlock = block;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
