//
//  YXFilePath.h
//  ObjectiveCTools
//
//  Created by HPCL20190110 on 2019/3/25.
//  Copyright © 2019 HPCL20190110. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 用于获取沙盒路径存放的类 /Documents/YuencyVideo/时间文件夹/文件
@interface YXFilePath : NSObject

/// 最终生成的文件名字
+ (NSString *)needFinalFilePath;

/// 创建音频文件地址
+ (NSString *)createAudioPath;

/// 创建视频文件地址
+ (NSString *)createVideoPath;

/// 删除沙盒里最近生成的文件 (临时音频,临时视频,合成视频)
+ (BOOL)removeRecentFile;

/// 删除沙盒里所有文件
+ (void)removeAllFile;

@end

NS_ASSUME_NONNULL_END
