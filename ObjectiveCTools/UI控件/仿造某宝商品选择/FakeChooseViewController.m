//
//  FakeChooseViewController.m
//  ObjectiveCTools
//
//  Created by 姬友大人 on 2018/10/30.
//  Copyright © 2018年 姬友大人. All rights reserved.
//

#import "FakeChooseViewController.h"
#import "ItemCollectionView.h"
#import "FakeChooseModel.h"

@interface FakeChooseViewController () <ItemViewDataSource>

/// 商品选择视图
@property (nonatomic, strong) ItemCollectionView *itemCollectionView;
/// 数据
@property (strong, nonatomic) NSMutableArray *itemCollectionArray;

@end

@implementation FakeChooseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 背景色
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 商品视图
    self.itemCollectionView = [[ItemCollectionView alloc] initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 150)];
    self.itemCollectionView.dataSource = self;
    [self.view addSubview:self.itemCollectionView];
    
    // 造一些假数据
    NSArray *array = @[
                       @{
                           @"sectionName": @"音乐家",
                           @"sectionArray": @[
                                   @{@"itemName": @"Johann Sebastian Bach"},
                                   @{@"itemName": @"Handel，GeorgFrideric"},
                                   @{@"itemName": @"Franz Joseph Haydn"},
                                   @{@"itemName": @"Wolfgang Amadeus Mozart"},
                                   @{@"itemName": @"Ludwig van Beethoven"},
                                   @{@"itemName": @"Franz Seraph Peter Schubert"},
                                   @{@"itemName": @"Hector Louis Berlioz"},
                                   ],
                           },
                       @{
                           @"sectionName": @"书籍",
                           @"sectionArray": @[
                                   @{@"itemName": @"Effective JavaScript：编写高质量JavaScript代码的68个有效方法"},
                                   @{@"itemName": @"MySQL索引背后的数据结构及算法原理"},
                                   @{@"itemName": @"从汇编语言到windows内核编程"},
                                   @{@"itemName": @"You-Dont-Know-JS (深入JavaScript语言核心机制的系列图书)"},
                                   @{@"itemName": @"大型集群上的快速和通用数据处理架构"},
                                   @{@"itemName": @"Network programming with Go 中文翻译版本"},
                                   ],
                           },
                       @{
                           @"sectionName": @"颜色",
                           @"sectionArray": @[
                                   @{@"itemName": @"黄色"},
                                   @{@"itemName": @"深红色"},
                                   @{@"itemName": @"淡青色"},
                                   @{@"itemName": @"金色"},
                                   @{@"itemName": @"玫瑰色"},
                                   @{@"itemName": @"天蓝色"},
                                   @{@"itemName": @"草色"},
                                   @{@"itemName": @"宝石色"},
                                   ],
                           },
                       @{
                           @"sectionName": @"内存",
                           @"sectionArray": @[
                                   @{@"itemName": @"时光不停地在转动"},
                                   @{@"itemName": @"现在你是谁的英雄"},
                                   @{@"itemName": @"回到你和我的时空"},
                                   @{@"itemName": @"抱紧了我让我心痛"},
                                   ],
                           },
                       ];
    
    self.itemCollectionArray = [NSMutableArray array];
    for (NSDictionary *dic in array) {
        FakeChooseModel *info = [[FakeChooseModel alloc] init];
        [info setValuesForKeysWithDictionary:dic];
        for (NSDictionary *subDic in dic[@"sectionArray"]) {
            FakeItemModel *item = [[FakeItemModel alloc] init];
            [item setValuesForKeysWithDictionary:subDic];
            if (arc4random_uniform(8) % 7 == 1) {
                item.itemType = ItemDisable;
            } else {
                item.itemType = ItemUnSelected;
            }
            [info.itemArray addObject:item];
        }
        [self.itemCollectionArray addObject:info];
    }
    
    // 加载视图
    [self.itemCollectionView createCollectionView];
}


#pragma mark - ItemViewDataSource 代理
- (NSInteger)numberOfSectionsAt:(ItemCollectionView *)itemCollectionView {
    return self.itemCollectionArray.count;
}

- (NSInteger)itemCollectionView:(ItemCollectionView *)itemCollectionView numberOfRowsInSection:(NSInteger)section {
    FakeChooseModel *info = self.itemCollectionArray[section];
    return info.itemArray.count;
}

- (ItemView *)itemCollectionView:(ItemCollectionView *)itemCollectionView cellForRowAtIndexPath:(NSIndexPath *)indexpath {
    FakeChooseModel *info = self.itemCollectionArray[indexpath.section];
    FakeItemModel *item = info.itemArray[indexpath.row];
    ItemView *v = [[ItemView alloc] init];
    [v setText:item.itemName minWith:60 maxWith:[UIScreen mainScreen].bounds.size.width font:[UIFont systemFontOfSize:16]];
    
    if (item.itemType == ItemForceSelected || item.itemType == ItemSelected) {
        v.itemSelected = YES;
    } else if (item.itemType == ItemDisable) {
        v.itemDisable = YES;
    } else if (item.itemType == ItemUnSelected) {
        v.itemSelected = NO;
    }
    return v;
}

- (UIView *)itemCollectionView:(ItemCollectionView *)itemCollectionView headerInSection:(NSInteger)section {
    FakeChooseModel *info = self.itemCollectionArray[section];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 0, 40)];
    label.text = info.sectionName;
    return label;
}

- (void)itemCollectionView:(ItemCollectionView *)itemCollectionView didSelectedIndexPath:(NSIndexPath *)indexpath {
    
    //更改模型的状态
    FakeChooseModel *info = self.itemCollectionArray[indexpath.section];
    for (NSInteger j = 0; j < info.itemArray.count; j++) {
        FakeItemModel *item = info.itemArray[j];
        if (item.itemType == ItemDisable) {
            continue;
        }
        if (item.itemType == ItemForceSelected) {
            continue;
        }
        item.itemType = ItemUnSelected;
    }
    FakeItemModel *item = info.itemArray[indexpath.row];
    item.itemType = ItemSelected;
    
    
    // 查看结果
    NSMutableString *result = [NSMutableString string];
    for (FakeChooseModel *infoR in self.itemCollectionArray) {
        for (FakeItemModel *itemR in infoR.itemArray) {
            if (itemR.itemType == ItemForceSelected || itemR.itemType == ItemSelected) {
                [result appendFormat:@" * %@", itemR.itemName];
            }
        }
    }
    NSLog(@"%@", result);
}


@end


/*
 
UICollectionView根据内容高度调整尺寸
 
 - (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
 if (collectionView == self.collectionView) {
 if([indexPath row] == ((NSIndexPath*)[[collectionView indexPathsForVisibleItems] lastObject]).row){
 dispatch_async(dispatch_get_main_queue(), ^{
 self.heightOfCollectionView.constant = self.collectionView.contentSize.height;
 });
 }
 }
 }

 */
