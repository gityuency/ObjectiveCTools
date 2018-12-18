//
//  NSOperationViewController.m
//  ObjectiveCTools
//
//  Created by yuency on 2018/12/18.
//  Copyright © 2018年 yuency. All rights reserved.
//

#import "NSOperationViewController.h"
#import "CustomOperation.h"

/*
 NSOperation 是个抽象类, 并不具备封装操作的能力, 必须使用它的子类
 1. 使用NSInvocationOperation
 2. 使用NSBlockOperation
 3. 自定义子类 继承 NSOperation
 */

@interface NSOperationViewController ()

/// 线程状态的队列
@property (nonatomic, strong) NSOperationQueue *myQueue;

@end

@implementation NSOperationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

/// 方案 1
- (IBAction)invocationOperationWithQueue {
    
    NSInvocationOperation *op1 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(fuck:) object:@"氮磷钾"];
    NSInvocationOperation *op2 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(fuck:) object:@"氮磷钾"];
    NSInvocationOperation *op3 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(fuck:) object:@"氮磷钾"];
    
    //创建队列
    /*
     GCD
     串行类型: create & 主队列
     并发类型: create & 全局并发队列
     
     NSOperation
     主队列:   [NSOperationQueue mainQueue]  和 GCD 中的主队列一样, 串行队列
     非主队列:  [[NSOperationQueue alloc] init] 非常特殊, (同时具备并发和串行的功能)
     
     默认情况下, 非主队列是并发队列
     */
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [queue addOperation:op1]; //添加就执行任务 内部已经调用 [op1 start]
    [queue addOperation:op2];
    [queue addOperation:op3];
}



/// 方案 2
- (IBAction)blockOperationWithQueue {
    
    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"%@", [NSThread currentThread]);
    }];
    
    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"%@", [NSThread currentThread]);
    }];
    
    NSBlockOperation *op3 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"%@", [NSThread currentThread]);
    }];
    
    // 可以追加任务 追加的任务放到了不同的线程里
    [op1 addExecutionBlock:^{
        NSLog(@"追加任务1 %@", [NSThread currentThread]);
    }];
    
    [op1 addExecutionBlock:^{
        NSLog(@"追加任务2 %@", [NSThread currentThread]);
    }];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [queue addOperation:op1];
    [queue addOperation:op2];
    [queue addOperation:op3];
    
    //简便写法 创建操作 -> 添加操作到队列 -> 开始任务
    [queue addOperationWithBlock:^{
        NSLog(@"简便写法 %@", [NSThread currentThread]);
    }];
}


/// 方案 3
- (IBAction)customOperationWithQueue {
    
    CustomOperation *op1 = [[CustomOperation alloc] init];
    
    CustomOperation *op2 = [[CustomOperation alloc] init];
    
    CustomOperation *op3 = [[CustomOperation alloc] init];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [queue addOperation:op1];
    [queue addOperation:op2];
    [queue addOperation:op3];
}


- (IBAction)operationMaxCount:(id)sender {
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    // 设置最大并发数 设置为 1 就是串行
    //串行执行任务不等于只开一条线程, (线程同步)
    //设置为0不会执行任务
    //设置为 -1 特殊意义, 最大值, 表示最大并发数不受限制
    queue.maxConcurrentOperationCount = 2;
    
    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"1%@", [NSThread currentThread]);
    }];
    
    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"2%@", [NSThread currentThread]);
    }];
    
    NSBlockOperation *op3 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"3%@", [NSThread currentThread]);
    }];
    NSBlockOperation *op4 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"4%@", [NSThread currentThread]);
    }];
    NSBlockOperation *op5 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"5%@", [NSThread currentThread]);
    }];
    NSBlockOperation *op6 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"6%@", [NSThread currentThread]);
    }];
    
    [queue addOperation:op1];
    [queue addOperation:op2];
    [queue addOperation:op3];
    [queue addOperation:op4];
    [queue addOperation:op5];
    [queue addOperation:op6];
}


