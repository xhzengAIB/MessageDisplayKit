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

@property (nonatomic, weak) UIView *currentSuperView;
@property (nonatomic, assign) CGPoint targetPoint;
@end

@implementation XHPopMenu

- (void)showMenuAtPoint:(CGPoint)point {
    [self showMenuOnView:[[UIApplication sharedApplication] keyWindow] atPoint:point];
}

- (void)showMenuOnView:(UIView *)view atPoint:(CGPoint)point {
    self.currentSuperView = view;
    self.targetPoint = point;
    [self showMenu];
}

#pragma mark - animation

- (void)showMenu {
    if (![self.currentSuperView.subviews containsObject:self]) {
        self.alpha = 1.0;
        self.transform = CGAffineTransformIdentity;
        [self.currentSuperView addSubview:self];
    } else {
        [self dissMissPopMenuAnimated:YES];
    }
}

- (void)dissMissPopMenuAnimated:(BOOL)animated {
    [UIView animateWithDuration:(animated ? 0.3 : 0) delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        if (animated) {
            self.alpha = 0.0;
            self.transform = CGAffineTransformMakeScale(0.3, 0.3);
        }
    } completion:^(BOOL finished) {
        [super removeFromSuperview];
    }];
}

#pragma mark - Propertys

- (UIImageView *)menuContainerView {
    if (!_menuContainerView) {
        UIImage *image = [UIImage imageNamed:@"MoreFunctionFrame"];
        UIImage *resizeImage = [image resizableImageWithCapInsets:UIEdgeInsetsMake(30, 10, 30, 50) resizingMode:UIImageResizingModeTile];
        _menuContainerView = [[UIImageView alloc] initWithImage:resizeImage];
        _menuContainerView.userInteractionEnabled = YES;
        _menuContainerView.frame = CGRectMake(CGRectGetWidth(self.bounds) - 140 - 6, 65, 140, self.menus.count * (35 + 0.5) + 7);
        
        [_menuContainerView addSubview:self.menuTableView];
    }
    return _menuContainerView;
}

- (UITableView *)menuTableView {
    if (!_menuTableView) {
        _menuTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 7, CGRectGetWidth(_menuContainerView.bounds), CGRectGetHeight(_menuContainerView.bounds) - 7) style:UITableViewStylePlain];
        _menuTableView.backgroundColor = [UIColor clearColor];
        _menuTableView.separatorColor = [UIColor clearColor];
        _menuTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _menuTableView.delegate = self;
        _menuTableView.dataSource = self;
        _menuTableView.rowHeight = 35;
        _menuTableView.scrollEnabled = NO;
    }
    return _menuTableView;
}

#pragma mark - Life Cycle

- (void)setup {
    self.frame = [[UIScreen mainScreen] bounds];
    self.backgroundColor = [UIColor clearColor];
    
    [self addSubview:self.menuContainerView];
}

- (id)initWithMenus:(NSArray *)menus {
    self = [super init];
    if (self) {
        self.menus = [[NSMutableArray alloc] initWithArray:menus];
        [self setup];
    }
    return self;
}

- (instancetype)initWithObjects:(id)firstObj, ... NS_REQUIRES_NIL_TERMINATION {
    self = [super init];
    if (self) {
        NSMutableArray *menuItems = [[NSMutableArray alloc] init];
        XHPopMenuItem *eachItem;
        va_list argumentList;
        if (firstObj) {
            [menuItems addObject:firstObj];
            va_start(argumentList, firstObj);
            while((eachItem = va_arg(argumentList, XHPopMenuItem *))) {
                [menuItems addObject:eachItem];
            }
            va_end(argumentList);
        }
        self.menus = menuItems;
        [self setup];
    }
    return self;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint localPoint = [touch locationInView:self];
    if (CGRectContainsPoint(self.menuTableView.frame, localPoint)) {
        [self hitTest:localPoint withEvent:event];
    } else {
        [self dissMissPopMenuAnimated:YES];
    }
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
    
    if (indexPath.row < self.menus.count) {
        [popMenuItemView setupPopMenuItem:self.menus[indexPath.row] atIndexPath:indexPath isBottom:(indexPath.row == self.menus.count - 1)];
    }
    
    return popMenuItemView;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self dissMissPopMenuAnimated:NO];
        });
    });
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.popMenuDidSlectedCompled) {
        self.popMenuDidSlectedCompled(indexPath.row, self.menus[indexPath.row]);
    }
}

@end
