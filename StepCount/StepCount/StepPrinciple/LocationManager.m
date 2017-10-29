//
//  LocationManager.m
//  StepCount
//
//  Created by webplus on 16/4/21.
//  Copyright © 2016年 webplus. All rights reserved.
//

#import "LocationManager.h"

@implementation LocationManager
{
     NSMutableArray *locationarr;
}
//对定位方法初始化
-(id)init
{
    self = [super init];
    if (self) {
        self.locationManager = [[CLLocationManager alloc]init];
        //定位的精确度为最高(会加重耗电)
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        //定位的波动范围（设为默认值，默认为每当位置改变时调用一次代理方法）
        self.locationManager.distanceFilter = kCLDistanceFilterNone;
        //遵循代理协议
        self.locationManager.delegate = self;
        
        locationarr = [[NSMutableArray alloc]init];
    }
    return self;
}
//创建单利
+(LocationManager *)sharedInstance
{
     static LocationManager *location = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        location = [[self alloc]init];
    });
    return location;
}
//开始定位(后台也能定位)
-(void)startLocation
{
    if (self.allowsBackground) {
        if ([self.locationManager respondsToSelector:@selector(setAllowsBackground:)]) {
            [self.locationManager setAllowsBackgroundLocationUpdates:YES];
        }
    }
    //开始定位
    [self.locationManager startUpdatingLocation];
    
}

//停止调用地理位置
-(void)stopLocation
{
    [self.locationManager stopUpdatingLocation];
}
-(void)setAllowsBackground:(BOOL)allowsBackground
{
    _allowsBackground = allowsBackground;
    if ([self.locationManager respondsToSelector:@selector(setAllowsBackground:)]) {
        [self.locationManager setAllowsBackgroundLocationUpdates:allowsBackground];
    }
}
//定位的代理方法
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    if (manager == self.locationManager) {
        //获取地理位置
        CLLocation *location = [locations lastObject];
        [locationarr addObject:location];
        NSDictionary *dict =@{@"locationarr":locationarr};
        //注册通知（成功定位时调用）
        [[NSNotificationCenter defaultCenter] postNotificationName:LOCATIONCHANGE object:self userInfo:dict];
    }
}
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSDictionary *dict = @{@"error":error};
    //注册通知(定位失败时调用)
    [[NSNotificationCenter defaultCenter]postNotificationName:LOCATIONFAIL object:error userInfo:dict];
}
//当授权状态改变时调用
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    //如果状态为没有授权,提示授权 (这里有两种状态1.使用时开启定位2.总是开启定位)
    if (status == kCLAuthorizationStatusNotDetermined&&[self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        //使用时打开
       // [self.locationManager requestWhenInUseAuthorization];
        //这里要后台定位，所以为总是打开的状态，否则会出现退出app是头部一直闪蓝条
        [self.locationManager requestAlwaysAuthorization];
    }
    NSDictionary *dict = @{@"status":@(status)};
    [[NSNotificationCenter defaultCenter]postNotificationName:LOCATIONSTATE object:self userInfo:dict];
}
//停止定位
-(void)locationManagerDidPauseLocationUpdates:(CLLocationManager *)manager
{
    [[NSNotificationCenter defaultCenter] postNotificationName:LOCATIONPAUSE
                                                        object:self];
}


@end
