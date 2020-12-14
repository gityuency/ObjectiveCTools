//
//  ISPDFProgressPoster.m
//  ObjectiveCTools
//
//  Created by aidong on 2020/12/14.
//  Copyright © 2020 姬友大人. All rights reserved.
//

#import "ISPDFProgressPoster.h"
#import <CommonCrypto/CommonDigest.h>
#import "PDFCell.h"

@interface ISPDFProgressPoster () <NSURLSessionDelegate>

///记录: stringURL -> DownloadTaskID
@property (nonatomic, strong) NSMapTable *mapTableUrlToTaskId;
///记录: DownloadTaskID -> WebView
@property (nonatomic, strong) NSMapTable <NSNumber *, NSHashTable *> *mapTableTaskIdToView;
///
@property (nonatomic, strong) NSURLSessionConfiguration *c;
///
@property (nonatomic, strong) NSOperationQueue *q;
///
@property (nonatomic, strong) NSURLSession *s;
///
@property (nonatomic, strong) NSMutableArray *loadingArray;

@end

@implementation ISPDFProgressPoster

static ISPDFProgressPoster *_sharedInstance = nil;

static dispatch_once_t onceToken;

+ (instancetype)shared {
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[ISPDFProgressPoster alloc] init];
        
        _sharedInstance.mapTableUrlToTaskId = [NSMapTable weakToWeakObjectsMapTable];
        
        _sharedInstance.mapTableTaskIdToView = [NSMapTable weakToStrongObjectsMapTable];
        
        _sharedInstance.c = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        _sharedInstance.q = [[NSOperationQueue alloc] init];
        
        _sharedInstance.s = [NSURLSession sessionWithConfiguration:_sharedInstance.c delegate:_sharedInstance delegateQueue:_sharedInstance.q];
        
        _sharedInstance.loadingArray = [[NSMutableArray alloc] init];
    });
    return _sharedInstance;
}

///加载PDF
- (void)loadPDFInQueue:(WKWebView *)webView filePath:(NSString *)filePath {
    
    PDFCellModel *cellModel = [[PDFCellModel alloc] init];
    cellModel.webView = webView;
    cellModel.filePath = filePath;
    
    [_sharedInstance.loadingArray addObject:cellModel];
    
    NSURL *sandBoxUrl = [NSURL fileURLWithPath:cellModel.filePath];
    [cellModel.webView loadFileURL:sandBoxUrl allowingReadAccessToURL:[sandBoxUrl URLByDeletingLastPathComponent]];
    
}

///加载下一个
- (void)loddNextPDF:(WKWebView *)webView {
    //移出当前已经加载完的
    for (PDFCellModel *model in _sharedInstance.loadingArray) {
        if (model.webView == webView) {
            [_sharedInstance.loadingArray removeObject:model];
            break;
        }
    }
    //加载下一个
    if (_sharedInstance.loadingArray.count > 0) {
        for (PDFCellModel *model in _sharedInstance.loadingArray) {
            
            NSURL *sandBoxUrl = [NSURL fileURLWithPath:model.filePath];
            [model.webView loadFileURL:sandBoxUrl allowingReadAccessToURL:[sandBoxUrl URLByDeletingLastPathComponent]];
            break;
        }
    }
}

/// 为了那个东西下载PDF
- (void)downloadPDF:(NSString *)stringURL forWKWebview:(WKWebView *)webView {
    
    if ([_sharedInstance.mapTableUrlToTaskId objectForKey:stringURL]) {
        
        //这里针对: 同一个页面上有 3 个webview都在下载同一个文件, 那么, 下载任务只要一个就行,
        ///但是 3 个 webview上都需要展示进度, 所以, 把这三个webview都加入到同一个下载任务的数组, 都更新进度
        NSURLSessionDownloadTask *d = [_sharedInstance.mapTableUrlToTaskId objectForKey:stringURL];
        NSHashTable *arry = [_sharedInstance.mapTableTaskIdToView objectForKey:@(d.taskIdentifier)];
        [arry addObject:webView];
        
    } else { //没有下载, 就开始下载
        
        //创建下载
        NSURL *u = [NSURL URLWithString:stringURL];
        NSMutableURLRequest *r = [[NSMutableURLRequest alloc] initWithURL:u];
        [r setValue:@"甲醛" forHTTPHeaderField:@"放点添加剂"];
        NSURLSessionDownloadTask *d = [_sharedInstance.s downloadTaskWithRequest:r];
        
        //记录当前下载所属的url标识
        NSHashTable *arry = [_sharedInstance.mapTableTaskIdToView objectForKey:@(d.taskIdentifier)];
        if (arry == nil) {
            arry = [NSHashTable weakObjectsHashTable];
        }
        [arry addObject:webView];
        [_sharedInstance.mapTableTaskIdToView setObject:arry forKey:@(d.taskIdentifier)];
        
        [_sharedInstance.mapTableUrlToTaskId setObject:d forKey:stringURL];
        
        [d resume];
        
        NSLog(@"");
    }
}


