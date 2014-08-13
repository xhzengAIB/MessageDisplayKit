//
//  UIView+XHRemoteImage.m
//  MessageDisplayExample
//
//  Created by 曾 宪华 on 14-5-30.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "UIView+XHRemoteImage.h"

#import <objc/runtime.h>

#import "XHCacheManager.h"

const char* const kXHURLPropertyKey   = "XHURLDownloadURLPropertyKey";
const char* const kXHLoadingStateKey  = "XHURLDownloadLoadingStateKey";
const char* const kXHLoadingViewKey   = "XHURLDownloadLoadingViewKey";

const char* const kXHActivityIndicatorViewKey   = "XHActivityIndicatorViewKey";

const char* const kXHMessageAvatorTypeKey   = "XHMessageAvatorTypeKey";

#define kXHActivityIndicatorViewSize 35

@implementation UIView (XHRemoteImage)

+ (id)imageViewWithURL:(NSURL *)url autoLoading:(BOOL)autoLoading {
    UIImageView *view = [self new];
    view.url = url;
    if(autoLoading) {
        [view load];
    }
    return view;
}

+ (id)indicatorImageView {
    UIImageView *view = [self new];
    [view setDefaultLoadingView];
    
    return view;
}

+ (id)indicatorImageViewWithURL:(NSURL *)url autoLoading:(BOOL)autoLoading {
    UIImageView *view = [self imageViewWithURL:url autoLoading:autoLoading];
    [view setDefaultLoadingView];
    
    return view;
}

#pragma mark- Properties

- (dispatch_queue_t)cachingQueue {
    static dispatch_queue_t cachingQeueu;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cachingQeueu = dispatch_queue_create("caching image and data", NULL);
    });
    return cachingQeueu;
}

- (void)setActivityIndicatorView:(UIActivityIndicatorView *)activityIndicatorView {
    objc_setAssociatedObject(self, kXHActivityIndicatorViewKey, activityIndicatorView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIActivityIndicatorView *)activityIndicatorView {
    return objc_getAssociatedObject(self, kXHActivityIndicatorViewKey);
}

- (void)setMessageAvatorType:(XHMessageAvatorType)messageAvatorType {
    objc_setAssociatedObject(self, &kXHMessageAvatorTypeKey, [NSNumber numberWithInteger:messageAvatorType], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (XHMessageAvatorType)messageAvatorType {
    return (XHMessageAvatorType)([objc_getAssociatedObject(self, &kXHMessageAvatorTypeKey) integerValue]);
}

- (NSURL*)url {
    return objc_getAssociatedObject(self, kXHURLPropertyKey);
}

- (void)setUrl:(NSURL *)url {
    [self setImageUrl:url autoLoading:NO];
}

- (void)setImageUrl:(NSURL *)url autoLoading:(BOOL)autoLoading {
    if(![url isEqual:self.url]) {
        objc_setAssociatedObject(self, kXHURLPropertyKey, url, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        if (url) {
            self.loadingState = UIImageViewURLDownloadStateWaitingForLoad;
        }
        else {
            self.loadingState = UIImageViewURLDownloadStateUnknown;
        }
    }
    
    if(autoLoading) {
        [self load];
    }
}

- (void)setImageWithURL:(NSURL *)url {
    [self setImageWithURL:url placeholer:nil];
}

- (void)setImageWithURL:(NSURL *)url placeholer:(UIImage *)placeholerImage {
    [self setImageWithURL:url placeholer:placeholerImage showActivityIndicatorView:NO];
}

- (void)setImageWithURL:(NSURL *)url placeholer:(UIImage *)placeholerImage showActivityIndicatorView:(BOOL)show {
    [self _setupPlaecholerImage:placeholerImage showActivityIndicatorView:show];
    [self setImageUrl:url autoLoading:YES];
}

- (void)setImageWithURL:(NSURL *)url placeholer:(UIImage *)placeholerImage showActivityIndicatorView:(BOOL)show completionBlock:(void(^)(UIImage *image, NSURL *url, NSError *error))handler {
    [self _setupPlaecholerImage:placeholerImage showActivityIndicatorView:show];
    [self setImageUrl:url autoLoading:NO];
    [self loadWithCompletionBlock:handler];
}

- (void)_setupPlaecholerImage:(UIImage *)placeholerImage showActivityIndicatorView:(BOOL)show {
    if (placeholerImage) {
        [self setupImage:placeholerImage];
    }
    if (show) {
        UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityIndicatorView.frame = CGRectMake(0, 0, kXHActivityIndicatorViewSize, kXHActivityIndicatorViewSize);
        activityIndicatorView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
        activityIndicatorView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [activityIndicatorView startAnimating];
        [self addSubview:activityIndicatorView];
        [self setActivityIndicatorView:activityIndicatorView];
    }
}

- (UIImageViewURLDownloadState)loadingState {
    return (NSUInteger)([objc_getAssociatedObject(self, kXHLoadingStateKey) integerValue]);
}

- (void)setLoadingState:(UIImageViewURLDownloadState)loadingState {
    objc_setAssociatedObject(self, kXHLoadingStateKey, @(loadingState), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)loadingView {
    return objc_getAssociatedObject(self, kXHLoadingViewKey);
}

- (void)setLoadingView:(UIView *)loadingView {
    [self.loadingView removeFromSuperview];
    
    objc_setAssociatedObject(self, kXHLoadingViewKey, loadingView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    loadingView.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    loadingView.alpha  = 0;
    [self addSubview:loadingView];
}

- (void)setDefaultLoadingView {
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.frame = self.frame;
    indicator.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    indicator.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    self.loadingView = indicator;
}

#pragma mark - Setup Image

- (void)setupImage:(UIImage *)image {
    if ([self isKindOfClass:[UIButton class]]) {
        UIButton *currentButton = (UIButton *)self;
        [currentButton setImage:image forState:UIControlStateNormal];
    } else if ([self isKindOfClass:[UIImageView class]]) {
        UIImageView *currentImageView = (UIImageView *)self;
        currentImageView.image = image;
    }
}

#pragma mark- Loading view

- (void)showLoadingView {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.loadingView.alpha = 1;
        if([self.loadingView respondsToSelector:@selector(startAnimating)]) {
            [self.loadingView performSelector:@selector(startAnimating)];
        }
    });
}

- (void)hideLoadingView {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIActivityIndicatorView *activityIndicatorView = [self activityIndicatorView];
        if (activityIndicatorView) {
            [activityIndicatorView stopAnimating];
            [activityIndicatorView removeFromSuperview];
        }
        [UIView animateWithDuration:0.3
                         animations:^{
                             self.loadingView.alpha = 0;
                         }
                         completion:^(BOOL finished) {
                             if([self.loadingView respondsToSelector:@selector(stopAnimating)]) {
                                 [self.loadingView performSelector:@selector(stopAnimating)];
                             }
                         }
         ];
    });
}

#pragma mark- Image downloading

+ (NSOperationQueue *)downloadQueue {
    static NSOperationQueue *_sharedQueue = nil;
    
    if(_sharedQueue == nil) {
        _sharedQueue = [NSOperationQueue new];
        [_sharedQueue setMaxConcurrentOperationCount:3];
    }
    
    return _sharedQueue;
}

+ (void)dataWithContentsOfURL:(NSURL *)url completionBlock:(void (^)(NSURL *, NSData *, NSError *))completion {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:5.0];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[self downloadQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               if(completion) {
                                   completion(url, data, connectionError);
                               }
                           }
     ];
}

