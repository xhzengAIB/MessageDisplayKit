//
//  MultiSelectedPanel.m
//  MultiSelectTableViewController
//
//  Created by molon on 6/8/14.
//  Copyright (c) 2014 molon. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "MultiSelectedPanel.h"

#import "MultiSelectItem.h"

#import <MessageDisplayKit/UIView+XHRemoteImage.h>


@interface MultiSelectedPanel()<UITabBarControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,
                                UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *bkgImageView;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;


//@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic)IBOutlet UICollectionView  *collectionView;


@end

@implementation MultiSelectedPanel






+ (instancetype)instanceFromNib
{
    return [[[NSBundle mainBundle]loadNibNamed:@"MultiSelectedPanel" owner:nil options:nil]lastObject];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setUp];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setUp
{
    self.autoresizingMask = UIViewAutoresizingNone;
    
    self.bkgImageView.image = [[UIImage imageNamed:@"MultiSelectedPanelBkg"]resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    
    
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"MultiSelectedPanelTableViewCell"];
    self.collectionView.showsHorizontalScrollIndicator =  NO;
    self.collectionView.dataSource = self;
    self.collectionView.delegate =  self;
    

    
    [self.confirmBtn setTitle:@"确认(0)" forState:UIControlStateNormal];
    self.confirmBtn.enabled = NO;
    [self.confirmBtn setBackgroundImage:[[UIImage imageNamed:@"MultiSelectedPanelConfirmBtnbKG"] resizableImageWithCapInsets:UIEdgeInsetsMake(8, 8, 8, 8)] forState:UIControlStateNormal];
}

- (void)updateConfirmButton
{
    int count = (int)_selectedItems.count;
    self.confirmBtn.enabled = count>0;
    
    [self.confirmBtn setTitle:[NSString stringWithFormat:@"确认(%d)",count] forState:UIControlStateNormal];
}

- (IBAction)confirmBtnPressed:(id)sender {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(didConfirmWithMultiSelectedPanel:)]) {
        [self.delegate didConfirmWithMultiSelectedPanel:self];
    }
}

#pragma mark - setter
- (void)setSelectedItems:(NSMutableArray *)selectedItems
{
    _selectedItems = selectedItems;
    
    [self.collectionView reloadData];
    
    [self updateConfirmButton];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.selectedItems.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MultiSelectedPanelTableViewCell";

    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    
    
    //添加一个imageView
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(2.0f, 0.0f, 36.0f, 36.0f)];
    imageView.tag = 999;
    imageView.layer.cornerRadius = 4.0f;
    imageView.clipsToBounds = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [cell.contentView addSubview:imageView];
 
    
//    UIImageView *imageView = (UIImageView*)[cell.contentView viewWithTag:999];
    
    MultiSelectItem *item = self.selectedItems[indexPath.row];
    [imageView setImageWithURL:item.imageURL];
    
    return cell;
}



#pragma mark --     UICollectionViewDelegateFlowLayout
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(36.0f, 36.0f);
}

#pragma mark  -- UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    MultiSelectItem *item = self.selectedItems[indexPath.row];
    //删除某元素,实际上是告诉delegate去删除
    if (self.delegate&&[self.delegate respondsToSelector:@selector(willDeleteRowWithItem:withMultiSelectedPanel:)]) { //委托给控制器   删除列表中item
        [self.delegate willDeleteRowWithItem:item withMultiSelectedPanel:self];
    }
    
    
    //确定没了删掉
    if ([self.selectedItems indexOfObject:item]==NSNotFound) {
        [self updateConfirmButton];
        
        [collectionView deleteItemsAtIndexPaths:@[indexPath]];
        //[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    
}


#pragma mark - out call
- (void)didDeleteSelectedIndex:(NSUInteger)selectedIndex
{
    [self updateConfirmButton];
    //执行删除操作
    //[self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:selectedIndex inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    [self.collectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:selectedIndex inSection:0]]];
}

- (void)didAddSelectedIndex:(NSUInteger)selectedIndex
{
    //找到index
    if (selectedIndex<self.selectedItems.count) {
        [self updateConfirmButton];
        //执行插入操作
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
        //[self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.collectionView insertItemsAtIndexPaths:@[indexPath]];
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
        
        //[self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}
@end
