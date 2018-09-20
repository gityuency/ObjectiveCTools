//
//  PhotoLosslessSaveViewController.m
//  ObjectiveCTools
//
//  Created by 十年前的春天 on 2018/9/20.
//  Copyright © 2018年 姬友大人. All rights reserved.
//

#import "PhotoLosslessSaveViewController.h"

//引入框架 系统最低版本要求8.0
#import <Photos/Photos.h>

@interface PhotoLosslessSaveViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UILabel *labelInfo;

@end

@implementation PhotoLosslessSaveViewController


- (void)viewDidLoad {
    [super viewDidLoad];
}

/// 点击按钮
- (IBAction)buttonAction:(UIButton *)sender {
    // 先去 info.plit 开启相册权限,否则真机崩溃
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    
    if (status == PHAuthorizationStatusAuthorized) {
        [self startCoquettishOperation];
    } else {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if(status == PHAuthorizationStatusAuthorized) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 用户点击 "OK"
                    [self startCoquettishOperation];
                });
            } else {
                // 用户点击 不允许访问
                self.labelInfo.text = @"玩你妈嗨";
            }
        }];
    }
}


/// 下载图片,保存到相册
- (void)startCoquettishOperation {
    
    //这里使用你的 App 名字作为相册的名字
    NSString *myAlbumName = [NSBundle mainBundle].infoDictionary[@"CFBundleDisplayName"];
    
    NSArray *imageArray = @[
                            //1993951字节 jpg格式
                            @"http://desk.fd.zol-img.com.cn/t_s1920x1080c5/g5/M00/0E/03/ChMkJ1jLslKISLngAB5s3zryFm0AAa0-gKh6oUAHmz3642.jpg",
                            //428397字节 jpg格式
                            @"http://desk.fd.zol-img.com.cn/t_s1920x1080c5/g5/M00/03/0C/ChMkJlekgpaIdfThAAUBS2JU_LIAAUMOwIWjK0ABQFj984.jpg",
                            //6525 字节, png 格式
                            @"http://d.lanrentuku.com/down/png/1610/creativetail-12-objects-icons-v1/tedy_bear_128px.png",
                            //714,940 字节
                            @"https://desk-fd.zol-img.com.cn/t_s2880x1800c5/g5/M00/03/02/ChMkJ1snEmSIOxuyACDtz-3LcyoAApHBQNTWKcAIO3n284.jpg",
                            //669,742 字节
                            @"https://desk-fd.zol-img.com.cn/t_s2880x1800c5/g5/M00/01/06/ChMkJlqVBu6IZnpeABHX83UjQXsAAlAVgEko9gAEdgL529.jpg",
                            //645,708 字节（磁盘上的 647 KB）
                            @"https://desk-fd.zol-img.com.cn/t_s2880x1800c5/g5/M00/0E/00/ChMkJ1nJ4yKIOsEEAGL_lEchWXoAAgzFwLR_9IAYv-s222.jpg",
                            ];
    
    //从以上图片地址数组找个图片吧
    NSString *imageUrl = imageArray[1];
    
    //创建图片文件夹路径, 真机不允许直接使用 Documents 目录
    NSString *newFloderPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/MyImages"];
    
    //构造图片路径
    NSString *imageName = [imageUrl lastPathComponent];
    NSString *imagePath = [newFloderPath stringByAppendingPathComponent:imageName];
    
    //文件管理器
    NSFileManager *manager = [NSFileManager defaultManager];
    
    //创建文件夹
    BOOL wenjianjia = [manager createDirectoryAtPath:newFloderPath withIntermediateDirectories:NO attributes:nil error:nil];
    
    if (wenjianjia) {
        NSLog(@"SUCCESS 文件夹创建成功! %@",newFloderPath);
    }
    
    //创建文件
    BOOL createSuccess = [manager createFileAtPath:imagePath contents:nil attributes:nil];
    
    if (createSuccess) {
        NSLog(@"SUCCESS 文件创建成功! %@", imagePath);
    }
    
    //保存图片
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
    BOOL writeSuccess = [imageData writeToFile:imagePath atomically:YES];
    
    if (writeSuccess) {
        NSLog(@"SUCCESS 写入成功! %@", imagePath);
    }
    
    self.imageView.image = [UIImage imageWithData:imageData];
    
    /*
     PHAssetCollectionTypeAlbum      = 1,  这个东西是拿到 非 系统创建的相册, 可能是你创建的,可能是其他应用创建的
     PHAssetCollectionTypeSmartAlbum = 2,  这个是系统创建的相册名字, 不管你在手机的相册 App 里面有没有出现对应的相册名, 这个东西都能拿到相册名
     PHAssetCollectionTypeMoment           这个拿到的是默认相册里面的分组, 比如在模拟器上初始的相册, 个数就是 6
     */
    
    /*
     fetchAssetCollectionsWithType: 参数填写: PHAssetCollectionTypeAlbum,表示要拿到非系统创建的相册,
     subtype: 参数填写 PHAssetCollectionSubtypeAny, 表示要拿到所有的相册.
     如果在这里 不填 PHAssetCollectionTypeAlbum 而填写其他两个 枚举值, 就会发生 Error Domain=NSCocoaErrorDomain Code=-1 "(null)" 的错误
     */
    PHFetchResult<PHAssetCollection *> *collections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAny options:nil];
    
    NSLog(@"相册个数: %lu", (unsigned long)collections.count);
    
    PHAssetCollection *myCollection = nil;
    
    for (PHAssetCollection *collection in collections ) {
        NSLog(@"相册名字: %@ 子类型: %ld", collection.localizedTitle , (long)collection.assetCollectionSubtype);
        if ([collection.localizedTitle isEqualToString:myAlbumName]) {
            myCollection = collection;
            break;
        }
    }
    
    NSURL *imageURL = [NSURL fileURLWithPath:imagePath];
    
    if (myCollection) {
        //保存到已有相册
        [self saveMyPhotoTo:myCollection imageURL:imageURL];
    } else {
        //保存到新创建的相册
        [self saveMyPhotoToNew:myAlbumName imageURL:imageURL];
    }
}


