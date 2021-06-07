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

///注意, 对于单次使用的弹窗, 用完就直接销毁, 在用完之后, 把block置为nil是可以的
///如果是一次点击要同时弹出3个这样的弹窗,那么,这种静态变量的写法就有问题,在第二个弹框使用的时候,就会造成崩溃,原因是这个成员变量的指向已经改变了.
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


