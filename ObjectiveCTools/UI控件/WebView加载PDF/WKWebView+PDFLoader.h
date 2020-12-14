//
//  WKWebView+PDFLoader.h
//  ObjectiveCTools
//
//  Created by aidong on 2020/12/14.
//  Copyright © 2020 姬友大人. All rights reserved.
//

#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WKWebView (PDFLoader)

///加载网络的 PDF
- (void)loadPDF:(NSString *)url;

@end

NS_ASSUME_NONNULL_END
