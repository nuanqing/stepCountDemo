//
//  MotionDetector.m
//  StepCount
//
//  Created by webplus on 16/4/21.
//  Copyright © 2016年 webplus. All rights reserved.
//

#import "MotionDetector.h"


@implementation MotionDetector
{
    CLLocation *oldlocation;
    CLLocation *newlocation;
    NSMutableArray *locationarr;

}
//这里为判断1.移动的最小速度2.走路的最大速度3.跑步的最大速度
CGFloat minSpeed =0.3f;
CGFloat walkSpeed =1.9f;
CGFloat runSpeed =7.5f;
CGFloat rate = 1.2f;

//创建传感器单利
+(MotionDetector *)sharedInstance
{
    static MotionDetector *motion = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        motion = [[self alloc]init];
    });
    return motion;
}
//初始化
-(id)init
{
    if (self = [super init]) {
        self.motionManager = [[CMMotionManager alloc]init];
        self.motionManager.accelerometerUpdateInterval = UPDATATIME;
        self.motionManager.deviceMotionUpdateInterval = UPDATATIME;
        self.motionManager.gyroUpdateInterval = UPDATATIME;
        self.motionManager.showsDeviceMovementDisplay = YES;
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(locationchanged:) name:LOCATIONCHANGE object:nil];
         [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(locationpause:) name:LOCATIONPAUSE object:nil];
        locationarr = [[NSMutableArray alloc]init];
        self.motionManager = [[CMMotionManager alloc]init];
        oldlocation = [[CLLocation alloc]init];
        newlocation = [[CLLocation alloc]init];
    }
    return self;
}
//判断传感器是否可用
+(BOOL)motionAvailable
{
    static BOOL isAvailable = NO;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        isAvailable = [CMMotionActivityManager isActivityAvailable];
    });
    return isAvailable;
}

-(void)startUpdate:(void (^)(BOOL))stepCount{
     [[LocationManager sharedInstance]startLocation];
    [self.motionManager startAccelerometerUpdatesToQueue:[[NSOperationQueue alloc]init] withHandler:^(CMAccelerometerData * _Nullable accelerometerData, NSError * _Nullable error) {
        [self calculateType];
        CMAcceleration ration = accelerometerData.acceleration;
        CGFloat rateX = ration.x;
        CGFloat rateY = ration.y;
        CGFloat rateZ = ration.z;
        NSLog(@"%f %f %f",rateX,rateY,rateZ);
        if (rateX>rate||rateY>rate||rateZ>rate) {
            //必须回到主线程刷新UI
            dispatch_async(dispatch_get_main_queue(), ^{
                stepCount (YES);
            });
            
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                stepCount (NO);
            });
        }
    }];
    
    if (self.Ios7Available && [MotionDetector motionAvailable]) {
        if (!self.activityManager) {
            self.activityManager = [[CMMotionActivityManager alloc] init];
        }
        
        [self.activityManager startActivityUpdatesToQueue:[[NSOperationQueue alloc] init] withHandler:^(CMMotionActivity *activity) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (activity.walking) {
                    _motionType = MotionTypeWalking;
                } else if (activity.running) {
                    _motionType = MotionTypeRunning;
                } else if (activity.automotive) {
                    _motionType = MotionTypeOhter;
                } else if (activity.stationary || activity.unknown) {
                    _motionType = MotionTypeNotMoving;
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (self.motionTypeChange) {
                        self.motionTypeChange (self.motionType);
                    }
                });
            });
        }];
    }

}


- (void)stopDetection
{
    [[LocationManager sharedInstance] stopLocation];
    [self.motionManager stopAccelerometerUpdates];
    [self.activityManager stopActivityUpdates];
}

-(void)locationchanged:(NSNotification *)nofi
{
    NSDictionary *dict = [nofi userInfo];
   locationarr = [dict objectForKey:@"locationarr"];
    oldlocation = [locationarr firstObject];
    newlocation = [locationarr lastObject];
    
    CLLocationDistance meters = [newlocation distanceFromLocation:oldlocation];
    
    self.location = newlocation;
    
    _locationSpeed = self.location.speed;
    NSLog(@"%f",self.location.speed);
    if (_locationSpeed<0) {
        _locationSpeed = 0;
    }
   dispatch_async(dispatch_get_main_queue(), ^{
    self.locationChange(meters,_locationSpeed);
   });
    [self calculateType];
}
- (void)locationpause:(NSNotification *)nofi
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.locationPause) {
            self.locationPause (TRUE);
        }
    });
}
-(void)calculateType
{
    if (self.Ios7Available&&[MotionDetector motionAvailable]) {
        return;
    }
    if (_locationSpeed<minSpeed) {
        _motionType = MotionTypeNotMoving;
    }
    if (_locationSpeed<=walkSpeed&&_locationSpeed>=minSpeed) {
        _motionType = MotionTypeWalking;
    }
    if (_locationSpeed<=runSpeed&&_locationSpeed>=walkSpeed) {
        _motionType = MotionTypeRunning;
    }
    if (_locationSpeed>runSpeed) {
        _motionType = MotionTypeOhter ;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.motionTypeChange) {
            self.motionTypeChange (self.motionType);
        }
    });
}



-(void)stopUpdate
{
    if (self.motionManager.isAccelerometerActive) {
        [self.motionManager stopAccelerometerUpdates];
    }
}



















@end