#pragma mark - 代理函数
/* Sent when a download task that has completed a download.  The delegate should
 * copy or move the file at the given location to a new location as it will be
 * removed when the delegate message returns. URLSession:task:didCompleteWithError: will
 * still be called.
 */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    
    //这一步是保存下载的pdf文件
    for (NSString *keyStringUrl in _sharedInstance.mapTableUrlToTaskId) {
        NSURLSessionDownloadTask *task = [_sharedInstance.mapTableUrlToTaskId objectForKey:keyStringUrl];
        if (task.taskIdentifier == downloadTask.taskIdentifier) {
            
            //保存
            NSString *toPath = [ISPDFProgressPoster iRequire_PDF_SandBox_Path:keyStringUrl];
            NSURL *toUrl = [NSURL fileURLWithPath:toPath];
            [[NSFileManager defaultManager] moveItemAtURL:location toURL:toUrl error:nil];
            
            //发送通知
            NSHashTable *array = [_sharedInstance.mapTableTaskIdToView objectForKey:@(downloadTask.taskIdentifier)];
            for (WKWebView *webView in array) {
                if (webView) {
                    if ([webView respondsToSelector:@selector(pdfPosterFinish:)]) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [webView performSelector:@selector(pdfPosterFinish:) withObject:toPath];
                        });
                    }
                }
            }
            
            //移除
            [_sharedInstance.mapTableUrlToTaskId removeObjectForKey:keyStringUrl];
            [_sharedInstance.mapTableTaskIdToView removeObjectForKey:@(downloadTask.taskIdentifier)];
            
            break;
        }
    }
    
    //NSLog(@"1😈 %@", _sharedInstance.mapTableUrlToTaskId);
    //NSLog(@"2😈 %@", _sharedInstance.mapTableTaskIdToView);
}

/* Sent periodically to notify the delegate of download progress. */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    
    //NSString *totalString = [NSString stringWithFormat:@"%.2f M", totalBytesExpectedToWrite / 1024.0 / 1024.0];
    //NSString *downloadString = [NSString stringWithFormat:@"%.2f M", totalBytesWritten / 1024.0 / 1024.0];
    //NSLog(@"%@ %@", downloadString, totalString);
    
    NSHashTable *array = [_sharedInstance.mapTableTaskIdToView objectForKey:@(downloadTask.taskIdentifier)];
    for (WKWebView *webView in array) {
        if (webView) {
            if ([webView respondsToSelector:@selector(pdfPosterReceiveProgress:)]) {
                float progress = totalBytesWritten / (totalBytesExpectedToWrite * 1.0) * 100;
                NSString *sp = [NSString stringWithFormat:@"%.2f%%M", progress];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [webView performSelector:@selector(pdfPosterReceiveProgress:) withObject:sp];
                });
            }
        }
    }
    
    //NSLog(@"1🎃 %@", _sharedInstance.mapTableUrlToTaskId);
    //NSLog(@"2🎃 %@", _sharedInstance.mapTableTaskIdToView);
}

/* Sent when a download has been resumed. If a download failed with an
 * error, the -userInfo dictionary of the error will contain an
 * NSURLSessionDownloadTaskResumeData key, whose value is the resume
 * data.
 */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes {
}


#pragma mark - 沙盒文件处理方法
///根据url地址获取这个pdf文件的存储地址
+ (NSString *)iRequire_PDF_SandBox_Path:(NSString *)stringUrl {
    ///文件夹即时获取
    NSString *folderPath = [ISPDFProgressPoster iRequire_Local_PDF_FolderPath];
    ///文件名即时获取
    NSString *filePath = [folderPath stringByAppendingPathComponent:[ISPDFProgressPoster iConvert_URL_To_FileName:stringUrl]];
    return filePath;
}

///把url做成文件名字
+ (NSString *)iConvert_URL_To_FileName:(NSString *)stringUrl {
    NSString *md5 = [ISPDFProgressPoster generateMD5:stringUrl];
    NSString *name = [stringUrl componentsSeparatedByString:@"/"].lastObject;
    NSString *fullName = [NSString stringWithFormat:@"%@_%@", md5, name];
    return fullName;
}

+ (NSString *)generateMD5:(NSString *)string {
    const char *str = [string UTF8String];
    if (str == NULL) {
        str = "";
    }
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    NSString *result = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                        r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];
    return result;
}

///拿到当前存放pdf的文件夹的目录
+ (NSString *)iRequire_Local_PDF_FolderPath {
    NSString *pathHeader = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *folderPath = [pathHeader stringByAppendingPathComponent:@"教练员fdsaf套路手册pdf"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:folderPath]) {
        //LLLog(@"教练员套路手册pdf 文件夹已经存在");
    } else {
        //LLLog(@"教练员套路手册pdf 文件夹 不存在 要创建");
        NSError *error;
        BOOL success = [[NSFileManager defaultManager] createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:&error];
        if (success) {
            //LLLog(@"创建 教练员套路手册pdf 文件夹 成功! %@", folderPath);
        } else {
            //LLLog(@"创建 教练员套路手册pdf 文件夹 失败");
        }
    }
    return folderPath;
}


///删掉沙盒的所有PDF 连同记录信息的 plist文件
+ (void)iDeleteAllPDF {
    NSString *folderPath = [ISPDFProgressPoster iRequire_Local_PDF_FolderPath];
    NSError *removeResult;
    if ([[NSFileManager defaultManager] removeItemAtPath:folderPath error:&removeResult]) {
        //NSLog(@"✏️ %@ 整个文件夹干掉 成功", folderPath);
    } else {
        //NSLog(@"✏️ %@ 干掉文件夹失败: %@", folderPath, removeResult);
    }
}

@end
