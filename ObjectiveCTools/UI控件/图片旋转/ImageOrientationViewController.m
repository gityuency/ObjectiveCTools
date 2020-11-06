//
//  ImageOrientationViewController.m
//  ObjectiveCTools
//
//  Created by aidong on 2020/11/6.
//  Copyright © 2020 姬友大人. All rights reserved.
//

#import "ImageOrientationViewController.h"

@interface ImageOrientationViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageViewOri;

@property (weak, nonatomic) IBOutlet UIImageView *imageViewNew;

@property (strong, nonnull) UIImage *image;

@end

@implementation ImageOrientationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"忘了爱" ofType:@"jpg"];
    self.image = [UIImage imageWithContentsOfFile:path];
    self.imageViewOri.image = self.image;
    NSLog(@"原始图片的旋转: %ld", (long)self.image.imageOrientation);

}

- (IBAction)actionToLeft90:(UIButton *)sender {
    if (self.image.imageOrientation == UIImageOrientationUp) {
        UIImage *rotatedImage = [UIImage imageWithCGImage:self.image.CGImage scale:1.0f orientation:UIImageOrientationLeft];
        self.imageViewNew.image = rotatedImage;
        NSLog(@"处理后的旋转: %ld", (long)rotatedImage.imageOrientation);
        //保存图片的到相册
        //UIImageWriteToSavedPhotosAlbum(rotatedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if(error){
        NSLog(@"保存图片失败");
    } else {
        NSLog(@"保存图片成功");
    }
}

@end
