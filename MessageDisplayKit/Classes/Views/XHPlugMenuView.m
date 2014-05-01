//
//  XHPlugMenuView.m
//  MessageDisplayExample
//
//  Created by qtone-1 on 14-4-30.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHPlugMenuView.h"

#import "XHPlugMenuCollectionViewFlowLayout.h"
#import "XHPlugMenuCollectionViewCell.h"

#define kXHPageControlHeight 30

@interface XHPlugMenuView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, weak) UICollectionView *plugMenuCollectionView;
@property (nonatomic, weak) UIPageControl *plugMenuPageControl;

@property (nonatomic, strong) NSArray *plugItems;

@end

@implementation XHPlugMenuView

- (void)reloadDataWithPlugItems:(NSArray *)plugItems {
    self.plugItems = plugItems;
    
    if (!self.plugItems.count)
        return;
    
    self.plugMenuPageControl.numberOfPages = (self.plugItems.count / (kXHPlugPerRowItemCount * 2) + (self.plugItems.count % (kXHPlugPerRowItemCount * 2) ? 1 : 0));
    [self.plugMenuCollectionView reloadData];
}

#pragma mark - Propertys

- (NSArray *)plugItems {
    if (!_plugItems) {
        _plugItems = [[NSArray alloc] init];
    }
    return _plugItems;
}

#pragma mark - Life cycle

- (void)setup {
    self.backgroundColor = [UIColor grayColor];
    
    if (!_plugMenuCollectionView) {
        UICollectionView *plugMenuCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - kXHPageControlHeight) collectionViewLayout:[[XHPlugMenuCollectionViewFlowLayout alloc] init]];
        plugMenuCollectionView.backgroundColor = self.backgroundColor;
        [plugMenuCollectionView registerClass:[XHPlugMenuCollectionViewCell class] forCellWithReuseIdentifier:kXHPlugMenuCollectionViewCellIdentifer];
        plugMenuCollectionView.showsHorizontalScrollIndicator = NO;
        plugMenuCollectionView.showsVerticalScrollIndicator = NO;
        [plugMenuCollectionView setScrollsToTop:NO];
        plugMenuCollectionView.pagingEnabled = YES;
        plugMenuCollectionView.delegate = self;
        plugMenuCollectionView.dataSource = self;
        [self addSubview:plugMenuCollectionView];
        self.plugMenuCollectionView = plugMenuCollectionView;
    }
    
    
    if (!_plugMenuPageControl) {
        UIPageControl *plugMenuPageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.plugMenuCollectionView.frame), CGRectGetWidth(self.bounds), kXHPageControlHeight)];
        plugMenuPageControl.hidesForSinglePage = YES;
        plugMenuPageControl.defersCurrentPageDisplay = YES;
        [self addSubview:plugMenuPageControl];
        self.plugMenuPageControl = plugMenuPageControl;
    }
}

- (void)awakeFromNib {
    [self setup];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}

#pragma mark - UIScrollView delegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate  {
    
}

#pragma UICollectionView DataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger count = self.plugItems.count;
    return count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XHPlugMenuCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kXHPlugMenuCollectionViewCellIdentifer forIndexPath:indexPath];
    
    cell.plugItem = self.plugItems[indexPath.row];
    
    return cell;
}

#pragma mark - UICollectionView delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
