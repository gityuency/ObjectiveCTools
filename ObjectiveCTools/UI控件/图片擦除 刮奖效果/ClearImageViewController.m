//
//  ClearImageViewController.m
//  ObjectiveCTools
//
//  Created by 姬友大人 on 2018/11/1.
//  Copyright © 2018年 姬友大人. All rights reserved.
//

#import "ClearImageViewController.h"

@interface ClearImageViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *iamgeView;

@end

@implementation ClearImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIPanGestureRecognizer *g = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(clearImage:)];
    [self.iamgeView addGestureRecognizer:g];
    
}


- (void)clearImage:(UIPanGestureRecognizer *)g {
    
    CGPoint currentPoint = [g locationInView:self.iamgeView];
    
    // 确定擦除区域
    CGFloat rectWH = 30;
    CGFloat x = currentPoint.x - rectWH * 0.5;
    CGFloat y = currentPoint.y - rectWH * 0.5;
    
    CGRect rect = CGRectMake(x, y, rectWH, rectWH);
    
    //生成一张带有透明度擦除的图片  NO: 擦除后变透明
    UIGraphicsBeginImageContextWithOptions(self.iamgeView.bounds.size, NO, 0);
    
    // 把 UIImage的内容渲染到上下文当中
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [self.iamgeView.layer renderInContext:ctx];
    
    // 擦除区域
    CGContextClearRect(ctx, rect);
    
    //获得图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 关闭上下文
    UIGraphicsEndImageContext();
    
    self.iamgeView.image = newImage;
}


@end
