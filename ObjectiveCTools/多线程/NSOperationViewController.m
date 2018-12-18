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

@end

@implementation NSOperationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"点击屏幕";
    self.view.backgroundColor = [UIColor lightGrayColor];
 
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    //[self invocationOperationWithQueue];
    
    //[self blockOperationWithQueue];
    
    [self customOperationWithQueue];
}

/// 方案 1
- (void)invocationOperationWithQueue {
    
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
- (void)blockOperationWithQueue {
    
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
- (void)customOperationWithQueue {
    
    CustomOperation *op1 = [[CustomOperation alloc] init];
    
    CustomOperation *op2 = [[CustomOperation alloc] init];
    
    CustomOperation *op3 = [[CustomOperation alloc] init];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [queue addOperation:op1]; 
    [queue addOperation:op2];
    [queue addOperation:op3];
}


- (void)fuck:(NSString *)para {
    NSLog(@"fucking %@  %@", para, [NSThread currentThread]);
}


@end
