//
//  ScaleScrollViewController.m
//  ObjectiveCTools
//
//  Created by 姬友大人 on 2018/10/25.
//  Copyright © 2018年 姬友大人. All rights reserved.
//

#import "ScaleScrollViewController.h"
#import "UIImage+Image.h"

static const CGFloat OriOffset = -240;  //图片高度 + 绿条 高度
static const CGFloat OriHeight = 200;   //图片高度

@interface ScaleScrollViewController () <UITableViewDelegate, UITableViewDataSource>

/// 表格
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/// 图片高度,默认 200
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstant;

@end

@implementation ScaleScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *titleView = [[UILabel alloc] init];
    titleView.text = @"姬友大人";
    [titleView sizeToFit];
    titleView.textColor = [UIColor colorWithWhite:0 alpha:0];
    self.navigationItem.titleView = titleView;
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    //不要偏移量
    if (@available(iOS 11.0, *)) {  //在高版本的手机上要用这句话 否则不生效
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    // 设置导航条背景 必须是UIBarMetricsDefault
    // 当背景图片为 nil 时候,系统会自动生成一张半透明的图片, 设置为导航条
    // [[UIImage alloc] init] 这个办法就能弄成透明
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    
    // 去掉阴影
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
    // 设置顶部缩进
    self.tableView.contentInset = UIEdgeInsetsMake(-OriOffset, 0, 0, 0);
}

/*
 更改 图片的填充模式为  Aspect Fil / Scall to Fill, 可以看到不同的缩放效果
 设置图片 clip subviews, 裁剪掉因为图片尺寸过大而看到超出边界的部分
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat offset = scrollView.contentOffset.y - OriOffset;
    
    CGFloat h = OriHeight - offset;
    
    /// 让绿色的条放到导航栏下方的办法
    CGFloat topY = [UIApplication sharedApplication].statusBarFrame.size.height + self.navigationController.navigationBar.frame.size.height;
    
    if (h < topY) { h = topY; }
    
    self.heightConstant.constant = h;
    
    //根据透明度生成图片 找最大值
    CGFloat alpha = offset * 1 / 136.0;
    if (alpha >= 1) { alpha = 0.99; }
    
    //修改导航条背景图片
    UIColor *alphaColor = [UIColor colorWithWhite:1 alpha:alpha];
    //把颜色生成图片
    UIImage *alphaImage = [UIImage image_WithColor:alphaColor];
    //修改导航条的背景图片
    [self.navigationController.navigationBar setBackgroundImage:alphaImage forBarMetrics:UIBarMetricsDefault];
    
    //拿到标题
    UILabel *titleLabel = (UILabel *)self.navigationItem.titleView;
    titleLabel.textColor = [UIColor colorWithWhite:0 alpha:alpha];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"表格 %ld",indexPath.row];
    return cell;
}

@end
