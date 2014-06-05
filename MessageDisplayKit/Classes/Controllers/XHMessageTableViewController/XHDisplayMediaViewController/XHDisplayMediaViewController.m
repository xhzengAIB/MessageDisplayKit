//
//  XHDisplayMediaViewController.m
//  MessageDisplayExample
//
//  Created by qtone-1 on 14-5-6.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHDisplayMediaViewController.h"
#import <MediaPlayer/MediaPlayer.h>

#import "UIView+XHRemoteImage.h"

@interface XHDisplayMediaViewController ()

@property (nonatomic, strong) MPMoviePlayerController *moviePlayerController;

@property (nonatomic, weak) UIImageView *photoImageView;

@end

@implementation XHDisplayMediaViewController

- (MPMoviePlayerController *)moviePlayerController {
    if (!_moviePlayerController) {
        _moviePlayerController = [[MPMoviePlayerController alloc] init];
        _moviePlayerController.repeatMode = MPMovieRepeatModeOne;
        _moviePlayerController.scalingMode = MPMovieScalingModeAspectFill;
        _moviePlayerController.view.frame = self.view.frame;
        [self.view addSubview:_moviePlayerController.view];
    }
    return _moviePlayerController;
}

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
    if ([message messageMediaType] == XHBubbleMessageMediaTypeVideo) {
        self.title = NSLocalizedStringFromTable(@"Video", @"MessageDisplayKitString", @"详细视频");
        self.moviePlayerController.contentURL = [NSURL fileURLWithPath:[message videoPath]];
        [self.moviePlayerController play];
    } else if ([message messageMediaType] ==XHBubbleMessageMediaTypePhoto) {
        self.title = NSLocalizedStringFromTable(@"Photo", @"MessageDisplayKitString", @"详细照片");
        self.photoImageView.image = message.photo;
        if (message.thumbnailUrl) {
            [self.photoImageView setImageWithURL:[NSURL URLWithString:[message thumbnailUrl]] placeholer:[UIImage imageNamed:@"placeholderImage"]];
        }
    }
}

#pragma mark - Life cycle

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([self.message messageMediaType] == XHBubbleMessageMediaTypeVideo) {
        [self.moviePlayerController stop];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_moviePlayerController stop];
    _moviePlayerController = nil;
    
    _photoImageView = nil;
}

@end