- (IBAction)operationDependency:(id)sender {
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    NSOperationQueue *queueAddtionan = [[NSOperationQueue alloc] init];

    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"1%@", [NSThread currentThread]);
    }];
    
    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"2%@", [NSThread currentThread]);
    }];
    
    NSBlockOperation *op3 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"3%@", [NSThread currentThread]);
    }];
    NSBlockOperation *op4 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"4%@", [NSThread currentThread]);
    }];

    
    //操作监听 1.不是任务完成立即收到监听, 2.可能在其他线程中收到监听
    op3.completionBlock = ^{
        NSLog(@"任务3 执行完成 %@", [NSThread currentThread]);
    };
    
    
    // 执行顺序 4 -> 3 -> 2 -> 1  任务执行的线程可能不同,但是顺序是固定的,线程同步
    // 不能循环依赖,不会崩溃,循环依赖的任务不会执行
    // 可以跨队列依赖
    [op1 addDependency:op2];
    [op2 addDependency:op3];
    [op3 addDependency:op4];
    
    
    //也可以这么设置依赖, op1 的执行 依赖 op2 和 op3 完成
    /*
     [op1 addDependency:op2];
     [op1 addDependency:op3];
     */
    

    [queue addOperation:op1];
    [queue addOperation:op2];
    [queueAddtionan addOperation:op3];
    [queue addOperation:op4];
}


- (IBAction)operationConnection:(UIButton *)sender {
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{

        NSURL *url = [NSURL URLWithString:@"http://img.pconline.com.cn/images/upload/upc/tx/photoblog/1601/07/c7/17318133_1452142939893_mthumb.jpg"];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *img = [UIImage imageWithData:data];
        NSLog(@"线程 %@", [NSThread currentThread]);
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{ //主线程更新
            [sender setBackgroundImage:img forState:UIControlStateNormal];
            NSLog(@"线程 %@", [NSThread currentThread]);
        }];
    }];

    //添加操作到队列
    [queue addOperation:op1];
    
}


- (void)fuck:(NSString *)para {
    NSLog(@"fucking %@  %@", para, [NSThread currentThread]);
}


#pragma mark - 线程的各种状态设置
- (IBAction)start:(id)sender {
    
    self.myQueue = [[NSOperationQueue alloc] init];
    
    self.myQueue.maxConcurrentOperationCount = 1;

    
    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i < 1000; i ++) {
            NSLog(@"1%@", [NSThread currentThread]);
        }
    }];
    
    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i < 1000; i ++) {
            NSLog(@"2%@", [NSThread currentThread]);
        }
    }];
    
    NSBlockOperation *op3 = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i < 1000; i ++) {
            NSLog(@"3%@", [NSThread currentThread]);
        }
    }];
    NSBlockOperation *op4 = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i < 1000; i ++) {
            NSLog(@"4%@", [NSThread currentThread]);
        }
    }];
    NSBlockOperation *op5 = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i < 1000; i ++) {
            NSLog(@"5%@", [NSThread currentThread]);
        }
    }];
    NSBlockOperation *op6 = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i < 1000; i ++) {
            NSLog(@"6%@", [NSThread currentThread]);
        }
    }];
    
    [self.myQueue addOperation:op1];  //这里的队列添加的是系统提供的任务, 如果是自定义的任务,如何相应 取消 操作
    [self.myQueue addOperation:op2];
    [self.myQueue addOperation:op3];
    [self.myQueue addOperation:op4];
    [self.myQueue addOperation:op5];
    [self.myQueue addOperation:op6];
}


- (IBAction)suspend:(id)sender { //暂停之后可以恢复任务, 不能暂停正在执行中的任务
    /*
     队列中的任务也是有状态的
     正在执行 | 排队等待 |
     */
    self.myQueue.suspended = YES;
}

- (IBAction)goOn:(id)sender {
    self.myQueue.suspended = NO;
}

- (IBAction)cancle:(id)sender { //取消任务之后将不可恢复任务
    //内部调用了所有操作的 cancle 操作
    [self.myQueue cancelAllOperations];
}

@end
