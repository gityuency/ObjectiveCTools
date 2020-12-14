//
//  PDFViewController.m
//  ObjectiveCTools
//
//  Created by aidong on 2020/12/14.
//  Copyright © 2020 姬友大人. All rights reserved.
//

#import "MyPDFViewController.h"
#import "ISPDFProgressPoster.h"
#import "WKWebView+PDFLoader.h"
#import "PDFCell.h"

@interface MyPDFViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

///集合视图 放图片 PDF
@property (nonatomic, strong) UICollectionView *collectionView;
///加载的数组
@property (nonatomic, strong) NSArray *array;

@end

@implementation MyPDFViewController


- (void)dealloc {
    NSLog(@"");
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [ISPDFProgressPoster iDeleteAllPDF];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.array = @[
    ];
    
    //放资料的
    UICollectionViewFlowLayout *l = [[UICollectionViewFlowLayout alloc] init];
    l.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    l.sectionInset = UIEdgeInsetsZero;
    l.headerReferenceSize = CGSizeZero;
    l.footerReferenceSize = CGSizeZero;
    l.minimumLineSpacing = 0;
    l.minimumInteritemSpacing = 0;
    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.collectionView = [[UICollectionView alloc] initWithFrame:rect collectionViewLayout:l];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.pagingEnabled = YES;
    self.collectionView.backgroundColor = UIColor.whiteColor;
    self.collectionView.showsHorizontalScrollIndicator = YES;
    if (@available(iOS 11.0, *)) {
        [self.collectionView setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    } else {
        // Fallback on earlier versions
    }
    [self.collectionView registerClass:[PDFCell class] forCellWithReuseIdentifier:[PDFCell resuseid]];
    [self.view addSubview:self.collectionView];
}



#pragma mark - 代理
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.array.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PDFCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[PDFCell resuseid] forIndexPath:indexPath];
    NSString *url = self.array[indexPath.row];
    [cell.webView loadPDF:url];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(collectionView.frame.size.width /2.0  , collectionView.frame.size.height /2.0 );
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end


