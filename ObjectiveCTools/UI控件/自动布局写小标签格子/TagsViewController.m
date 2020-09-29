//
//  TagsViewController.m
//  ObjectiveCTools
//
//  Created by aidong on 2020/9/29.
//  Copyright © 2020 姬友大人. All rights reserved.
//

#import "TagsViewController.h"
#import "Masonry.h"
#import "YXTagsView.h"

@interface TagsViewController ()

@property (nonatomic, strong) YXTagsView *tagsView;

@end

@implementation TagsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tagsView = [[YXTagsView alloc] init];
    _tagsView.arrayTags = @[@"可以", @"在", @"添加到", @"父视图之前", @"设置", @"数据"];
    _tagsView.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:_tagsView];
    [_tagsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.top.equalTo(self.view).offset(100);
        //不用给高度，高度由内部的tags个数自动撑开，只需要设置好这个视图的宽度即可。
    }];
    _tagsView.arrayTags = @[@"也可以", @"在", @"添加到", @"父视图", @"之后", @"设置", @"数据"];
    
}

- (IBAction)actionNeibianju:(UIButton *)sender {
    NSInteger a = arc4random_uniform(30);
    NSInteger b = arc4random_uniform(30);
    NSInteger c = arc4random_uniform(30);
    NSInteger d = arc4random_uniform(30);
    self.tagsView.contentInset = UIEdgeInsetsMake(a, b, c, d);
}

- (IBAction)actionGeshu:(UIButton *)sender {
    NSArray *aaaaaa = @[@"愿", @"天", @"堂", @"没", @"有", @"bug", @"从", @"此", @"不", @"写", @"代", @"码", @"戏说不是胡说", @"编不是乱编"];
    NSMutableArray *tagArray = [NSMutableArray array];
    NSInteger ttttttt = arc4random_uniform(20);
    for (NSInteger j = 0; j < ttttttt; j ++) {
        NSMutableString *s = [[NSMutableString alloc] init];
        NSInteger suijishu = arc4random_uniform(5) + 1; //文字长度随机数
        NSMutableArray *mmmmm = [NSMutableArray arrayWithArray:aaaaaa];
        for (NSInteger i = 0; i < suijishu; i ++) {
            int shuzuchuangdu = (int)mmmmm.count;
            NSInteger k = arc4random_uniform(shuzuchuangdu);
            [s appendFormat:@"%@", mmmmm[k]];
            [mmmmm removeObjectAtIndex:k];
        }
        [tagArray addObject:s];
    }
    NSLog(@"%@", tagArray);
    self.tagsView.arrayTags = tagArray;
}

- (IBAction)actionHanglie:(UIButton *)sender {
    self.tagsView.spacingRow = arc4random_uniform(30);
    self.tagsView.spacingColumn = arc4random_uniform(30);
}

@end
