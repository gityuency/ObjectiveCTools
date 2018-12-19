//
//  NSthreadViewController.m
//  ObjectiveCTools
//
//  Created by yuency on 2018/12/17.
//  Copyright © 2018年 yuency. All rights reserved.
//

#import "NSthreadViewController.h"
#import "CustomThread.h"

@interface NSthreadViewController ()

@end

@implementation NSthreadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"点击屏幕";
    self.view.backgroundColor = [UIColor brownColor];
}


// NSThread 线程的生命周期 当线程中的任务执行完毕之后 销毁这个线程对象


/// 这里写一些示例代码
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    //[self create_thread_1];
    
    //[self create_thread_2];
    
    //[self create_thread_3];
    
    [self create_thread_4];
}


///示例代码1
- (void)create_thread_1 {
    NSThread *t = [[NSThread alloc] initWithTarget:self selector:@selector(fuck:) object:@"abc"];
    t.name = @"线程名字";
    t.threadPriority = 1; //范围 0 - 1, 默认 0.5
    [t start];
}

///示例代码2
- (void)create_thread_2 {

    // 1
    if (@available(iOS 10.0, *)) {
        [NSThread detachNewThreadWithBlock:^{
            NSLog(@"blcok  %@", [NSThread currentThread]);
        }];
    }
    
    // 2
    [NSThread detachNewThreadSelector:@selector(fuck:) toTarget:self withObject:@"OPQ"];
}

///示例代码3
- (void)create_thread_3 {

    [self performSelectorInBackground:@selector(fuck:) withObject:@"back fuck"];
}


- (void)fuck:(NSString *)para {
    NSLog(@"%@ %@ ", para, [NSThread currentThread]);
    
    [NSThread sleepForTimeInterval:8]; // 线程暂停
    
    [NSThread sleepUntilDate:[NSDate dateWithTimeIntervalSinceNow:3]]; //从现在开始睡3秒之后醒过来
    
    [NSThread exit];  //强制退出线程  // 如果在 for 循环里使用 break 退出, 那么表示任务执行完毕退出
}



/// 示例代码4
- (void)create_thread_4 {
    
    // 如果需要直接使用 NSThread alloc init 这样的方式创建任务, 需要自定义子类, 然后重写 main 方法, 就可以执行
    CustomThread *c = [[CustomThread alloc] init];
    
    [c start];
    
}


@end
