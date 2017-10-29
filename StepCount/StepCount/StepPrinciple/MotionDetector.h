//
//  MotionDetector.h
//  StepCount
//
//  Created by webplus on 16/4/21.
//  Copyright © 2016年 webplus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MotionDetector.h"
#import <CoreMotion/CoreMotion.h>
#import "LocationManager.h"

@class MotionDetector;
typedef enum
{
    MotionTypeNotMoving,
    MotionTypeWalking,
    MotionTypeRunning,
    MotionTypeOhter
} MotionType;
@protocol MotionDetectorDelegate<NSObject>
@optional
- (void)motionDetector:(MotionDetector *)motionDetector motionTypeChanged:(MotionType)motionType;
- (void)motionDetector:(MotionDetector *)motionDetector locationChanged:(CLLocation *)location;
- (void)motionDetector:(MotionDetector *)motionDetector accelerationChanged:(CMAcceleration)acceleration;
- (void)motionDetector:(MotionDetector *)motionDetector locationWasPaused:(BOOL)changed;

@end
@interface MotionDetector : NSObject
//创建单利
+(MotionDetector *)sharedInstance;

@property (nonatomic,copy) void(^motionTypeChange)(MotionType motionType);
@property (nonatomic,copy) void(^locationChange)(CLLocationDistance meters,CGFloat speed);
@property (nonatomic,copy) void(^locationAccelerate)(CMAcceleration acceleration);
@property (nonatomic,copy) void(^locationPause)(BOOL changed);
@property (nonatomic) MotionType motionType;
@property (nonatomic,assign) double locationSpeed;
@property (nonatomic,assign) CMAcceleration acceleration;
@property (nonatomic,assign) BOOL isShaking;
@property (copy, nonatomic) CLLocation *location;
@property (nonatomic) MotionType currentMotionType;

#pragma mark - Accelerometer manager
@property (nonatomic,strong) CMMotionManager *motionManager;
@property (nonatomic,strong) CMMotionActivityManager *activityManager;
//开始使用传感器
- (void)startUpdate:(void(^)(BOOL humanState))stepCount;
//关闭传感器
-(void) stopDetection;

@property (nonatomic,assign) BOOL Ios7Available NS_AVAILABLE_IOS(7_0);





















@end
