//
//  XHBaseViewController.m
//  MessageDisplayExample
//
//  Created by qtone-1 on 14-5-6.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHBaseViewController.h"

@interface XHBaseViewController ()

@property (nonatomic, copy) XHBarButtonItemActionBlock barbuttonItemAction;

@end

@implementation XHBaseViewController

- (void)clickedBarButtonItemAction {
    if (self.barbuttonItemAction) {
        self.barbuttonItemAction();
    }
}

#pragma mark - Public Method

- (void)configureBarbuttonItemStyle:(XHBarbuttonItemStyle)style action:(XHBarButtonItemActionBlock)action {
    switch (style) {
        case XHBarbuttonItemStyleSetting: {
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"barbuttonicon_set"] style:UIBarButtonItemStyleBordered target:self action:@selector(clickedBarButtonItemAction)];
            break;
        }
        case XHBarbuttonItemStyleMore: {
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"barbuttonicon_more"] style:UIBarButtonItemStyleBordered target:self action:@selector(clickedBarButtonItemAction)];
            break;
        }
        case XHBarbuttonItemStyleCamera: {
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"album_add_photo"] style:UIBarButtonItemStyleBordered target:self action:@selector(clickedBarButtonItemAction)];
            break;
        }
        default:
            break;
    }
    self.barbuttonItemAction = action;
}

- (void)setupBackgroundImage:(UIImage *)backgroundImage {
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    backgroundImageView.image = backgroundImage;
    [self.view insertSubview:backgroundImageView atIndex:0];
}

- (void)pushNewViewController:(UIViewController *)newViewController {
    [self.navigationController pushViewController:newViewController animated:YES];
}

#pragma mark - Loading

- (void)showLoading {
    [self showLoadingWithText:nil];
}

- (void)showLoadingWithText:(NSString *)text {
    [self showLoadingWithText:text onView:self.view];
}

- (void)showLoadingWithText:(NSString *)text onView:(UIView *)view {
    
}

- (void)showSuccess {
    
}
- (void)showError {
    
}

- (void)hideLoading {
    
}

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - View rotation

- (BOOL)shouldAutorotate {
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

@end
