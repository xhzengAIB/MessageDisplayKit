//
//  XHDisplayPhotoViewController.m
//  MessageDisplayExample
//
//  Created by qtone-1 on 14-5-6.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHDisplayPhotoViewController.h"

#import "UIView+XHNetworkImage.h"

@interface XHDisplayPhotoViewController ()

@property (nonatomic, weak) UIImageView *photoImageView;

@end

@implementation XHDisplayPhotoViewController

- (UIImageView *)photoImageView {
    if (!_photoImageView) {
        UIImageView *photoImageView = [[UIImageView alloc] initWithFrame:self.view.frame];
        [self.view addSubview:photoImageView];
        _photoImageView = photoImageView;
    }
    return _photoImageView;
}

- (void)setMessage:(id<XHMessageModel>)message {
    _message = message;
    self.photoImageView.image = message.photo;
    if (message.thumbnailUrl) {
        [self.photoImageView setImageUrl:[message thumbnailUrl]];
    }
}

#pragma mark - Left cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"Photo", @"详细照片");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
