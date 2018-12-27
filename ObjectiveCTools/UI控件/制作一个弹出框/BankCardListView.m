//
//  BankCardListView.m
//  CrfLease
//
//  Created by yuency on 2019/7/19.
//  Copyright © 2019年 yuency. All rights reserved.
//

#import "BankCardListView.h"

/// 这是一个内部类, 用于弹框里的表格
@interface BankListCell : UITableViewCell
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *line;
@end

@implementation BankListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addSubview:self.titleLabel];
        [self addSubview:self.line];
    }
    return self;
}
- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    return _line;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    _titleLabel.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    _line.frame = CGRectMake(0, self.frame.size.height - 0.5, self.frame.size.width, 0.5);
}

@end


/// 弹框实现
@interface BankCardListView() <UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (nonatomic, strong) NSArray<NSString *> *array;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSpace;

@end

static BankCardListView *bankCardListView = nil;
static BCLVBlockSelection actionBlockSelect = nil;
static BCLVBlockAdd actionBlockAdd = nil;

@implementation BankCardListView

+ (void)showWith:(NSString *)title list:(NSArray<NSString *> *)listArray selectIndex:(BCLVBlockSelection)blockSelect addNew:(BCLVBlockAdd)blockAdd {
    bankCardListView = [[NSBundle mainBundle] loadNibNamed:@"BankCardListView" owner:nil options:nil].firstObject;
    bankCardListView.frame = UIScreen.mainScreen.bounds;
    bankCardListView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4]; //用这个办法设置半透明背景色
    actionBlockSelect = blockSelect;
    actionBlockAdd = blockAdd;
    bankCardListView.labelTitle.text = title;
    bankCardListView.array = listArray;
    [bankCardListView.tableView registerClass:[BankListCell class] forCellReuseIdentifier:@"c"];
    bankCardListView.tableView.delegate = bankCardListView;
    bankCardListView.tableView.dataSource = bankCardListView;
    bankCardListView.tableView.tableFooterView = [UIView new];
    [bankCardListView.tableView reloadData];
    [[[UIApplication sharedApplication].delegate window] addSubview:bankCardListView];
}

- (void)didMoveToWindow {
    [super didMoveToWindow];
    
    //装内容的 View, 设置了 左(0) 下(0) 右(0) 高(300) 这四个约束, 然后做底部高度约束动画
    
    bankCardListView.bottomSpace.constant = -300;
    [bankCardListView layoutIfNeeded]; //先把约束更新
    
    bankCardListView.bottomSpace.constant = 0;
    
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        [bankCardListView layoutIfNeeded];
    } completion:nil];
}


- (IBAction)close:(UIButton *)sender {
    [self disMiss];
}

- (IBAction)addNewCard:(UIButton *)sender {
    actionBlockAdd();
    [self disMiss];
}

- (void)disMiss{
    [self removeFromSuperview];
    actionBlockSelect = nil;
    actionBlockAdd = nil;
    bankCardListView = nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.array.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BankListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"c" forIndexPath:indexPath];
    cell.titleLabel.text = self.array[indexPath.row];
    return  cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    actionBlockSelect(indexPath.row);
    [self disMiss];
}

@end
