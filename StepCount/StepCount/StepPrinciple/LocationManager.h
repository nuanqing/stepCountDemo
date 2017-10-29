//
//  LocationManager.h
//  StepCount
//
//  Created by webplus on 16/4/21.
//  Copyright © 2016年 webplus. All rights reserved.
//
//导入框架
#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
//定位的代理方法
@interface LocationManager : NSObject<CLLocationManagerDelegate>
//成员变量
@property (strong,nonatomic) CLLocationManager *locationManager;
@property (strong,nonatomic) CLLocation *location;
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic) BOOL allowsBackground;
//设置定位方法单利（全局访问只进行一次初始化）
+(LocationManager *)sharedInstance;
//开始定位
-(void)startLocation;
//开始标记位置定位
-(void)startSignLocation;
//停止定位
-(void)stopLocation;
//停止标记位置定位
-(void)stopSignLocation;



@end
