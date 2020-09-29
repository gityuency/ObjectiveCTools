//
//  YXTagsView.m
//  ObjectiveCTools
//
//  Created by aidong on 2020/9/29.
//  Copyright © 2020 姬友大人. All rights reserved.
//

#import "YXTagsView.h"
#import "Masonry.h"

#pragma mark - 小格子
@interface PaddingLabel : UILabel
@property (nonatomic) UIEdgeInsets insets;
@end

@implementation PaddingLabel
- (instancetype)init {
    self = [super init];
    if (self) {
        _insets = UIEdgeInsetsMake(10, 20, 10, 20);
        self.font = [UIFont boldSystemFontOfSize:14];
        self.textColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor redColor];
        self.clipsToBounds = YES;
        self.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}
- (void)drawTextInRect:(CGRect)rect {
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, _insets)];
}
- (CGSize)intrinsicContentSize {
    CGSize superContentSize = [super intrinsicContentSize];
    CGFloat width = superContentSize.width + _insets.left + _insets.right;
    CGFloat heigth = superContentSize.height + _insets.top + _insets.bottom;
    return CGSizeMake(width, heigth);
}
@end


#pragma mark - 视图
@interface YXTagsView ()

@property (nonatomic, strong) UIView *containerView;

@end

@implementation YXTagsView

- (instancetype)init {
    self = [super init];
    if (self) {
        _spacingRow = 10;
        _spacingColumn = 10;
        _containerView = [[UIView alloc] init];
        [self addSubview:_containerView];
        [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

- (void)setArrayTags:(NSArray<NSString *> *)arrayTags {
    _arrayTags = arrayTags;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)setContentInset:(UIEdgeInsets)contentInset {
    _contentInset = contentInset;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)setSpacingRow:(CGFloat)spacingRow {
    _spacingRow = spacingRow;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)setSpacingColumn:(CGFloat)spacingColumn {
    _spacingColumn = spacingColumn;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

///开始布局格子
- (void)layoutChildItems {
    
    //先把原来的数据移除掉
    for (UIView *v in self.containerView.subviews) {
        [v removeFromSuperview];
    }
    
    self.containerView.backgroundColor = [UIColor brownColor];
    [self.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@(_contentInset));
    }];
    
    //宽度
    CGFloat containerWidth = self.containerView.frame.size.width;
    //如果宽度小于等于0,表示这个视图还没有完成约束,拿不到宽度,也就无法继续做下一步的小格子宽度排布计算
    if (containerWidth <= 0) {
        NSLog(@"❗️❗️❗️❗️ YXTagsView 视图没有宽度,暂不能进行排布!");
        return;
    }
    
    //累计宽度
    CGFloat maxX = 0;
    //记录上一个格子
    PaddingLabel *beforeLabel;
    //记录上一个底部约束
    __block MASConstraint *bottomCons = nil;
    
    //添加新的数据
    for (NSInteger i = 0; i < _arrayTags.count; i ++) {
        
        PaddingLabel *label = [[PaddingLabel alloc] init];
        label.text = _arrayTags[i];
        
        [_containerView addSubview:label];
        //先做一下约束,然后拿到宽度
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(_containerView);
        }];
        [label setNeedsLayout];
        [label layoutIfNeeded];
        
        CGFloat labelWidth = label.frame.size.width;
        CGFloat labelHeight = label.frame.size.height;
        label.layer.cornerRadius = labelHeight / 2.0;
        
        if ((maxX + labelWidth + _spacingRow) > containerWidth) { //换到下一行的第一个
            [bottomCons uninstall];
            [label mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_containerView);
                make.top.equalTo(beforeLabel.mas_bottom).offset(_spacingColumn);
                bottomCons = make.bottom.equalTo(_containerView);
            }];
            maxX = labelWidth;
        } else { //继续在这一行
            if (beforeLabel) { //同一行 第2,3,4...个
                [bottomCons uninstall];
                [label mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(beforeLabel.mas_right).offset(_spacingRow);
                    make.top.equalTo(beforeLabel);
                    bottomCons = make.bottom.equalTo(_containerView);
                }];
                maxX += labelWidth + _spacingRow;
            } else { //第一行第一个
                [label mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(_containerView);
                    make.top.equalTo(_containerView);
                    bottomCons = make.bottom.equalTo(_containerView);
                }];
                maxX = labelWidth;
            }
        }
        beforeLabel = label;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self layoutChildItems];
}

@end
