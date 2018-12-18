//
//  GCDViewController.m
//  ObjectiveCTools
//
//  Created by 姬友大人 on 2018/8/14.
//  Copyright © 2018年 姬友大人. All rights reserved.
//

#import "GCDViewController.h"

/**
 
 Grand Central Dispatch

 纯 C 语言
 为 多核 并行 运算提出的解决方案, 充分利用 CPU 内核, 自动管理线程的生命周期

 核心概念  1.任务(执行什么操作)
          2.队列(用来存放任务, 先进先出)
 
 GCD 会自动将队列中的任务取出, 放到对应的线程中执行
 
 同步函数 dispatch_sync 不会开新线程 不管加入到 并发 还是 串行 队列
 
 
 */
@interface GCDViewController ()

@end

@implementation GCDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"GCD 示例代码合集";
}

#pragma mark - 队列决定任务怎么执行  异步决定会不会开子线程 一共 4 中组合方式
#pragma mark 异步函数 + 并发队列: 会开始多条线程, 队列中的任务是异步(并发,一起)执行
- (IBAction)analysis_Async_Concurrent {
    
    // 创建队列 参数1: C语言字符串,是这个队列的标签 参数2: DISPATCH_QUEUE_CONCURRENT 并发  DISPATCH_QUEUE_SERIAL 串行
    dispatch_queue_t queue = dispatch_queue_create("名字",  DISPATCH_QUEUE_CONCURRENT);
    
    //还可以获取全局的并发队列 这个队列是 GCD 自带, 直接使用,  参数1: 优先级   参数2: 直接传 0
    //dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    
    // 创建异步任务, 参数1: 属于哪个队列 参数2: 任务代码
    // 开多少个线程并不是由任务决定, 当有很多任务时, 系统将决定线程数量
    dispatch_async(queue, ^{
        NSLog(@"1%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"2%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"3%@", [NSThread currentThread]);
    });
}

#pragma mark 异步函数 + 串行队列: 会开线程,开一条线程,对列中的任务是串行(有顺序)执行的.
- (IBAction)analysis_Async_Serial {
    // 因为串行队列的存在, 这个队列把任务 一个一个按顺序执行, 即便是异步函数, 也被同步执行了
    dispatch_queue_t queue = dispatch_queue_create("名字",  DISPATCH_QUEUE_SERIAL);

    //确实是开了子线程(只开了一条,而不是多条), 但是这三个任务都在这一个子线程中被执行完毕
    
    dispatch_async(queue, ^{
        NSLog(@"1%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"2%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"3%@", [NSThread currentThread]);
    });
 
}


#pragma mark 同步函数 + 并发队列: 不会开线程,任务同步/串行/顺序执行
- (IBAction)analysis_Sync_Concurrent {
    
    dispatch_queue_t queue = dispatch_queue_create("名字",  DISPATCH_QUEUE_CONCURRENT);
    
    // 这三个任务都在主线程中依次执行
    dispatch_sync(queue, ^{
        NSLog(@"1%@", [NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"2%@", [NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"3%@", [NSThread currentThread]);
    });
    
}

#pragma mark 同步函数 + 串行队列: 不会开线程,任务同步/串行/顺序执行
- (IBAction)analysis_Sync_Serial {
    
    dispatch_queue_t queue = dispatch_queue_create("名字",  DISPATCH_QUEUE_SERIAL);
    
    // 这三个任务都在主线程中依次执行
    dispatch_sync(queue, ^{
        NSLog(@"1%@", [NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"2%@", [NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"3%@", [NSThread currentThread]);
    });
    
}


#pragma mark 异步函数 + 主队列: 所有任务都在主线程中执行, 没有开新线程
- (IBAction)analysis_Async_Main {

    dispatch_queue_t queue = dispatch_get_main_queue();
    
    dispatch_async(queue, ^{
        NSLog(@"1%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"2%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"3%@", [NSThread currentThread]);
    });
}


#pragma mark 同步函数 + 主队列: ! 如果这个函数放在主线程里调用, 就是死锁. 如果这个函数放在子线程调用, 就是正常.
- (IBAction)analysis_Sync_Main {
    
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    // 如果主队列发现当前主线程有任务在执行, 那么主队列会暂停调用队列中的任务,直到主线程空闲为止
    
    dispatch_sync(queue, ^{ //立刻执行,如果我没有执行完,后面的代码不能执行
        NSLog(@"1%@", [NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"2%@", [NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"3%@", [NSThread currentThread]);
    });
}


#pragma mark - GCD 其他场景示例代码

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
  
    
    /*
     dispatch_group_notify  这个方法 内部本身是异步的
     dispatch_group_notify  是 dispatch_group_enter leave 的简写版本
     */
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{ //这里可以根据情况 使用 全局队列 或者 主队列
        NSLog(@"任务全部完成,当前线程 %@",[NSThread currentThread]);
    });
 
    
    /*
     //这个方法表示 要等待 group 里面所有任务都执行完毕, 才往下走代码  这个方法可以代替 dispatch_group_notify
     dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
     NSLog(@"代码走到这里, 表示 group 里的任务都完成");
     */
    
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
    
    
    dispatch_group_enter(group);  //在该方法后面的异步任务会被纳入到队列租的监听范围
    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{   // dispatch_group_async 使用组
        sleep(3);
        NSLog(@"1 当前线程%@",[NSThread currentThread]);
        dispatch_group_leave(group);
    });
    
    
    dispatch_group_enter(group);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{                //dispatch_async  没有使用组
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

    
    // 栅栏 函数 不能使用全局并发队列(dispatch_get_global_queue), 需要自己创建一个并发队列, 不能是同步队列, 同步队列将失去栅栏的意义
    dispatch_barrier_async(queue, ^{
        NSLog(@"处理任务 1 2 3 %@", [NSThread currentThread]);
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
        NSLog(@"处理任务 4 5 %@", [NSThread currentThread]);
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

/*
 快速迭代
 开子线程 并且 和 主线程一起完成任务, 任务的执行是并发的
 */
- (IBAction)GCD_Apply:(id)sender {
    
    /*
     参数1: 遍历的次数
     参数2: 队列(并发队列)
     参数3: index 索引
     */
    
    dispatch_apply(10, dispatch_get_global_queue(0, 0), ^(size_t index) {
        NSLog(@"任务执行 当前线程%@",[NSThread currentThread]);
    });
    
}


@end
