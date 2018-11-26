//
//  MemoryView.m
//  实验弹出框
//
//  Created by yuency on 2018/11/22.
//  Copyright © 2018年 yuency. All rights reserved.
//

#import "MemoryView.h"
#import <malloc/malloc.h>
#import <objc/runtime.h>

@implementation MemoryView

static ActionBlock selfAction = nil;

+ (void)showWithAction:(ActionBlock)action {
    
    MemoryView *memoryView = [[NSBundle mainBundle] loadNibNamed:@"MemoryView" owner:nil options:nil].firstObject;
    memoryView.frame =  [UIScreen mainScreen].bounds;
    [[[UIApplication sharedApplication].delegate window] addSubview:memoryView];
    
    NSLog(@"全局block: 对象: %p  指针: %p  ----  参数block: 对象: %p 指针: %p",selfAction, &selfAction, action, &action);
    selfAction = action;
    NSLog(@"全局block: 对象: %p  指针: %p  ----  参数block: 对象: %p 指针: %p",selfAction, &selfAction, action, &action);

    
    NSLog(@"对象大小: %zd", malloc_good_size(class_getInstanceSize([memoryView class])));
    NSLog(@"对象大小: %zd", class_getInstanceSize([memoryView class]));
    NSLog(@"对象大小: %zd", malloc_good_size(class_getInstanceSize([selfAction class])));
}

/// 移除
- (IBAction)buttonClick:(UIButton *)sender {

    if (selfAction) {
        
        selfAction(0);
        NSLog(@"全局block: 对象: %p  指针: %p",selfAction, &selfAction);

        selfAction = nil;
        NSLog(@"全局block: 对象: %p  指针: %p",selfAction, &selfAction);
    }
    [self removeFromSuperview];
}

@end


