//
//  XHDisplayLocationViewController.m
//  MessageDisplayExample
//
//  Created by HUAJIE-1 on 14-5-6.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHDisplayLocationViewController.h"
#import "XHAnnotation.h"

@interface XHDisplayLocationViewController () <MKMapViewDelegate>

@property (nonatomic, strong) MKMapView *mapView;

@end

@implementation XHDisplayLocationViewController

- (MKMapView *)mapView {
    if (!_mapView) {
        _mapView = [[MKMapView alloc] initWithFrame:self.view.frame];
    }
    return _mapView;
}

- (void)loadLocations {
    CLLocationCoordinate2D coord = [self.message.location coordinate];
    CLRegion *newRegion = [[CLRegion alloc] initCircularRegionWithCenter:coord
                                                                  radius:10.0
                                                              identifier:[NSString stringWithFormat:@"%f, %f", coord.latitude, coord.longitude]];
    
    // Create an annotation to show where the region is located on the map.
    XHAnnotation *myRegionAnnotation = [[XHAnnotation alloc] initWithCLRegion:newRegion title:NSLocalizedStringFromTable(@"MessageLocation", @"MessageDisplayKitString", nil) subtitle:self.message.geolocations];
    myRegionAnnotation.coordinate = newRegion.center;
    myRegionAnnotation.radius = newRegion.radius;
    
    [self.mapView addAnnotation:myRegionAnnotation];

    //放大到标注的位置
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coord, 150, 150);
    [self.mapView setRegion:region animated:YES];
}

#pragma mark - Life cycle

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self loadLocations];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedStringFromTable(@"Location", @"MessageDisplayKitString", @"地理位置");
    
    [self.view addSubview:self.mapView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    self.mapView = nil;
}

@end
