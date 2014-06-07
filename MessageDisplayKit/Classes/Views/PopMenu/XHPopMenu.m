//
//  XHPopMenu.m
//  MessageDisplayExample
//
//  Created by dw_iOS on 14-6-7.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHPopMenu.h"

#import "XHPopMenuItemView.h"

@interface XHPopMenu () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIImageView *menuContainerView;

@property (nonatomic, strong) UITableView *menuTableView;
@property (nonatomic, strong) NSMutableArray *menus;
@end

@implementation XHPopMenu

- (void)showMenuAtPoint:(CGPoint)point {
    [self showMenuAtPoint:CGPointZero];
}

- (void)showMenuOnView:(UIView *)view atPoint:(CGPoint)point {
    
}

#pragma mark - animation

- (void)showMenu {
    
}

- (void)dissMissPopMenu {
    
}

#pragma mark - Propertys

- (UIImageView *)menuContainerView {
    if (!_menuContainerView) {
        UIImage *image = [UIImage imageNamed:@"MoreFunctionFrame"];
        UIImage *resizeImage = [image resizableImageWithCapInsets:UIEdgeInsetsMake(30, 10, 30, 50)];
        _menuContainerView = [[UIImageView alloc] initWithImage:resizeImage];
        _menuContainerView.frame = CGRectMake(175, 63, 140, 230);
        
        [_menuContainerView addSubview:self.menuTableView];
    }
    return _menuContainerView;
}

- (UITableView *)menuTableView {
    if (!_menuTableView) {
        _menuTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 7, CGRectGetWidth(_menuContainerView.bounds), CGRectGetHeight(_menuContainerView.bounds) - 7) style:UITableViewStylePlain];
        _menuTableView.separatorColor = [UIColor clearColor];
        _menuTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _menuTableView.delegate = self;
        _menuTableView.dataSource = self;
        _menuTableView.rowHeight = 35;
    }
    return _menuTableView;
}

#pragma mark - Life Cycle

- (void)setup {
    self.frame = [[UIScreen mainScreen] bounds];
    self.backgroundColor = [UIColor clearColor];
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dissMissPopMenu)]];
    
    [self addSubview:self.menuContainerView];
}

- (id)initWithMenus:(NSArray *)menus {
    self = [super init];
    if (self) {
        self.menus = [NSMutableArray arrayWithArray:menus];
        [self setup];
    }
    return self;
}

- (instancetype)initWithObjects:(id)firstObj, ... NS_REQUIRES_NIL_TERMINATION {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.menus.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifer = @"cellIdentifer";
    XHPopMenuItemView *popMenuItemView = (XHPopMenuItemView *)[tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if (!popMenuItemView) {
        popMenuItemView = [[XHPopMenuItemView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
    }
    
    if (indexPath.row < self.menus.count)
        popMenuItemView.popMenuItem = self.menus[indexPath.row];
    
    return popMenuItemView;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
