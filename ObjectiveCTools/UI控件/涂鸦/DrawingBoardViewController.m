//
//  DrawingBoardViewController.m
//  涂鸦
//
//  Created by 姬友大人 on 2018/11/2.
//  Copyright © 2018年 comming. All rights reserved.
//

#import "DrawingBoardViewController.h"
#import "DrawView.h"
#import "HandleImageView.h"

@interface DrawingBoardViewController () <UINavigationControllerDelegate,UIImagePickerControllerDelegate, HandleImageViewDelegate>

/// 画板
@property (weak, nonatomic) IBOutlet DrawView *drawView;

@end

@implementation DrawingBoardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - 按钮事件

///清屏
- (IBAction)clear:(UIBarButtonItem *)sender {
    [self.drawView clear];
}
///撤销
- (IBAction)undo:(UIBarButtonItem *)sender {
    [self.drawView  undo];
}
///橡皮擦
- (IBAction)erase:(UIBarButtonItem *)sender {
    [self.drawView erase];
}
///照片
- (IBAction)photo:(UIBarButtonItem *)sender {
    
    UIImagePickerController *vc = [[UIImagePickerController alloc] init];
    vc.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    vc.delegate = self;
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    //图片放到桌面 图片保存到桌面
    NSData *data = UIImagePNGRepresentation(image);
    [data writeToFile:@"/Users/姬友大人/Desktop/其他/a.png" atomically:YES];
    
    // 自定义的图片处理类    
    HandleImageView *imageV = [[HandleImageView alloc] initWithFrame:self.drawView.frame];
    imageV.delegate = self;
    imageV.image = image;
    [self.view addSubview:imageV];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}


- (void)handleImageView:(HandleImageView *)handleImageView newImage:(UIImage *)newImage {
    self.drawView.image = newImage;
}


///保存
- (IBAction)save:(UIBarButtonItem *)sender { //保存到系统相册 截屏生成图片
    // 开启一个位图上下文
    UIGraphicsBeginImageContext(self.drawView.bounds.size);
    //把画板内容渲染到上下文当中
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [self.drawView.layer renderInContext:ctx];
    //从上下文当中取出图片
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    //关闭上下文
    UIGraphicsEndImageContext();
    //把图片保存到相册当中  这个方法是固定的,不能乱写
    UIImageWriteToSavedPhotosAlbum(img, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSLog(@"保存成功");
}


/// 设置线的宽度
- (IBAction)setLineWidth:(UISlider *)sender {
    [self.drawView setLineWidth:sender.value];
}
/// 设置线的颜色
- (IBAction)setLineColor:(UIButton *)sender {
    [self.drawView setLineColor:sender.backgroundColor];
}

/// 隐藏状态栏  在添加图片的时候会有 20 点的高度偏差
- (BOOL)prefersStatusBarHidden {
    return NO;
}


@end
