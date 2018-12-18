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
    
}

@end
