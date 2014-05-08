//
//  XHPhotographyHelper.m
//  MessageDisplayExample
//
//  Created by qtone-1 on 14-5-3.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHPhotographyHelper.h"

@interface XHPhotographyHelper () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, copy) DidFinishTakeMediaCompledBlock didFinishTakeMediaCompled;
@property (nonatomic, weak) UIViewController *presenViewController;

@end

@implementation XHPhotographyHelper

- (instancetype)initWithViewController:(UIViewController *)viewController didFinishTakeMediaCompledBlock:(DidFinishTakeMediaCompledBlock)didFinishTakeMediaCompled {
    self = [super init];
    if (self) {
        self.presenViewController = viewController;
        self.didFinishTakeMediaCompled = didFinishTakeMediaCompled;
    }
    return self;
}

- (void)showOnPickerViewControllerSourceType:(UIImagePickerControllerSourceType)sourceType {
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.editing = YES;
    imagePickerController.delegate = self;
    imagePickerController.sourceType = sourceType;
    imagePickerController.mediaTypes =  [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
    [self.presenViewController presentViewController:imagePickerController animated:YES completion:NULL];
}

- (void)dismissPickerViewController:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
    [self dismissPickerViewController:picker];
    if (self.didFinishTakeMediaCompled) {
        self.didFinishTakeMediaCompled(image, editingInfo);
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [self dismissPickerViewController:picker];
    if (self.didFinishTakeMediaCompled) {
        self.didFinishTakeMediaCompled(nil, info);
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissPickerViewController:picker];
}

@end
