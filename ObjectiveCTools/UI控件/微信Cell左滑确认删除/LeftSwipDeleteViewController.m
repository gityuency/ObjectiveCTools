//
//  LeftSwipDeleteViewController.m
//  ObjectiveCTools
//
//  Created by yuency on 2019/1/24.
//  Copyright © 2019年 yuency. All rights reserved.
//

#import "LeftSwipDeleteViewController.h"

@interface LeftSwipDeleteViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *mainTableView;

@property (nonatomic, strong) NSMutableArray *dataArr;

@property (nonatomic, strong) UILabel *confirmDeleteLabel;

@property (nonatomic, strong) UIBarButtonItem *rightButton;

@property (nonatomic, strong) NSMutableArray *selectedArr;


@end

@implementation LeftSwipDeleteViewController


- (UILabel *)confirmDeleteLabel{
    if (!_confirmDeleteLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.text = @"确认删除";
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [UIColor colorWithRed:250/255.0 green:62/255.0 blue:56/255.0 alpha:1];
        label.userInteractionEnabled = YES;
        _confirmDeleteLabel = label;
    }
    return _confirmDeleteLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"文件管理";
    
    self.dataArr = [NSMutableArray arrayWithObjects:@"图片",@"视频",@"文档",@"音频",@"压缩文件",@"其他",@"TableViewDemo.zip", nil];
    
    self.mainTableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    [self.view addSubview:self.mainTableView];
    
    self.mainTableView.tableFooterView = [UIView new];
    
    for (UIGestureRecognizer *ges in self.mainTableView.gestureRecognizers) {
        if ([ges isKindOfClass:NSClassFromString(@"_UISwipeActionPanGestureRecognizer")]) {
            [ges addTarget:self action:@selector(_swipeRecognizerDidRecognize:)];
        }
    }
    
    
    self.rightButton = [[UIBarButtonItem alloc] initWithTitle:@"选择" style:UIBarButtonItemStylePlain target:self action:@selector(beginToSelectFile:)];
    self.navigationItem.rightBarButtonItem = self.rightButton;
    
}

- (void)beginToSelectFile:(UIBarButtonItem *)rightItem{
    NSString *itemTitle = rightItem.title;
    
    if ([itemTitle isEqualToString:@"选择"]) {
        self.selectedArr = [NSMutableArray array];
        [self.mainTableView setEditing:YES animated:YES];
        rightItem.title = @"完成";
        [self addNavLeftItemWithTitle:@"全选" andSeloctor:@selector(setSelectAllFile)];
    }else if ([itemTitle isEqualToString:@"完成"]){
        [self.mainTableView setEditing:NO animated:YES];
        rightItem.title = @"选择";
        self.navigationItem.leftBarButtonItem = nil;
    }
}

- (void)addNavLeftItemWithTitle:(NSString *)title andSeloctor:(SEL)selector{
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:selector];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)setSelectAllFile{
    [self addNavLeftItemWithTitle:@"取消全选" andSeloctor:@selector(setCancelSelectAllFile)];
    
    for (int i = 0; i< self.dataArr.count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        [self.mainTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionTop];
    }
    
    if (self.selectedArr.count >0) {
        [self.selectedArr removeAllObjects];
    }
    [self.selectedArr addObjectsFromArray:self.dataArr];
    
}

- (void)setCancelSelectAllFile{
    
    for (int i = 0; i< self.dataArr.count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        [self.mainTableView deselectRowAtIndexPath:indexPath animated:NO];
    }
    [self.selectedArr removeAllObjects];
    [self addNavLeftItemWithTitle:@"全选" andSeloctor:@selector(setSelectAllFile)];
}

- (void)_swipeRecognizerDidRecognize:(UISwipeGestureRecognizer *)swipe{
    if (_confirmDeleteLabel.superview) {
        [_confirmDeleteLabel removeFromSuperview];
        _confirmDeleteLabel = nil;
    }
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UITableViewCell"];
    }
    cell.textLabel.text = self.dataArr[indexPath.row];
    if (indexPath.row == self.dataArr.count - 1) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%u MB",arc4random()%20];
        cell.accessoryType = UITableViewCellAccessoryDetailButton;
        cell.imageView.image = [UIImage imageNamed:@"file_zipped"];
    }else{
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%u项",arc4random()%20];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.imageView.image = [UIImage imageNamed:@"file_folder"];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.rightButton.title isEqualToString:@"完成"]) {
        [self.selectedArr addObject:self.dataArr[indexPath.row]];
    } else if ([self.rightButton.title isEqualToString:@"选择"]){
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.rightButton.title isEqualToString:@"完成"]) {
        [self.selectedArr removeObject:self.dataArr[indexPath.row]];
        if (self.selectedArr.count == 0) {
            
        }else{
            
        }
    } else if ([self.rightButton.title isEqualToString:@"选择"]) {
        
    }
    
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

//API_AVAILABLE(ios(11.0))
- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath{
    UIContextualAction *deleteAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"删除" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        
        if (self.confirmDeleteLabel.superview) {
            [self.dataArr removeObjectAtIndex:indexPath.row];
            [self.mainTableView reloadData];
        } else {
            NSLog(@"显示确认删除Label");
            // 核心代码
            UIView *rootView = nil; // 这个rootView指的是UISwipeActionPullView，最上层的父view
            if ([sourceView isKindOfClass:[UILabel class]]) {
                rootView = sourceView.superview.superview;
                self.confirmDeleteLabel.font = ((UILabel *)sourceView).font;
            }
            self.confirmDeleteLabel.frame = CGRectMake(sourceView.bounds.size.width, 0, sourceView.bounds.size.width, sourceView.bounds.size.height);
            [sourceView.superview.superview addSubview:self.confirmDeleteLabel];
            
            [UIView animateWithDuration:0.7 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                CGRect labelFrame = self.confirmDeleteLabel.frame;
                labelFrame.origin.x = 0;
                labelFrame.size.width = rootView.bounds.size.width;
                self.confirmDeleteLabel.frame = labelFrame;
            } completion:^(BOOL finished) {
                
            }];
        }
        
    }];
    
    UIContextualAction *moreAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:@"更多" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        
        if (self.confirmDeleteLabel.superview) {
            [self.dataArr removeObjectAtIndex:indexPath.row];
            [self.mainTableView reloadData];
        } else {
            NSLog(@"更多");
        }
        
    }];
    
    UISwipeActionsConfiguration *config = [UISwipeActionsConfiguration configurationWithActions:@[deleteAction,moreAction]];
    config.performsFirstActionWithFullSwipe = NO;
    return config;
}

- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView leadingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}

//  在这个代理方法里，可以获取左滑按钮，进而修改其文字颜色，大小等
- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"将要开始编辑cell");
    
    for (UIView *subView in tableView.subviews) {
        if ([subView isKindOfClass:NSClassFromString(@"UISwipeActionPullView")]) {
            for (UIView *childView in subView.subviews) {
                if ([childView isKindOfClass:NSClassFromString(@"UISwipeActionStandardButton")]) {
                    UIButton *button = (UIButton *)childView;
                    button.titleLabel.font = [UIFont systemFontOfSize:18];
                }
            }
        }
    }
    
}

- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"已经结束编辑cell");
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    [self showAlertWithTitle:@"点击了详情按钮"];
}

- (void)showAlertWithTitle:(NSString *)title{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:title preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
