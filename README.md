# stepCountDemo
简单的计步器
>
>简单的计步器软件，根据体重与行走的距离计算消耗的卡路里，检测运动速度等
>

![效果图](https://github.com/nuanqing/stepCountDemo/blob/master/StepCount/stepCout.gif)

 关于计步器原理
 ----
 实现重力感应传感器的开发需要导入Core Motion的框架，Core Motion提供了实时的加速度的值，角速度的值，以及三轴磁力的值，分别由CMAccelerometerData，CMMGyroData和CMMagnetometerData提供。而CMAccelerometerData得到的数值,是通过苹果公司的算法集成，直接输出把重力加速度分离过后的加速度数值，不需要通过高通滤波的操作，这里我设计的计步器软件的计步方法就是根据CMAccelerometerData提供的三轴加速度来先实现的
 陀螺仪在三维坐标的三个分量如图:
 
 ![分量图](https://github.com/nuanqing/stepCountDemo/blob/master/StepCount/pic1.png)
 
 当我们把手机正面朝上水平的放置在桌面上，X轴从左到右为，Y轴从下到上，Z轴垂直方向上从背屏到屏幕，都为负值到正值，而CMAccelerometerData提供的加速度也是这样的方式
 手机处于晃动状态的时候，通过CMAccelerometerData在X，Y，Z三个轴线上提供的加速度数值，以及结合算法数据，我们就能对他人进行计步操作。
 而对传感器的开发同样也需要有和定位一样管理器来对传感器进行管理，CMMotionManager就是对传感器进行管理的管理器，Manager类，通过CMMotionManager可以设置采样频率，开启采样和关闭采样。而且CMMotionManager提供了 Pull和Push两种方式的获取方式。 你可以通过获取当前任何传感器的状态或是CoreMotionManager的只读属性组合数据来pull动态的数据。也可以通过自行提供线程管理器，通过block闭包在特定的时间间隔来获取你想要的更新数据集合来捕获Push的数据。这里我所选用的是Push的方式，与Pull的方式相比，Push的代码会更多一些，同时需要自行控制线程，比如回到主线程才能刷新UI，但Push得到的数据也更加精确
 上面说到M7协助处理器是在IOS7之后才能开发使用，而且不需要数值，更加方便与精确，那么对于高于IOS7系统手机的运动状态的判断，便增加了M7协助处理器的简单使用。CMMotionActivityManager是对运动状态的管理器,CMMotionActivityManager类提供了访问数据存储设备的功能，可以开启和关闭。通过Push的方式在Block块儿中回调数据，判断状态
 流程图:
 
![流程图1](https://github.com/nuanqing/stepCountDemo/blob/master/StepCount/pic2.png)

![流程图2](https://github.com/nuanqing/stepCountDemo/blob/master/StepCount/pic3.png)