- (void)load {
    [self loadWithCompletionBlock:nil];
}

- (void)loadWithCompletionBlock:(void(^)(UIImage *image, NSURL *url, NSError *error))handler {
    self.loadingState = UIImageViewURLDownloadStateNowLoading;
    
    [self showLoadingView];
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(self.cachingQueue, ^{
        UIImage *cacheImage = [XHCacheManager imageWithURL:weakSelf.url storeMemoryCache:YES];
        if (weakSelf.messageAvatorType != XHMessageAvatorTypeNormal) {
            cacheImage = [XHMessageAvatorFactory avatarImageNamed:cacheImage messageAvatorType:weakSelf.messageAvatorType];
        }
        if (cacheImage) {
            [weakSelf setImage:cacheImage forURL:weakSelf.url];
            if (handler)
                handler(cacheImage, weakSelf.url, nil);
        } else {
            // It could be more better by replacing with a method that has delegates like a progress.
            [UIImageView dataWithContentsOfURL:weakSelf.url
                               completionBlock:^(NSURL *url, NSData *data, NSError *error) {
                                   UIImage *image = [weakSelf didFinishDownloadWithData:data forURL:url error:error];
                                   
                                   if(handler) {
                                       handler(image, url, error);
                                   }
                               }
             ];
        }
    });
}

- (void)cachingImageData:(NSData *)imageData url:(NSURL *)url {
    dispatch_async(self.cachingQueue, ^{
        if (imageData) {
            [XHCacheManager storeData:imageData forURL:url storeMemoryCache:NO];
            UIImage *image = [UIImage imageWithData:imageData];
            if (image)
                [XHCacheManager storeMemoryCacheWithImage:image forURL:url];
        }
    });
}

- (UIImage *)didFinishDownloadWithData:(NSData *)data forURL:(NSURL *)url error:(NSError *)error {
    if (data) {
        [self cachingImageData:data url:url];
    }
    UIImage *image = [UIImage imageWithData:data];
    if (self.messageAvatorType != XHMessageAvatorTypeNormal) {
        image = [XHMessageAvatorFactory avatarImageNamed:image messageAvatorType:self.messageAvatorType];
    }
    if([url isEqual:self.url]) {
        if(error) {
            self.loadingState = UIImageViewURLDownloadStateFailed;
        } else {
            [self performSelectorOnMainThread:@selector(setupImage:) withObject:image waitUntilDone:NO];
            self.loadingState = UIImageViewURLDownloadStateLoaded;
        }
        [self hideLoadingView];
    }
    return image;
}

- (void)setImage:(UIImage *)image forURL:(NSURL *)url {
    if([url isEqual:self.url]) {
        [self performSelectorOnMainThread:@selector(setupImage:) withObject:image waitUntilDone:NO];
        self.loadingState = UIImageViewURLDownloadStateLoaded;
        [self hideLoadingView];
    }
}

@end
