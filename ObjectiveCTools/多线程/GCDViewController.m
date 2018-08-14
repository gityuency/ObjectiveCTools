//
//  GCDViewController.m
//  ObjectiveCTools
//
//  Created by ChinaRapidFinance on 2018/8/14.
//  Copyright © 2018年 ChinaRapidFinance. All rights reserved.
//

#import "GCDViewController.h"

@interface GCDViewController ()

@end

@implementation GCDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"GCD 示例代码合集";
}

/*
 场景1: 有 M 个网络请求, 等 M 个网络请求都结束之后, 再进行第 M + 1 个请求
 备注: 异步请求的 block 里面不要再添加其他异步请求
 */
- (IBAction)CGD_Group:(id)sender {
    
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
        
        //这里面已经是一个 异步线程 正在执行的代码范围
        //这里面可以放入大量的计算来造成任务很重的假象
        //如果在这个区域再放入异步操作, 那就是异步套异步, 那就是另外一个故事了..
        
        sleep(2);
        NSLog(@"1 当前线程%@",[NSThread currentThread]);
    });
    
    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
        sleep(5);
        NSLog(@"2 当前线程%@",[NSThread currentThread]);
    });
    
    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
        sleep(3);
        NSLog(@"3 当前线程%@",[NSThread currentThread]);
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"任务全部完成,当前线程 %@",[NSThread currentThread]);
    });
}


/*
 场景1: 有 M 个请求,等 M 个请求完成之后, 再进行第 M + 1 个请求
 备注: 如果这个请求不是 dispatch_group_async, 那该怎么做.
 */
- (IBAction)GCD_Enter_Leave:(id)sender {
    
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_enter(group);
    NSURL *url = [NSURL URLWithString:@"https://github.com/AFNetworking/AFNetworking.git"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *session=[NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask=[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"3 当前线程%@",[NSThread currentThread]);
        dispatch_group_leave(group);
    }];
    [dataTask resume];
    
    
    dispatch_group_enter(group);
    NSURL *url2 = [NSURL URLWithString:@"https://github.com/oa414/objc-zen-book-cn"];
    NSURLRequest *request2 = [NSURLRequest requestWithURL:url2];
    NSURLSession *session2 = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask2 = [session2 dataTaskWithRequest:request2 completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"4 当前线程%@",[NSThread currentThread]);
        dispatch_group_leave(group);
    }];
    [dataTask2 resume];
    
    
    dispatch_group_enter(group);
    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
        sleep(3);
        NSLog(@"1 当前线程%@",[NSThread currentThread]);
        dispatch_group_leave(group);
    });
    
    dispatch_group_enter(group);
    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
        sleep(2);
        NSLog(@"2 当前线程%@",[NSThread currentThread]);
        dispatch_group_leave(group);
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"任务全部完成,当前线程 %@",[NSThread currentThread]);
    });
}


/*
 (异步线程 并发执行 然后阻塞 然后并发执行)
 1，有 m 个网络请求。
 2，先并发执行其中 n 个。
 3，待这n个请求完成之后再执行第 n+1 个请求。
 4，然后等 第 n+1 个请求完成后再并发执行剩下的 m-(n+1) 个请求。
 */
- (IBAction)GCD_Barrier:(id)sender {
    
    // 创建队列
    dispatch_queue_t queue = dispatch_queue_create("我的名字", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        sleep(3);
        NSLog(@"1 当前线程%@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        sleep(5);
        NSLog(@"2 当前线程%@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        sleep(2);
        NSLog(@"3 当前线程%@",[NSThread currentThread]);
    });
    dispatch_barrier_async(queue, ^{
        NSLog(@"处理任务 1 2 3");
    });
    dispatch_async(queue, ^{
        sleep(2);
        NSLog(@"4 当前线程%@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        sleep(4);
        NSLog(@"5 当前线程%@",[NSThread currentThread]);
    });
    dispatch_barrier_async(queue, ^{
        NSLog(@"处理任务 4 5");
    });
}



/*
 场景1: 系统现在有 2 个空闲线程可以用, 但是同一时间 有 3 个线程要同时访问, 如何安排线程线程访问?
 场景2: 同一时间要下载很多图片, 每次下载都会开辟一个新线程, 但是开辟太多线程会卡顿, 如何控制最大开辟线程数?
 备注: 如果这个请求不是 dispatch_group_async, 那该怎么做.
 */
- (IBAction)GCD_Semaphore:(id)sender {
    
    //创建信号量，参数：信号量的初值，如果小于0则会返回NULL crate的value表示，最多几个资源可访问
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(2);
    dispatch_queue_t quene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    //任务4 (注意,种情况属于异步线程里面又开了一个异步线程)
    dispatch_async(quene, ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        NSLog(@"➡️任务 4 当前线程%@",[NSThread currentThread]);
        NSURL *url = [NSURL URLWithString:@"https://www.163.com/"];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        NSURLSession *session= [NSURLSession sharedSession];
        NSURLSessionDataTask *dataTask=[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            NSLog(@"✅任务 4 当前线程%@",[NSThread currentThread]);
            dispatch_semaphore_signal(semaphore);
        }];
        [dataTask resume];
    });
    
    //任务1
    dispatch_async(quene, ^{
        //等待降低信号量 -1
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        NSLog(@"➡️任务 1 当前线程%@",[NSThread currentThread]);
        sleep(1);
        NSLog(@"✅任务 1 当前线程%@",[NSThread currentThread]);
        //提高信号量 +1
        dispatch_semaphore_signal(semaphore);
    });
    
    //任务2
    dispatch_async(quene, ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        NSLog(@"➡️任务 2 当前线程%@",[NSThread currentThread]);
        sleep(1);
        NSLog(@"✅任务 2 当前线程%@",[NSThread currentThread]);
        dispatch_semaphore_signal(semaphore);
    });
    
    //任务5
    dispatch_async(quene, ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        NSLog(@"➡️任务 5 当前线程%@",[NSThread currentThread]);
        NSURL *url = [NSURL URLWithString:@"https://github.com/oa414/objc-zen-book-cn"];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        NSURLSession *session= [NSURLSession sharedSession];
        NSURLSessionDataTask *dataTask=[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            NSLog(@"✅任务 5 当前线程%@",[NSThread currentThread]);
            dispatch_semaphore_signal(semaphore);
        }];
        [dataTask resume];
    });
    
    //任务3
    dispatch_async(quene, ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        NSLog(@"➡️任务 3 当前线程%@",[NSThread currentThread]);
        sleep(1);
        NSLog(@"✅任务 3 当前线程%@",[NSThread currentThread]);
        dispatch_semaphore_signal(semaphore);
    });
}



@end
