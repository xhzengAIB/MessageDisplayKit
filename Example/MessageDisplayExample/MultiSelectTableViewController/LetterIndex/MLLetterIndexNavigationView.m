//
//  MLLetterIndexNavigationView.m
//  SecondhandCar
//
//  Created by molon on 14-1-8.
//  Copyright (c) 2014年 Molon. All rights reserved.
//

#import "MLLetterIndexNavigationView.h"
#import "MLLetterIndexNavigationItem.h"

#define kImageViewTag 888
@interface MLLetterIndexNavigationView()

@property(nonatomic,strong) UIView *contentView;
@property(nonatomic,strong) NSMutableArray *items;
@property (nonatomic, strong) UIView *searchIconView;

@end

@implementation MLLetterIndexNavigationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setUp];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        [self setUp];
    }
    return self;
}

- (void)setUp
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.backgroundColor = [UIColor clearColor];
}

- (UIView *)searchIconView
{
    if (!_searchIconView) {
		UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:@"SearchIcon"];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.clipsToBounds = YES;
        imageView.backgroundColor = [UIColor clearColor];
        imageView.tag = kImageViewTag;
        
        
        _searchIconView = [[UIView alloc]init];
        _searchIconView.backgroundColor = [UIColor clearColor];
        [_searchIconView addSubview:imageView];
    }
    return _searchIconView;
}

- (UIView*)contentView
{
    if (!_contentView) {
        _contentView = [[UIView alloc]init];
        _contentView.backgroundColor = [UIColor clearColor];
        [self addSubview:_contentView];
    }
    return _contentView;
}

- (void)setIsNeedSearchIcon:(BOOL)isNeedSearchIcon
{
    _isNeedSearchIcon = isNeedSearchIcon;
    if (isNeedSearchIcon&&!self.searchIconView.superview) {
        [self.contentView addSubview:self.searchIconView];
    }else if(!isNeedSearchIcon&&self.searchIconView.superview){
        [self.searchIconView removeFromSuperview];
    }
    
    [self setNeedsLayout];
}

- (void)setKeys:(NSArray *)keys
{
    if ([keys isEqual:_keys]) {
        return;
    }
    
    _keys = keys;
    
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[MLLetterIndexNavigationItem class]]) {
            [view removeFromSuperview];
        }
    }//删除所有的子View，重新加载
    
    self.items = [NSMutableArray array];
    
    for (NSUInteger i=0; i<self.keys.count; i++) {
        MLLetterIndexNavigationItem *item = [[MLLetterIndexNavigationItem alloc]init];
        item.text = self.keys[i];
        item.index = i;
        [self.contentView addSubview:item];
        [self.items addObject:item];
    }
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (!self.keys) {
        return;
    }
    
    NSUInteger count = self.keys.count;
    if (self.isNeedSearchIcon) {
        count++;
    }
    //整理自身的数据
#define kMaxItemHeight 15  //最高15高度，如果太多的话可能会重叠
    CGFloat itemHeight = self.frame.size.height/count;
    if (itemHeight>kMaxItemHeight) {
        itemHeight = kMaxItemHeight;
    }
    
    CGFloat lastY = 0;
    if (self.isNeedSearchIcon) {
#define kIconWidth 10.0f
        self.searchIconView.frame = CGRectMake(0, lastY, self.frame.size.width, itemHeight);
        //找到imageView
        [self.searchIconView viewWithTag:kImageViewTag].frame = CGRectMake((self.searchIconView.frame.size.width-kIconWidth)/2, lastY, kIconWidth, kIconWidth);
        
        lastY+=itemHeight;
    }
    for (MLLetterIndexNavigationItem *item in self.items) {
        item.frame = CGRectMake(0, lastY, self.frame.size.width, itemHeight);
        lastY+=itemHeight;
    }
    //内容View放在中间
    self.contentView.frame = CGRectMake(0, (self.frame.size.height-lastY)/2, self.frame.size.width, lastY);
}

- (void)unHighlightAllItem
{
    //全局取消高亮
    for (MLLetterIndexNavigationItem *item in self.items) {
        item.isHighlighted = NO;
    }
}

#pragma mark - 下面处理触摸事件

- (void)findAndSelectItemWithTouchPoint:(CGPoint)touchPoint
{
    if (self.isNeedSearchIcon) {
        if (CGRectContainsPoint(self.searchIconView.frame,touchPoint)) {
            //找到了选择的index
            if (self.delegate&&[self.delegate respondsToSelector:@selector(mlLetterIndexNavigationView:didSelectIndex:)]) {
                [self.delegate mlLetterIndexNavigationView:self didSelectIndex:0];
            }
            return;
        }
    }
    
    for (MLLetterIndexNavigationItem *item in self.items) {
        if (CGRectContainsPoint(item.frame, touchPoint)) {
            [self unHighlightAllItem];
            item.isHighlighted = YES;//设置其高亮
            //找到了选择的index
            if (self.delegate&&[self.delegate respondsToSelector:@selector(mlLetterIndexNavigationView:didSelectIndex:)]) {
                [self.delegate mlLetterIndexNavigationView:self didSelectIndex:self.isNeedSearchIcon?item.index+1:item.index];
            }
            return;
        }
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self.contentView];
    
    [self findAndSelectItemWithTouchPoint:touchPoint];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self.contentView];
    
    [self findAndSelectItemWithTouchPoint:touchPoint];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesCancelled:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self unHighlightAllItem];
}


@end
