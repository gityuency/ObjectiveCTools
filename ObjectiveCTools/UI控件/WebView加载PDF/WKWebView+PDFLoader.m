//
//  WKWebView+PDFLoader.m
//  ObjectiveCTools
//
//  Created by aidong on 2020/12/14.
//  Copyright © 2020 姬友大人. All rights reserved.
//

#import "WKWebView+PDFLoader.h"
#import <objc/runtime.h>
#import "ISPDFProgressPoster.h"

@interface WKWebView () <WKNavigationDelegate, ISPDFProgressPosterDelegate>

//显示进度的label
@property (nonatomic, strong) UILabel *labelProgress;

//记录PDF的名字
@property (nonatomic, strong) NSString *pdfNameKey;

@end

@implementation WKWebView (PDFLoader)

static NSString *keyLabel = @"keyLabel";

static NSString *keyPDFName = @"keyPDFName";

- (void)setLabelProgress:(UILabel *)labelProgress {
    objc_setAssociatedObject(self, &keyLabel, labelProgress, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UILabel *)labelProgress {
    return objc_getAssociatedObject(self, &keyLabel);
}

- (void)setPdfNameKey:(NSString *)pdfNameKey {
    objc_setAssociatedObject(self, &keyPDFName, pdfNameKey, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (NSString *)pdfNameKey {
    return objc_getAssociatedObject(self, &keyPDFName);
}

- (void)dealloc {
    NSLog(@"已经销毁, 没有循环引用");
}

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {

    
    [[ISPDFProgressPoster shared] loddNextPDF:webView];
    
    //隐藏左上角页码
    //[self performSelector:@selector(hideLableForView:) withObject:self afterDelay:0.2f];
}

//隐藏pdf页码
- (void)hideLableForView:(UIView*)view {
    for (UIView * subView in view.subviews) {
        if([subView isKindOfClass:[UILabel class]]){
            if (subView.tag == 998) { //这个是自己写的显示进度的label
                continue;
            } else {
                UIView *v =  subView.superview.superview;
                v.superview.superview.hidden = YES;
            }
        } else {
            //注意!在这里更改了 webview 背景色
            //view.backgroundColor = [AppTheme sharedTheme].colorWhite;
            [self hideLableForView:subView];
        }
    }
}

///加载网络的 PDF
- (void)loadPDF:(NSString *)url {
    
    NSString *filePath = [ISPDFProgressPoster iRequire_PDF_SandBox_Path:url];
    
    self.navigationDelegate = self;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        
        self.labelProgress.hidden = YES;
        [[ISPDFProgressPoster shared] loadPDFInQueue:self filePath:filePath];
        
    } else {
        
        self.labelProgress.hidden = NO;
        [self loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@""]]];
        
        if (self.labelProgress == nil) { ///显示一下下载进度
            self.labelProgress = [[UILabel alloc] init];
            self.labelProgress.tag = 998;
            self.labelProgress.font = [UIFont systemFontOfSize:14];
            self.labelProgress.textColor = UIColor.blueColor;
            self.labelProgress.text = @"即将加载...";
            [self addSubview:self.labelProgress];
            self.labelProgress.frame = CGRectMake(0, 0, 100, 80);
            self.labelProgress.center = self.center;
        }
        [[ISPDFProgressPoster shared] downloadPDF:url forWKWebview:self];
    }
}

///正在下载的时候接受进度
- (void)pdfPosterReceiveProgress:(NSString *)progress {
    self.labelProgress.text = progress;
}

///通知下载完成
- (void)pdfPosterFinish:(NSString *)filePath {
    self.labelProgress.hidden = YES;
    
    [[ISPDFProgressPoster shared] loadPDFInQueue:self filePath:filePath];
}

@end
