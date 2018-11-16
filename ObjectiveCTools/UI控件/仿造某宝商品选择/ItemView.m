//
//  ItemView.m
//  姬友大人
//
//  Created by 姬友大人 on 2019/7/19.
//  Copyright © 2019年 姬友大人. All rights reserved.
//

#import "ItemView.h"

@interface ItemView ()

/// 文本框
@property (nonatomic, strong) UILabel *label;
/// 装载内容
@property (nonatomic, strong) UIView *contentView;
/// 最小宽度
@property (nonatomic, assign) CGFloat *minWidth;
/// 选中的标题颜色  边框色
@property (nonatomic, strong) UIColor *selectedTitleColro;
/// 选中背景色
@property (nonatomic, strong) UIColor *selectedBgColor;
/// 未选中背景色
@property (nonatomic, strong) UIColor *unSelectedBgColor;
/// 未选中的标题颜色
@property (nonatomic, strong) UIColor *unSelectedTitleColor;
/// 不可点击的标题颜色
@property (nonatomic, strong) UIColor *disableTitleColor;
/// 点击事件(手势)
@property (nonatomic, strong) UITapGestureRecognizer *g;

@end

@implementation ItemView

- (instancetype)init {
    
    self = [super init];
    if (self) {
        
        _disableTitleColor = [UIColor grayColor];
        _selectedBgColor = [UIColor colorWithRed:1.00 green:0.91 blue:0.91 alpha:1.00];
        _unSelectedBgColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.00];
        _unSelectedTitleColor = [UIColor darkTextColor];
        _selectedTitleColro = [UIColor redColor];
        _minWidth = 0;
        
        _contentView = [[UIView alloc] init];
        _contentView.userInteractionEnabled = NO;
        _contentView.layer.cornerRadius = 5;
        [self addSubview:_contentView];
        
        _label = [[UILabel alloc] init];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.userInteractionEnabled = NO;
        _label.numberOfLines = 0;
        [self addSubview:_label];
        
        _isMultiLines = NO;

        _g = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click)];
        _g.numberOfTapsRequired = 1;
        [self addGestureRecognizer:_g];
    }
    return self;
}

- (void)click{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelected:)]) {
        [self.delegate didSelected:self];
    }
}

/// 设置 文本框的文字 文字的最小宽度 文字的字体
- (void)setText:(NSString *)text minWith:(CGFloat)minWith maxWith:(CGFloat)maxWith font:(UIFont *)font {
    CGFloat offset = 10;
    
    NSDictionary *dic = @{NSFontAttributeName: font};
    
    CGFloat maxW = [UIScreen mainScreen].bounds.size.width - offset * 2;
    
    CGSize stringSize = [text boundingRectWithSize:CGSizeMake(maxW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    
    CGFloat singleLineWidth = [text sizeWithAttributes:dic].width;  //计算单行字符串长度
    
    if (singleLineWidth > maxW) { //判断是否多行
        stringSize.width = maxW;
        self.isMultiLines = YES;
    } else if (stringSize.width < minWith) {  //判断是否小于最小宽度
        stringSize.width = minWith;
    }

    self.label.frame = CGRectMake(offset, offset, stringSize.width, stringSize.height);
    self.contentView.frame = CGRectMake(offset * 0.5, offset * 0.5, stringSize.width + offset, stringSize.height + offset);
    self.frame = CGRectMake(0, 0, self.label.frame.size.width + offset * 2, self.label.frame.size.height + offset * 2);
    self.label.text = text;
    self.label.font = font;
}

- (void)setItemSelected:(BOOL)itemSelected {
    _itemSelected = itemSelected;
    if (_itemSelected) {
        [self.g setEnabled:YES];
        self.contentView.layer.borderWidth = 1;
        self.contentView.layer.borderColor = self.selectedTitleColro.CGColor;
        self.contentView.backgroundColor = self.selectedBgColor;
        self.label.textColor = self.selectedTitleColro;
    } else {
        [self.g setEnabled:YES];
        self.contentView.layer.borderWidth = 0;
        self.contentView.backgroundColor = self.unSelectedBgColor;
        self.label.textColor = self.unSelectedTitleColor;
    }
}

- (void)setItemDisable:(BOOL)itemDisable {
    _itemDisable = itemDisable;
    if (_itemDisable) {
        [self.g setEnabled:NO];
        self.contentView.layer.borderWidth = 0;
        self.contentView.backgroundColor = self.unSelectedBgColor;
        self.label.textColor = self.disableTitleColor;
    }
}

@end
