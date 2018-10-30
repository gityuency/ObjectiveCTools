//
//  ItemCollectionView.h
//  姬友大人
//
//  Created by 姬友大人 on 2019/7/19.
//  Copyright © 2019年 姬友大人. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemView.h"

@class ItemCollectionView;

/// 视图的协议
@protocol ItemViewDataSource <NSObject>
@required
/// 每一个格子是什么
- (ItemView *)itemCollectionView:(ItemCollectionView *)itemCollectionView cellForRowAtIndexPath:(NSIndexPath *)indexpath;
/// 每一行有多少个格子
- (NSInteger)itemCollectionView:(ItemCollectionView *)itemCollectionView numberOfRowsInSection:(NSInteger)section;
@optional
/// 一共有多少行
- (NSInteger)numberOfSectionsAt:(ItemCollectionView *)itemCollectionView;
/// 设置每一行的头视图
- (UIView *)itemCollectionView:(ItemCollectionView *)itemCollectionView headerInSection:(NSInteger)section;
/// 点击事件
- (void)itemCollectionView:(ItemCollectionView *)itemCollectionView didSelectedIndexPath:(NSIndexPath *)indexpath;
@end

/// 装载所有的小格子
@interface ItemCollectionView : UIScrollView
/// 数据代理
@property (nonatomic, weak) id<ItemViewDataSource> dataSource;
/// 重新创作视图
- (void)createCollectionView;
@end

