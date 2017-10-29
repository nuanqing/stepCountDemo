//
//  ViewController.m
//  StepCount
//
//  Created by webplus on 16/4/21.
//  Copyright © 2016年 webplus. All rights reserved.
//

#import "ViewController.h"
#import "UIView+SDAutoLayout.h"
#import "MotionDetector.h"

@interface ViewController ()<UIAlertViewDelegate>
{
    int StepCount;
    UILabel *statelabel;
    UILabel *titlelabel;
    UILabel *speedlabel;
    UILabel *distancelabel;
    UILabel *consumecalo;
    NSMutableArray *distancearray;
    UIImageView *animationview;
    CGFloat weight;
}
@property (strong, nonatomic) UILabel *steplabel;
@end

@implementation ViewController

 BOOL humState=NO;

- (void)viewDidLoad {
       [super viewDidLoad];
    distancearray = [[NSMutableArray alloc]init];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"体重" message:@"输入体重计算您运动动时消耗的能量(单位为kg,如果不输入，则为默认为50kg)" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];

    [alert show];
    [self createUI];
    
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
       weight = 50.0f;
    if ([alertView cancelButtonIndex] != buttonIndex) {
         UITextField *TextField = [alertView textFieldAtIndex:0];
        NSString *str = TextField.text;
        if (![str isEqualToString:@""]) {
            weight = [str floatValue];
        }
    }
    [self state];
}


-(void)createUI
{
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.translucent =NO;
    self.view.backgroundColor =[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    //创建标题
    titlelabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 30)];
    titlelabel.textColor = [UIColor whiteColor];
    titlelabel.text = @"简步";
    titlelabel.textColor = [UIColor colorWithRed:94.0/255 green:195.0/255 blue:216.0/255 alpha:1.0];
    titlelabel.font = [UIFont systemFontOfSize:19];
    titlelabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = titlelabel;
    statelabel = [UILabel new];
    [self.view addSubview:statelabel];
    statelabel.sd_layout
    .centerXEqualToView(self.view)
    .topSpaceToView(self.view,10)
    .widthRatioToView(self.view,0.8)
    .heightIs(40);
    statelabel.textColor = [UIColor blackColor];
    statelabel.font = [UIFont systemFontOfSize:14];
    statelabel.textAlignment = NSTextAlignmentCenter;
    statelabel.text = @"开始运动吧!!";
    
    
    _steplabel = [UILabel new];
    [self.view addSubview:_steplabel];
    _steplabel.sd_layout
    .centerXEqualToView(self.view)
    .topSpaceToView(statelabel,30)
    .widthRatioToView(self.view,0.6)
    .heightIs(40);
    _steplabel.textColor = [UIColor blackColor];
    _steplabel.font = [UIFont systemFontOfSize:20];
    _steplabel.textAlignment = NSTextAlignmentCenter;
    _steplabel.text = @"步数:0";
    
    speedlabel = [UILabel new];
    [self.view addSubview:speedlabel];
    speedlabel.sd_layout
    .centerXEqualToView(self.view)
    .topSpaceToView(_steplabel,30)
    .widthRatioToView(self.view,0.6)
    .heightIs(40);
    speedlabel.textColor = [UIColor blackColor];
    speedlabel.font = [UIFont systemFontOfSize:20];
    speedlabel.textAlignment = NSTextAlignmentCenter;
    speedlabel.text = [NSString stringWithFormat:@"速度:0.0m/s"];
    
    distancelabel = [UILabel new];
    [self.view addSubview:distancelabel];
    distancelabel.sd_layout
    .centerXEqualToView(self.view)
    .topSpaceToView(speedlabel,30)
    .widthRatioToView(self.view,0.6)
    .heightIs(40);
    distancelabel.textColor = [UIColor blackColor];
    distancelabel.font = [UIFont systemFontOfSize:20];
    distancelabel.textAlignment = NSTextAlignmentCenter;
    distancelabel.text = [NSString stringWithFormat:@"距离:0m"];
    
    consumecalo = [UILabel new];
    [self.view addSubview:consumecalo];
    consumecalo.sd_layout
    .centerXEqualToView(self.view)
    .topSpaceToView(distancelabel,30)
    .widthRatioToView(self.view,0.6)
    .heightIs(40);
    consumecalo.textColor = [UIColor blackColor];
    consumecalo.font = [UIFont systemFontOfSize:20];
    consumecalo.textAlignment = NSTextAlignmentCenter;
    consumecalo.text = [NSString stringWithFormat:@"消耗卡路里:0kcalo"];
    
    animationview = [UIImageView new];
    [self.view addSubview:animationview];
    animationview.sd_layout
    .centerXEqualToView(self.view)
    .topSpaceToView(consumecalo,30)
    .widthIs(40)
    .heightIs(40);
    animationview.image = [UIImage imageNamed:@"centerXin1"];
}

-(void)state
{
    [MotionDetector sharedInstance].motionTypeChange = ^(MotionType Type){
        if (Type==0) {
            statelabel.text = @"开始运动吧!！";
        }
        if (Type==1) {
           
            statelabel.text = @"正在走路！";
        }
        if (Type==2) {
           
            statelabel.text = @"正在奔跑！";
        }
        if (Type==3) {
            
            statelabel.text = @"正在使用交通工具！";
        }
    };
    
    
    
    [MotionDetector sharedInstance].locationChange=^(CLLocationDistance meters,CGFloat speed){
        speedlabel.text = [NSString stringWithFormat:@"速度:%.2fm/s",speed];
        distancelabel.text = [NSString stringWithFormat:@"距离:%.0fm",meters];
        [distancearray addObject:[NSNumber numberWithFloat:meters]];
        NSUInteger index = distancearray.count-1;
            NSLog(@"%lu",(unsigned long)distancearray.count);
            if (distancearray.count>2) {
                CGFloat kcalo = weight*meters/1000*1.036;
                consumecalo.text = [NSString stringWithFormat:@"消耗卡路里:%.2fkcalo",kcalo];
                CGFloat meter1 = [[distancearray objectAtIndex:index-1]floatValue];
                CGFloat meter2 = [[distancearray objectAtIndex:index]floatValue];
                CGFloat distance = meter2-meter1;
            if (humState == NO) {
                if (distance>0.8f) {
                    int number = distance/0.8;
                    StepCount=StepCount+number;
                    _steplabel.text = [NSString stringWithFormat:@"步数:%d",StepCount];
                    animationview.image = [UIImage imageNamed:@"centerXin6"];
                }else{
                animationview.image = [UIImage imageNamed:@"centerXin1"];
            }
          }
        }
        
    };
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        [MotionDetector sharedInstance].Ios7Available = YES;
    }
    
    [LocationManager sharedInstance].allowsBackground = YES;
    
    [[MotionDetector sharedInstance] startUpdate:^(BOOL humanState) {
        humState = humanState;
        if (humanState==YES) {
            animationview.image = [UIImage imageNamed:@"centerXin6"];
            StepCount++;
            _steplabel.text = [NSString stringWithFormat:@"步数:%d",StepCount];
        }else{
            animationview.image = [UIImage imageNamed:@"centerXin1"];
        }
        
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
