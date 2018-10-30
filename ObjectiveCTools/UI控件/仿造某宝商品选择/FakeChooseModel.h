//
//  FakeChooseModel.h
//  ObjectiveCTools
//
//  Created by 姬友大人 on 2018/10/30.
//  Copyright © 2018年 姬友大人. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FakeChooseModel : NSObject

/// 名称
@property (strong,nonatomic) NSString *sectionName;
/// 详情列表
@property (strong,nonatomic) NSMutableArray *itemArray;

@end

typedef NS_ENUM(NSInteger, ItemType) {  // 0 是默认值, 不能设置为 0
    ItemDisable = 4,       //不可选
    ItemForceSelected = 1, //强制选中
    ItemSelected = 2,      //选中
    ItemUnSelected = 3     //未选中
};

@interface FakeItemModel : NSObject
/// 名称
@property (strong,nonatomic) NSString *itemName;
/// 自定义属性 标记选项状态
@property (assign,nonatomic) ItemType itemType;

@end

NS_ASSUME_NONNULL_END
