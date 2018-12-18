//
//  CustomOperation.m
//  ObjectiveCTools
//
//  Created by yuency on 2018/12/18.
//  Copyright © 2018年 yuency. All rights reserved.
//

#import "CustomOperation.h"

@implementation CustomOperation

/// 告诉要执行的任务 重写这个方法
- (void)main {
    
    // 对于大批量的代码操作, 有利于 复用 和 封装 , 隔离代码
    
    NSLog(@"%@ %s", [NSThread currentThread], __func__);
    
    //场景 : 如果这个线程里有多个耗时操作, 那么如何相应暂停
    
    for (NSInteger i = 0; i < 1000; i ++) {
        NSLog(@"耗时任务 1 %@", [NSThread currentThread]);
    }
    
    // 加上这个判断, 就可以让自定义的子类线程相应 NSOperationQueue 的 取消 操作
    // 苹果官方的建议
    if (self.isCancelled) { return; }
    
    
    for (NSInteger i = 0; i < 1000; i ++) {
        NSLog(@"耗时任务 2 %@", [NSThread currentThread]);
    }
    
    
    // 加上这个判断
    if (self.isCancelled) { return; }
    
    
    for (NSInteger i = 0; i < 1000; i ++) {
        NSLog(@"耗时任务 3 %@", [NSThread currentThread]);
    }
}

@end
