//
//  SelectionTableViewController.m
//  ObjectiveCTools
//
//  Created by yuency on 2018/12/7.
//  Copyright © 2018年 yuency. All rights reserved.
//

#import "SelectionTableViewController.h"
#import "SelectionCell.h"

@interface SelectionTableViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation SelectionTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [self.tableView registerClass:[SelectionCell class] forCellReuseIdentifier:[SelectionCell forCellWithReuseIdentifier]];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    
    NSIndexPath *path = [NSIndexPath indexPathForRow:1 inSection:0];
    // 如果要让默认 cell 选中同时触发选中事件,需要手动调用 didSelectRowAtIndexPath
    if ([self.tableView.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
        [self.tableView.delegate tableView:self.tableView didSelectRowAtIndexPath:path];
    }
    // 设置默认选中的 cell
    [self.tableView selectRowAtIndexPath:path animated:YES scrollPosition:UITableViewScrollPositionTop];
    
    
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SelectionCell *cell = [tableView dequeueReusableCellWithIdentifier:[SelectionCell forCellWithReuseIdentifier] forIndexPath:indexPath];
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [NSString stringWithFormat:@"分组头%ld",section];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"选中事件");
}

@end
