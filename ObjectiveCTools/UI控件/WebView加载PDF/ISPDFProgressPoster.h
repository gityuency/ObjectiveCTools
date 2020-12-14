//
//  ISPDFProgressPoster.h
//  ObjectiveCTools
//
//  Created by aidong on 2020/12/14.
//  Copyright © 2020 姬友大人. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN


@protocol ISPDFProgressPosterDelegate <NSObject>

@optional
///正在下载的时候接受进度
- (void)pdfPosterReceiveProgress:(NSString *)progress;
///通知下载完成
- (void)pdfPosterFinish:(NSString *)filePath;

@end

@interface ISPDFProgressPoster : NSObject

///单例
+ (instancetype)shared;

///加载PDF
- (void)loadPDFInQueue:(WKWebView *)webView filePath:(NSString *)filePath;
///加载下一个
- (void)loddNextPDF:(WKWebView *)webView;

/// 下载PDF
- (void)downloadPDF:(NSString *)stringURL forWKWebview:(WKWebView *)webView;

/// 根据url地址获取这个pdf文件的存储地址
+ (NSString *)iRequire_PDF_SandBox_Path:(NSString *)stringUrl;

///删掉所有PDF
+ (void)iDeleteAllPDF;

@end


NS_ASSUME_NONNULL_END
