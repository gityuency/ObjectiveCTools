//
//  OptionEnumeViewController.m
//  ObjectiveCTools
//
//  Created by yuency on 2018/12/19.
//  Copyright © 2018年 yuency. All rights reserved.
//

#import "OptionEnumeViewController.h"


/**
 定义一个位移枚举
 一个参数可以传递多个值
 如果是位移枚举, 观察第一个枚举值,如果这个枚举值 != 0, 那么可以默认传0做参数,如果传0做参数,那么效率最高
 */
typedef NS_OPTIONS(NSInteger, OptionType) {
    
    OptionTypeTop = 1 << 0, //数字 1 左移 0 位 (10进制1),
    OptionTypeBottom = 1 << 1, //数字 1 左移 1 位 (10进制2)
    OptionTypeLeft = 1 << 2, //数字 1 左移 2 位 (10进制4)
    OptionTypeRight = 1 << 3, //数字 1 左移 3 位 (10进制8)
};


@interface OptionEnumeViewController ()

@end

@implementation OptionEnumeViewController

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self demo: OptionTypeTop | OptionTypeBottom | OptionTypeLeft | OptionTypeRight]; //传几个就做几个
    
    [self demo:0]; // 传0什么也不做
}



/**
 按位与 & 1&1==1, 1&0==0, 0&0==0, 只要有0则为0
 按位或 & 1|1==1, 1|0==1, 0|0==0, 只要有1则为1
 */
- (void)demo:(OptionType)type{

    NSLog(@"参数运算结果值: %zd", type);
    
    if (type & OptionTypeTop) {
        NSLog(@"上 %zd", type & OptionTypeTop);
    }
    
    if (type & OptionTypeBottom) {
        NSLog(@"下 %zd", type & OptionTypeBottom);
    }
    
    if (type & OptionTypeLeft) {
        NSLog(@"左 %zd", type & OptionTypeLeft);
    }
    
    if (type & OptionTypeRight) {
        NSLog(@"右 %zd", type & OptionTypeRight);
    }
}

@end
