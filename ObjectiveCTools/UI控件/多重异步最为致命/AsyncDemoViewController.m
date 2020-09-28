//
//  AsyncDemoViewController.m
//  ObjectiveCTools
//
//  Created by aidong on 2020/7/6.
//  Copyright © 2020 姬友大人. All rights reserved.
//

#import "AsyncDemoViewController.h"
#import "AsyncDemoView.h"
//#import <AVKit/AVKit.h>

/*
 这是在做网易云音视频的时候遇到的问题, 用户A,有好几个信息,这好几个信息,都是从不同的地方获得,获得这些信息的方式,是通过各种网络请求.这也就出现了: 要从多个异步请求里拿到这个用户的信息.
 然而用户A对象只能存在一个, 所以应当在是不同的异步任务返回之后,先检查这个用户是否存在,存在,就添加新返回来的信息,不存在,就创建,并且添加新的信息.
 
 然后, addSubview 这个函数, 首先 B 被添加到 A1 视图上,如果 A2 调用 addSubview 添加 B ,那么, B 会自动从 A1 上移除, 然后添加到 A2 上面
 
 以上两个东西,就是网易云音视频这次的任务需求中困扰了我很长时间的bug,也造成了很多的崩溃,真的烦死了.
 */
/// 多重异步,最为致命
@interface AsyncDemoViewController ()

/// 按钮
@property (weak, nonatomic) IBOutlet UIButton *buttonA;
/// 按钮
@property (weak, nonatomic) IBOutlet UIButton *buttonB;
//为了接收从代理中返回来的view
@property (nonatomic, strong) AsyncDemoView *displayView;
/// 写个提示
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

//@property (nonatomic, strong) NSString *videoUrl;
//@property (nonatomic, strong) AVPlayerViewController *playerVC;


@end

@implementation AsyncDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self checkReady];
    
    [self mockThreeDifferentTask];
}


/// 在每次回调的时候, 都要先检查这个用户对象是否存在, 如果存在,取出来更新用户信息, 如果不存在, 就创建一个新的用户模型, 放入字典, 供后续使用
- (AsyncDemoView *)checkReady {
    if (self.displayView) {
        return self.displayView;
    } else {
        self.displayView = [[AsyncDemoView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        self.displayView.center = self.view.center;
        [self.view addSubview:self.displayView];
        return self.displayView;
    }
}

/// 第 1 个网络回调
- (void)taskOneBack:(UIView *)view {
    NSLog(@"taskOneBack: %@",view);
    self.displayView = [self checkReady];
    [self.displayView insertSubview:view atIndex:0];
    self.infoLabel.text = [self.infoLabel.text stringByAppendingString:@"\n回调: 预览图"];
}
/// 第 2 个网络回调
- (void)taskTwoBack:(NSString *)string {
    NSLog(@"taskTwoBack: %@", string);
    self.displayView = [self checkReady];
    self.displayView.string = string;
    self.infoLabel.text = [self.infoLabel.text stringByAppendingString:@"\n回调: 名字"];
}
/// 第 3 个网络回调
- (void)taskThrBack:(UIImage *)image {
    NSLog(@"taskThrBack: %@", image);
    self.displayView = [self checkReady];
    self.displayView.image = image;
    self.infoLabel.text = [self.infoLabel.text stringByAppendingString:@"\n回调: 头像"];
}

/// 模拟异步网络回调
- (void)mockThreeDifferentTask {
    dispatch_queue_t queue = dispatch_queue_create("名字",  DISPATCH_QUEUE_CONCURRENT);
    //第一个异步任务   // -[UIView initWithFrame:] must be used from main thread only
    dispatch_async(queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(20, 20, 60, 60)];
            view.backgroundColor = [UIColor yellowColor];
            int delay = arc4random_uniform(5) + 1;
            [self performSelector:@selector(taskOneBack:) withObject:view afterDelay:delay];
        });
    });
    dispatch_async(queue, ^{
        NSString *s = @"王小明";
        dispatch_async(dispatch_get_main_queue(), ^{
            int delay = arc4random_uniform(5) + 1;
            [self performSelector:@selector(taskTwoBack:) withObject:s afterDelay:delay];
        });
    });
    dispatch_async(queue, ^{
        UIImage *img = [UIImage imageNamed:@"忘了爱.jpg"];
        dispatch_async(dispatch_get_main_queue(), ^{
            int delay = arc4random_uniform(5) + 1;
            [self performSelector:@selector(taskThrBack:) withObject:img afterDelay:delay];
        });
    });
}


/// 点击A
- (IBAction)actionA:(UIButton *)sender {
    [self.buttonA addSubview:self.displayView];
    self.displayView.frame = CGRectMake(0, 0, 100, 100);
}

/// 点击B
- (IBAction)actionB:(UIButton *)sender {
    [self.buttonB addSubview:self.displayView];
    self.displayView.frame = CGRectMake(0, 0, 100, 100);
}


@end
