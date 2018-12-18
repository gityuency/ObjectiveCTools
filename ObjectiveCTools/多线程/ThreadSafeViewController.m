//
//  ThreadSafeViewController.m
//  ObjectiveCTools
//
//  Created by yuency on 2018/12/17.
//  Copyright © 2018年 yuency. All rights reserved.
//

#import "ThreadSafeViewController.h"

@interface ThreadSafeViewController ()

/// 第1个售票员
@property (nonatomic, strong) NSThread *t1;

/// 第2个售票员
@property (nonatomic, strong) NSThread *t2;

/// 第1个售票员
@property (nonatomic, strong) NSThread *t3;

/// 第1个售票员
@property (nonatomic, assign) NSInteger count;

@end

///  线程安全 互斥锁
@implementation ThreadSafeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"点击屏幕";
    self.view.backgroundColor = [UIColor orangeColor];
    
    // 线程同步: 多条线程在同一条线上按顺序执行 怎么做? 加互斥锁
    
    /*
     nonatomic: 不会为属性的 setter 方法加锁,
     atomic:    默认的模式, 会加锁
     @property 为成员变量增加 getter 和 setter 方法
     */
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    self.count = 100;
    
    self.t1 = [[NSThread alloc] initWithTarget:self selector:@selector(saleTicket) object:nil];
    self.t2 = [[NSThread alloc] initWithTarget:self selector:@selector(saleTicket) object:nil];
    self.t3 = [[NSThread alloc] initWithTarget:self selector:@selector(saleTicket) object:nil];
    
    self.t1.name = @"T1";
    self.t2.name = @"T2";
    self.t3.name = @"T3";
    
    [self.t1 start];
    [self.t2 start];
    [self.t3 start];
    
}

- (void)saleTicket {
    
    while (YES) {
        
        // 这个锁必须是全局唯一的
        // 注意加锁的位置
        // 注意加锁的前提条件 多线程访问同一块资源
        // 注意加锁是需要代价的 需要耗费性能
        //
        @synchronized (self) {  //线程安全 价格互斥锁就...
            
            if (self.count > 0) {
                for (NSInteger i = 0; i < 100000; i ++) {}
                self.count -= 1;
                NSLog(@"票数 %ld 售票员 %@", self.count, [NSThread currentThread].name);
            } else {
                NSLog(@"买完了");
                break;
            }
        }
    }
}



- (void)text {
    
    // 回到主线程
    // 参数1: 要执行的方法
    // 参数2: 传递的参数
    // 参数3: 如果这个 performSelectorOnMainThread 下发还有其他的代码, YES 表示等待 selector 里面的方法执行完毕再往下执行, NO 表示不等待就直接继续执行
    //self performSelectorOnMainThread:<#(nonnull SEL)#> withObject:<#(nullable id)#> waitUntilDone:<#(BOOL)#>

    
    // 去往后台线程执行
    //self performSelectorInBackground:<#(nonnull SEL)#> withObject:<#(nullable id)#>
    
    
    
    //
    //self performSelector:<#(nonnull SEL)#> onThread:<#(nonnull NSThread *)#> withObject:<#(nullable id)#> waitUntilDone:<#(BOOL)#>
    
    
    
    //骚操作 performSelectorOnMainThread 是 NSObject 的分类方法,  setImage 是 UIImageView 的 setter 方法, 这样就直接在主线程更新 UI, 少写一步
    UIImageView *v;
    [v performSelectorOnMainThread:@selector(setImage:) withObject:[UIImage new] waitUntilDone:YES];
    
    
}


@end
