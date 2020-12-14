//
//  PDFCell.m
//  ObjectiveCTools
//
//  Created by aidong on 2020/12/14.
//  Copyright © 2020 姬友大人. All rights reserved.
//

#import "PDFCell.h"

@implementation PDFCell

+ (NSString *)resuseid {
    return NSStringFromClass([self class]);
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _webView = [[WKWebView alloc] initWithFrame:self.bounds];
        _webView.backgroundColor = UIColor.whiteColor;
        [self.contentView addSubview:_webView];
    }
    return self;
}


@end


@implementation PDFCellModel


@end
