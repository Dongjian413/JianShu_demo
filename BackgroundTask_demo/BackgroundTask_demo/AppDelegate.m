//
//  AppDelegate.m
//  BackgroundTask_demo
//
//  Created by 东健FO_OF on 2017/7/3.
//  Copyright © 2017年 夏东健. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (nonatomic, unsafe_unretained) UIBackgroundTaskIdentifier backgroundTaskIdentifier;

@property (nonatomic, strong) NSTimer *myTimer;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    NSLog(@"%s",__func__);
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    NSLog(@"%s",__func__);
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    NSLog(@"%s",__func__);
    // 标记一个长时间运行的后台任务将开始
    // 通过调试，发现，iOS给了我们额外的10分钟（600s）来执行这个任务。
    self.backgroundTaskIdentifier =[application beginBackgroundTaskWithExpirationHandler:^(void) {
        // 当应用程序留给后台的时间快要到结束时（应用程序留给后台执行的时间是有限的）， 这个Block块将被执行
        // 我们需要在次Block块中使用同步的方式执行一些清理工作，如果清理工作失败了，那么将导致程序挂掉
        [self endBackgroundTask];
        
    }];
    // 模拟一个Long-Running Task
    self.myTimer =[NSTimer scheduledTimerWithTimeInterval:1.0f
                                                   target:self
                                                 selector:@selector(timerMethod:)
                                                 userInfo:nil
                                                  repeats:YES];
    
}

- (void) endBackgroundTask{
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    AppDelegate *weakSelf = self;
    dispatch_async(mainQueue, ^(void) {
        AppDelegate *strongSelf = weakSelf;
        if (strongSelf != nil){
            [strongSelf.myTimer invalidate];// 停止定时器
            // 每个对 beginBackgroundTaskWithExpirationHandler:方法的调用,必须要相应的调用 endBackgroundTask:方法。这样，来告诉应用程序你已经执行完成了。
            // 也就是说,我们向 iOS 要更多时间来完成一个任务,那么我们必须告诉 iOS 你什么时候能完成那个任务。
            // 标记指定的后台任务完成
            [[UIApplication sharedApplication]endBackgroundTask:self.backgroundTaskIdentifier];
            // 销毁后台任务标识符
            strongSelf.backgroundTaskIdentifier = UIBackgroundTaskInvalid;
        }
    });
    
}


// 模拟的一个 Long-Running Task 方法
- (void) timerMethod:(NSTimer *)paramSender{
    
    // backgroundTimeRemaining 属性包含了程序留给的我们的时间
    NSTimeInterval backgroundTimeRemaining =[[UIApplication sharedApplication]backgroundTimeRemaining];
    
    if (backgroundTimeRemaining == DBL_MAX){
        
        NSLog(@"Background Time Remaining = Undetermined");
        
    } else {
        
        NSLog(@"Background Time Remaining = %.02f Seconds", backgroundTimeRemaining);
        
    }
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    NSLog(@"%s",__func__);
    for (int i = 0; i < 1000; i ++) {
        NSLog(@"进入后台%d",i);
    }
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    NSLog(@"%s",__func__);
}


- (void)applicationWillTerminate:(UIApplication *)application {
    NSLog(@"%s",__func__);
}


@end
