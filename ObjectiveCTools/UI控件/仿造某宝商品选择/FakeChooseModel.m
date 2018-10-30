//
//  FakeChooseModel.m
//  ObjectiveCTools
//
//  Created by 姬友大人 on 2018/10/30.
//  Copyright © 2018年 姬友大人. All rights reserved.
//

#import "FakeChooseModel.h"

@implementation FakeChooseModel

- (instancetype)init {
    if (self = [super init]) {
        _itemArray = [NSMutableArray array];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end


@implementation FakeItemModel


@end
