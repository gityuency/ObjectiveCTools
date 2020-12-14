//
//  PDFCell.h
//  ObjectiveCTools
//
//  Created by aidong on 2020/12/14.
//  Copyright © 2020 姬友大人. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface PDFCell : UICollectionViewCell

///复用id
+ (NSString *)resuseid;

///格子里也可能放的是pdf
@property (nonatomic, strong) WKWebView *webView;

@end


@interface PDFCellModel : NSObject

///这里weak,需要弱引用
@property (nonatomic, weak) WKWebView *webView;

///这里用copy,因为这个模型直接从数组删掉, 这个值不需要了
@property (nonatomic, copy) NSString *filePath;

@end

NS_ASSUME_NONNULL_END
