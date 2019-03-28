//
//  YXFilePath.m
//  ObjectiveCTools
//
//  Created by HPCL20190110 on 2019/3/25.
//  Copyright © 2019 HPCL20190110. All rights reserved.
//

#import "YXFilePath.h"

/// 主文件夹目录
static NSString *mainFloderName = @"";

/// 音频文件的地址
static NSString *fileAudioPath = @"";

/// 视频文件的地址
static NSString *fileVideoPath = @"";

/// 创建的总次数
static NSInteger combindCount= 0;

/// 最终的文件地址
static NSString *finalVideoPath = nil;

/// 当前路径
static NSString *currentPath = nil;

/// 记录本次运行时候的所有路径, 为了让最终的视频可以取得路径
static NSMutableArray *arrayAllPaths = nil;


@implementation YXFilePath

- (void)dealloc {
    
    NSLog(@"⭕️ 成功释放 %s %s", __FILE__, __func__);
}

+ (void)initialize {
    arrayAllPaths = [NSMutableArray array];
}


#pragma mark - 生成文件夹
/**
 1.音频和视频的录制都需要指定路径.
 2.我想把每一次录制产生的 临时音频视频 和 最后生成的视频文件放到一个文件夹里, 这个文件夹根据当前日期创建.
 3.这样就需要在每一次初始化音频视频录制类的时候都填入一个新的文件路径.
 4.但是,在开始录制的时候创建这些 音频视频对象是需要消耗一点时间的,为了把这个时间缩减到最小,
 5.在刚开始初始化的时候初始化一次, 随后在每次音频视频录制结束的时候, 再重新初始化x这些类,
 6.所以空白的文件夹是为了下一次使用的时候准备的.
 7.在沙盒里删掉了这个空白的准备的文件夹,就是让程序崩溃!!!!
 
 @return 文件夹路径
 */
+ (NSString *)needNewDateFloder {
    
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy_MM_dd_HH_mm_ss"];
    NSString *strDate = [dateFormatter stringFromDate:date];
    
    NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    
    mainFloderName = [docPath stringByAppendingPathComponent:@"YXWork"];
    
    NSString *floderPath = [mainFloderName stringByAppendingPathComponent:strDate];
    
    NSFileManager *m = [NSFileManager defaultManager];
    
    BOOL res = [m createDirectoryAtPath:floderPath withIntermediateDirectories:YES attributes:nil error:nil];
    
    if (res) {
        NSLog(@"✅ 创建工作文件夹成功!");
        
        combindCount = 1; //计数 +1, 告诉下一个来创建的函数,文件夹已经创建完毕
        
        currentPath = floderPath;  //记录一下当前的文件夹路径, 给下一个来访问的函数使用
        
        [arrayAllPaths addObject:floderPath];
        
    } else {
        NSLog(@"❌ 创建工作文件夹失败!");
    }
    
    return floderPath;
    
}


#pragma mark - 生成视频文件地址
/// 生成视频文件地址
+ (NSString *)createVideoPath {
    
    NSString *filePath = nil;
    
    if (combindCount == 0) { //说明没有创建,那么久开始创建
        
        NSString *floderPath = [YXFilePath needNewDateFloder];
        
        filePath = [[floderPath stringByAppendingPathComponent:@"video"] stringByAppendingPathExtension:@"mp4"];
        
        fileVideoPath = filePath;
        
    } else if (combindCount == 1) { //说明有人提前创建,那么久直接使用
        
        filePath = [[currentPath stringByAppendingPathComponent:@"video"] stringByAppendingPathExtension:@"mp4"];
        
        fileVideoPath = filePath;
        
        combindCount = 0;
    }
    
    return fileVideoPath;
}


#pragma mark - 生成音频文件地址
/// 生成音频文件地址
+ (NSString *)createAudioPath {
    
    NSString *filePath = nil;
    
    if (combindCount == 0) { //说明没有创建,那么久开始创建
        
        NSString *floderPath = [YXFilePath needNewDateFloder];
        
        filePath = [[floderPath stringByAppendingPathComponent:@"audio"] stringByAppendingPathExtension:@"wav"];
        
        fileAudioPath = filePath;
        
    } else if (combindCount == 1) { //说明有人提前创建,那么久直接使用
        
        filePath = [[currentPath stringByAppendingPathComponent:@"audio"] stringByAppendingPathExtension:@"wav"];
        
        fileAudioPath = filePath;
        
        combindCount = 0;
    }
    
    return fileAudioPath;
}


#pragma mark - 最终生成的文件名字
/// 最终生成的文件名字
+ (NSString *)needFinalFilePath {
    
    if (arrayAllPaths.count >= 2) {
        NSString *path = arrayAllPaths[arrayAllPaths.count - 2];
        NSString *finalVideoPath = [[path stringByAppendingPathComponent:@"FinalVideo"] stringByAppendingPathExtension:@"mp4"];
        return finalVideoPath;
    } else {
        NSLog(@"❌ 存放文件路径数组越界, 无法取得地址");
        return @"";
    }
}

/// 删除沙盒里最近生成的文件 (临时音频,临时视频,合成视频)
+ (BOOL)removeRecentFile {
    
    NSString *path = arrayAllPaths.firstObject;
    
    BOOL res = [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    
    if (res) {
        NSLog(@"✅ 已删除本次录制文件");
        [arrayAllPaths removeObjectAtIndex:0];
    } else {
        NSLog(@"❌ 删除本次录制文件失败");
    }
    return res;
}

/// 删除沙盒里所有文件
+ (void)removeAllFile {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSLog(@"〽️ 动作: 删除沙盒文件 线程 %@", [NSThread currentThread]);

        BOOL res = [[NSFileManager defaultManager] removeItemAtPath:mainFloderName error:nil];
        
        if (res) {
            NSLog(@"✅ 已删除工作文件夹");
            [arrayAllPaths removeObjectAtIndex:0];
        } else {
            NSLog(@"❌ 删除本次录制文件失败");
        }
        
        mainFloderName = nil;
        
        fileAudioPath = nil;
        
        fileVideoPath = nil;
        
        combindCount = 0;
        
        finalVideoPath = nil;
        
        currentPath = nil;
        
        [arrayAllPaths removeAllObjects];
        
    });
}

@end
