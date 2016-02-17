//
//  ViewController.m
//  Location
//
//  Created by 杨 on 16/2/17.
//  Copyright © 2016年 杨. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>

#import <MapKit/MapKit.h>

@interface ViewController ()<CLLocationManagerDelegate>
@property (nonatomic,retain)CLLocationManager *locationManager;
@property (nonatomic,strong)CLGeocoder *geocoder;
@end

@implementation ViewController
{
    CLLocation *currentLocation;
}
- (void)reverseGeocode:(CLLocation *)locations{
    
    if (currentLocation == nil) {
        NSLog(@"location is nil;");
    }
    else{
        NSLog(@"location is not nil" );
    }
    [self.geocoder reverseGeocodeLocation:locations completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (error||placemarks.count == 0) {
            NSLog(@"error:%@",error.description);
        }
        else{
            for (CLPlacemark *placemark in placemarks) {
                NSLog(@"cityname:%@",placemark.locality);
            }
        }
    }];
}

- (CLGeocoder *)geocoder{
    if (!_geocoder) {
        self.geocoder = [CLGeocoder new];
    }
    return _geocoder;
}

- (CLLocationManager *)locationManager{
    if (!_locationManager) {
        _locationManager = [CLLocationManager new];
        _locationManager.delegate = self;
    }
    return _locationManager;
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    if (error.code == kCLErrorDenied) {
        NSLog(@"failed error");
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    currentLocation = [locations lastObject];
    NSLog(@"weizhi:%f,%f",currentLocation.coordinate.latitude,currentLocation.coordinate.longitude);

//    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
//    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
//        if (placemarks.count>0) {
//            CLPlacemark *placemark = [placemarks objectAtIndex:0];
//            NSLog(@"%@",placemark.name);
//            NSLog(@"city:%@",placemark.locality);
//            if (!placemark.locality) {
//                NSLog(@"zhixiashi:%@",placemark.administrativeArea);
//            }
//        }
//        else if (error == nil&&[placemarks count] == 0){
//            NSLog(@"no result");
//        }
//        else if (error != nil){
//            NSLog(@"error:%@",error.description);
//        }
//    }];
    [manager stopUpdatingLocation];
}

- (void)locate{
    if ([CLLocationManager locationServicesEnabled]) {
        self.locationManager = [[CLLocationManager alloc]init];
        self.locationManager.delegate = self;
    }
    else{
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"recommand" message:@"failed" delegate:nil cancelButtonTitle:@"cancel" otherButtonTitles:@"ok", nil];
        [alertView show];
    }
    [self.locationManager startUpdatingLocation];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self locate];
    [_locationManager requestAlwaysAuthorization];
    CGFloat lati = 37.326914;
    CGFloat longti = 120.019733;
    CLLocation *myLocation = [[CLLocation alloc]initWithLatitude:lati longitude:longti];
    [self reverseGeocode:myLocation];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(100, 100, 100, 50);
    [button setTitle:@"click" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(clickButton) forControlEvents:UIControlEventTouchUpInside];
//    [self performSelector:@selector(reverseGeocode:) withObject:currentLocation afterDelay:2.0f];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)clickButton{
    CLLocation *location = [[CLLocation alloc]initWithLatitude:currentLocation.coordinate.latitude longitude:(currentLocation.coordinate.longitude+210)];
    NSLog(@"--");
    NSLog(@"%f,%f",currentLocation.coordinate.latitude,currentLocation.coordinate.longitude+210);
    [self reverseGeocode:location];
    NSLog(@"--");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
