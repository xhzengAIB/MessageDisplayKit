//
//  SCCommon.h
//  SCCaptureCameraDemo
//
//  Created by Aevitx on 14-1-19.
//  Copyright (c) 2014年 Aevitx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCCommon : NSObject


+ (UIImage*)createImageWithColor:(UIColor*)color size:(CGSize)imageSize;

+ (void)drawALineWithFrame:(CGRect)frame andColor:(UIColor*)color inLayer:(CALayer*)parentLayer;

+ (void)saveImageToPhotoAlbum:(UIImage*)image;

@end
