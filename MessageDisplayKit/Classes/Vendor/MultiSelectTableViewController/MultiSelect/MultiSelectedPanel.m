//
//  MultiSelectedPanel.m
//  MultiSelectTableViewController
//
//  Created by molon on 6/8/14.
//  Copyright (c) 2014 molon. All rights reserved.
//

#import "MultiSelectedPanel.h"
#import "MultiSelectItem.h"
#import "UIView+XHRemoteImage.h"
#import <QuartzCore/QuartzCore.h>


@interface MultiSelectedPanel()<UITableViewDataSource,UITabBarControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *bkgImageView;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;


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
    
    self.tableView.scrollsToTop = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.transform = CGAffineTransformMakeRotation(M_PI*1.5);
    
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
    
    [self.tableView reloadData];
    
    [self updateConfirmButton];
}

#pragma mark - tableview datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.selectedItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MultiSelectedPanelTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.transform = CGAffineTransformMakeRotation(M_PI*0.5f);
        
        //添加一个imageView
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(2.0f, 0.0f, 36.0f, 36.0f)];
        imageView.tag = 999;
        imageView.layer.cornerRadius = 4.0f;
        imageView.clipsToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [cell.contentView addSubview:imageView];
    }
    
    UIImageView *imageView = (UIImageView*)[cell.contentView viewWithTag:999];
    
    MultiSelectItem *item = self.selectedItems[indexPath.row];
    
    imageView.image = nil;
    [imageView setImageWithURL:item.imageURL];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MultiSelectItem *item = self.selectedItems[indexPath.row];
    //删除某元素,实际上是告诉delegate去删除
    if (self.delegate&&[self.delegate respondsToSelector:@selector(willDeleteRowWithItem:withMultiSelectedPanel:)]) {
        [self.delegate willDeleteRowWithItem:item withMultiSelectedPanel:self];
    }
    //确定没了删掉
    if ([self.selectedItems indexOfObject:item]==NSNotFound) {
        [self updateConfirmButton];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark - out call
- (void)didDeleteSelectedIndex:(NSUInteger)selectedIndex
{
    [self updateConfirmButton];
    //执行删除操作
    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:selectedIndex inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    
}

- (void)didAddSelectedIndex:(NSUInteger)selectedIndex
{
    //找到index
    if (selectedIndex<self.selectedItems.count) {
        [self updateConfirmButton];
        //执行插入操作
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}
@end
