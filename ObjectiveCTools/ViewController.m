//
//  ViewController.m
//  ObjectiveCTools
//
//  Created by 姬友大人 on 2018/7/31.
//  Copyright © 2018年 姬友大人. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSArray *dataArray;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataArray = @[
                       @{@"LetSVSCViewController": @"如何让 UIScrollView 子控件居中"},
                       @{@"DateFormatViewController": @"收集时间日期格式化"},
                       @{@"SlidingCircularViewController": @"自定义一个圆圈评分控件"},
                       @{@"LiveRecordViewController": @"直播录屏 自定义屏幕录制 解决直播录屏黑屏"},
                       @{@"ScreenShotViewController":@"各种截屏的手段"},
                       @{@"RecordingViewController":@"ReplayKit 屏幕录制 视频放到相册"},
                       @{@"LeftSwipDeleteViewController":@"微信Cell左滑确认删除"},
                       @{@"OptionEnumeViewController":@"位移枚举"},
                       @{@"SelectionTableViewController":@"UITableViewCell选中样式和默认选中"},
                       @{@"FakeChooseViewController":@"仿造某宝商品选择"},
                       @{@"POPViewController":@"UIPOPView弹出框"},
                       @{@"NormalPopUpViewController":@"制作一个弹框"},
                       @{@"AnimationQQButtonViewController":@"动画 QQ粘性按钮"},
                       @{@"DrawingBoardViewController":@"涂鸦"},
                       @{@"Lock9PointViewController":@"9宫格解锁"},
                       @{@"ClearImageViewController":@"图片擦除 刮奖效果"},
                       @{@"ScaleScrollViewController":@"UITableView表头缩放"},
                       @{@"TextFieldViewController":@"文本框监听文字输入"},
                       @{@"TextViewViewController":@"文本带连接点击事件"},
                       @{@"UILabelViewController":@"iOS10根据系统设置改变文字大小"},
                       @{@"NSOperationViewController":@"NSOperation 示例代码"},
                       @{@"ThreadSafeViewController":@"线程安全 互斥锁"},
                       @{@"NSthreadViewController":@"NSThread 线程示例"},
                       @{@"GCDViewController":@"GCD 多线程示例"},
                       @{@"PhotoLosslessSaveViewController":@"图片无损存取"},
                       @{@"":@""},
                       @{@"":@""},
                       ];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"c"];
    
    /// 解决顶部留白  解决scrollview顶部留白 滚动式图顶部空白
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"c" forIndexPath:indexPath];
    
    NSDictionary *dic = self.dataArray[indexPath.row];
    NSString *descption = [dic allValues][0];
    cell.textLabel.text = descption;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.dataArray[indexPath.row];
    NSString *vcName = [dic allKeys][0];
    UIViewController *vc = [[NSClassFromString(vcName) alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
