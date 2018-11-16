//
//  ItemCollectionView.m
//  姬友大人
//
//  Created by 姬友大人 on 2019/7/19.
//  Copyright © 2019年 姬友大人. All rights reserved.
//

#import "ItemCollectionView.h"

@interface ItemCollectionView () <ItemViewDelegate>

/// 内容视图
@property (nonatomic, strong) UIView *contentView;
/// 每一行有多少个 默认 0 个
@property (nonatomic, assign) CGFloat rowCountOfSection;
/// 一共有多少行 默认1行
@property (nonatomic, assign) CGFloat sectionCount;
/// 临时数组
@property (nonatomic, strong) NSMutableArray *viewsArray;
/// 内部控件集合
@property (nonatomic, strong) NSArray *itemViewArray;

@end

@implementation ItemCollectionView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setUp];
}

- (void)setUp {
    _rowCountOfSection = 0;
    _sectionCount = 1;
    _viewsArray = [NSMutableArray array];
}

- (void)initView {
    
    if (self.contentView != nil) {
        [self.contentView removeFromSuperview];
    }
    self.contentView = [[UIView alloc] init];
    [self addSubview:self.contentView];
    
    /// 有多少行, 可选代理
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfSectionsAt:)]) {
        self.sectionCount = [self.dataSource numberOfSectionsAt:self];
    }
    
    /// 每一行有多少个格子,必选
    if (self.dataSource) {
        BOOL a = [self.dataSource respondsToSelector:@selector(itemCollectionView:numberOfRowsInSection:)];
        BOOL b = [self.dataSource respondsToSelector:@selector(itemCollectionView:cellForRowAtIndexPath:)];
        NSAssert((a && b), @"代理对象没有遵守协议!");
    } else {
        NSAssert(NO, @"代理对象为空!");
    }
    
    CGFloat allSectionHeight = 0;
    for (NSInteger i = 0; i < self.sectionCount; i++) {
        UIView *sectionView = [[UIView alloc] init];
        UIView *headView = [self.dataSource itemCollectionView:self headerInSection:i];
        headView.frame = CGRectMake(headView.frame.origin.x, 0, self.bounds.size.width, headView.frame.size.height);
        [sectionView addSubview:headView];
        CGFloat offsetY = headView.frame.size.height;
        UIView *lastrowCell;
        
        self.rowCountOfSection = [self.dataSource itemCollectionView:self numberOfRowsInSection:i];
        
        NSMutableArray *array = [NSMutableArray array];
        
        ItemView *lastCell = nil; //最后一个单元
        
        for (NSInteger k = 0; k < self.rowCountOfSection; k++) {
            NSIndexPath *index = [NSIndexPath indexPathForRow:k inSection:i];
            ItemView *rowCell = [self.dataSource itemCollectionView:self cellForRowAtIndexPath: index];
            rowCell.delegate = self;
            rowCell.indexPath = index;
            
            
            if (lastCell) {  //最后一个单元存在
                
                if (CGRectGetMaxX(lastCell.frame) + rowCell.frame.size.width > self.bounds.size.width) { //新来的这个在后面放不下
                    
                    offsetY += lastCell.frame.size.height;  //放不下就放到下一行
                    
                    rowCell.frame = CGRectMake(0, offsetY, rowCell.frame.size.width, rowCell.frame.size.height);
                    
                } else {
                    
                    if (lastCell.isMultiLines) { //上一个是多行, 当前就另起一行
                        offsetY += lastCell.frame.size.height;
                    }
                    
                    rowCell.frame = CGRectMake(CGRectGetMaxX(lastCell.frame), offsetY, rowCell.frame.size.width, rowCell.frame.size.height);
                }
                
            } else { //最后一个单元不存在
                
                rowCell.frame = CGRectMake(0, offsetY, rowCell.frame.size.width, rowCell.frame.size.height);
            }
            
            lastCell = rowCell;

            
            [sectionView addSubview:rowCell];
            lastrowCell = rowCell;
            [array addObject:rowCell];
        }
        CGFloat sectionHeight = CGRectGetMaxY(lastrowCell.frame) + 5; // +5是为了底部多留点空白
        sectionView.frame = CGRectMake(0, allSectionHeight, self.bounds.size.width, sectionHeight);
        [self.contentView addSubview:sectionView];
        allSectionHeight += sectionHeight;
        
        if (i != self.sectionCount - 1) { //最后一行不要分割线
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, sectionView.frame.size.height - 1, sectionView.frame.size.width, 1)];
            line.backgroundColor = [UIColor darkTextColor];
            [sectionView addSubview:line];
        }
        [self.viewsArray addObject:array];
    }
    self.contentView.frame = CGRectMake(0, 0, self.bounds.size.width, allSectionHeight);
    self.contentSize = self.contentView.frame.size;
    self.itemViewArray = self.viewsArray;
}


#pragma mark - ItemViewDelegate
- (void)didSelected:(ItemView *)itemView {
    
    for (ItemView *v in self.itemViewArray[itemView.indexPath.section]) {
        if (v.itemDisable) { continue; }
        v.itemSelected = NO;
    }
    itemView.itemSelected = YES;
    
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(itemCollectionView:didSelectedIndexPath:)]) {
        [self.dataSource itemCollectionView:self didSelectedIndexPath:itemView.indexPath];
    }
}

- (void)createCollectionView {
    [self setNeedsLayout];
    [self layoutIfNeeded];
    [self initView];
}

@end
