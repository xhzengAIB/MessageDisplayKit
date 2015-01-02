//
//  MultiSelectedPanel.h
//  MultiSelectTableViewController
//
//  Created by molon on 6/8/14.
//  Copyright (c) 2014 molon. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MultiSelectedPanel;
@class MultiSelectItem;
@protocol MultiSelectedPanelDelegate <NSObject>

//本身想对此数组进行KVO的，想想还是算了。工作量不值得
- (void)willDeleteRowWithItem:(MultiSelectItem*)item withMultiSelectedPanel:(MultiSelectedPanel*)multiSelectedPanel;
- (void)didConfirmWithMultiSelectedPanel:(MultiSelectedPanel*)multiSelectedPanel;

@end

@interface MultiSelectedPanel : UIView

+ (instancetype)instanceFromNib;

@property (nonatomic, strong) NSMutableArray *selectedItems;
@property (nonatomic, weak) id<MultiSelectedPanelDelegate> delegate;

//数组有变化之后需要主动激活
- (void)didDeleteSelectedIndex:(NSUInteger)selectedIndex;
- (void)didAddSelectedIndex:(NSUInteger)selectedIndex;

@end
