//
//  ScreenShotViewController.m
//  ObjectiveCTools
//
//  Created by HPCL20190110 on 2019/3/13.
//  Copyright © 2019 ChinaRapidFinance. All rights reserved.
//

#import "ScreenShotViewController.h"

@interface ScreenShotViewController ()

@property (weak, nonatomic) IBOutlet UIView *viewSample;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation ScreenShotViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

/// 方案一
- (IBAction)actionOne:(id)sender {
    
    //截屏
    UIView *view = [[UIApplication sharedApplication].keyWindow snapshotViewAfterScreenUpdates:YES];

    NSLog(@"%@", view);
}

/// 方案二 这个也可以截取整个屏幕,设置好
- (IBAction)actionTwo:(id)sender {
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height), NO, 0.0);
    
    /// 如果是指定view 替换 [UIApplication sharedApplication].keyWindow 就可以
    [[UIApplication sharedApplication].keyWindow.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *screenShotImage = UIGraphicsGetImageFromCurrentImageContext();
   
    UIGraphicsEndImageContext();
    
    //保存
    UIImageWriteToSavedPhotosAlbum(screenShotImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}


/// 方案三
- (IBAction)actionThree:(id)sender {
    
    CGPoint savedContentOffset = self.scrollView.contentOffset;
    CGRect savedFrame = self.scrollView.frame;
    
    self.scrollView.contentOffset = CGPointMake(0.001, 0.001);  ///加了点偏移,为了防止滚动视图底部没有被截取

    self.scrollView.frame = CGRectMake(0, self.scrollView.frame.origin.y, self.scrollView.contentSize.width, self.scrollView.contentSize.height);
  
    [self.scrollView setNeedsDisplay];
    
    UIGraphicsBeginImageContextWithOptions(self.scrollView.contentSize, YES, 0.0); //currentView 当前的view  创建一个基于位图的图形上下文并指定大小为
    [self.scrollView.layer renderInContext:UIGraphicsGetCurrentContext()];//renderInContext呈现接受者及其子范围到指定的上下文
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();//返回一个基于当前图形上下文的图片
    
    self.scrollView.contentOffset = savedContentOffset;
    self.scrollView.frame = savedFrame;
    
    UIGraphicsEndImageContext();
   
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}


/// 保存
- (void)saveToAlbum:(UIView *)view {
    
    // 开启一个位图上下文
    UIGraphicsBeginImageContext(view.bounds.size);
    //把画板内容渲染到上下文当中
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:ctx];
    //从上下文当中取出图片
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    //关闭上下文
    UIGraphicsEndImageContext();
    //把图片保存到相册当中  这个方法是固定的,不能乱写
    UIImageWriteToSavedPhotosAlbum(img, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error == nil) {
        NSLog(@"保存成功");
    }
}

@end