//创建和 APP 同名的相册 然后再保存 (case: 这个用户某天把我创建的这个相册整个删除,然后又往里添加照片, 第一次就会添加失败,解决这样的 BUG)
- (void)saveMyPhotoToNew:(NSString *)albumName imageURL:(NSURL *)imageURL {
    
    [[PHPhotoLibrary sharedPhotoLibrary]performChanges:^{
        
        PHAssetCollectionChangeRequest *changeCollectionRequest = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:albumName];
        
        PHAssetChangeRequest *changeAssetRequest = [PHAssetChangeRequest creationRequestForAssetFromImageAtFileURL:imageURL];
        
        PHObjectPlaceholder *assetPlaceholder = [changeAssetRequest placeholderForCreatedAsset];
        
        [changeCollectionRequest addAssets:@[assetPlaceholder]];
        
    } completionHandler:^(BOOL success,NSError * _Nullable error) {
        
        success == YES ? NSLog(@"SUCCESS 添加到新创建的相册!") : NSLog(@"爆炸: %@",error);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.labelInfo.text = @"成功添加到 新 创建的相册!";
        });
    }];
}

// 添加到已经存在的相册里面
- (void)saveMyPhotoTo:(PHAssetCollection *)myCollection imageURL:(NSURL *)imageURL {
    
    [[PHPhotoLibrary sharedPhotoLibrary]performChanges:^{
        
        PHAssetCollectionChangeRequest *changeCollectionRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:myCollection];
        
        PHAssetChangeRequest *changeAssetRequest = [PHAssetChangeRequest creationRequestForAssetFromImageAtFileURL:imageURL];
        
        PHObjectPlaceholder *assetPlaceholder = [changeAssetRequest placeholderForCreatedAsset];
        
        [changeCollectionRequest addAssets:@[assetPlaceholder]];
        
    } completionHandler:^(BOOL success,NSError * _Nullable error) {
        
        success == YES ? NSLog(@"SUCCESS 添加到已经存在的相册!") : NSLog(@"爆炸: %@",error);
        dispatch_async(dispatch_get_main_queue(), ^{
            self.labelInfo.text = @"成功添加到 已有 相册!";
        });
    }];
}


@end
