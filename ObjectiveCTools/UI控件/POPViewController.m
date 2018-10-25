//
//  POPViewController.m
//  ObjectiveCTools
//
//  Created by 姬友大人 on 2018/10/18.
//  Copyright © 2018年 姬友大人. All rights reserved.
//

#import "POPViewController.h"

/// iOS POP 弹出视图
@interface POPViewController () <UIPopoverPresentationControllerDelegate>

@end

@implementation POPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)action:(UIButton *)sender {
    
    //新创建一个要显示的控制器
    UIViewController *controller = [[UIInputViewController alloc] init];
    controller.view.backgroundColor = [UIColor greenColor];
    controller.preferredContentSize = CGSizeMake(300, 300);        //popover视图的大小
    controller.modalPresentationStyle = UIModalPresentationPopover;//这句一定要
    
    // 创建一个显示文字的 Label 添加进去
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 300)]; //Label 的尺寸和位置参考 上面的 controller.preferredContentSize
    l.backgroundColor = [UIColor yellowColor];
    l.numberOfLines = 0;
    l.text = @"My name is Van, I am an artist, a performance artist, I am hired for people to fulfill their fantasies, their deep dark fantasies. I was going to be a movie star, you know, was modeling and acting. After a hundred or two auditions and small parts, you know, I decided.. that I had enough, then I ceded into escort work.";
    [controller.view addSubview:l];
    
    UIPopoverPresentationController *popController = controller.popoverPresentationController;
    popController.delegate = self;  //代理一定要
    popController.sourceView = controller.view; //设置要弹出哪个 视图 (上面自定的控制器的视图)
    popController.sourceRect = CGRectMake(sender.frame.origin.x, sender.frame.origin.y, 0, 0);  //设置弹出框箭头的位置
    [popController setPermittedArrowDirections:UIPopoverArrowDirectionUp]; //设置弹出框箭头的方向
    
    [self presentViewController:controller animated:YES completion:nil];
    
    //坐标点转换
    /*
     获取cell按钮在屏幕中的位置
     UIWindow *window = [UIApplication sharedApplication].keyWindow;
     CGRect rect1 = [sender convertRect:sender.frame fromView:self.contentView]; //获取button在contentView的位置
     CGRect rect2 = [sender convertRect:rect1 toView:window];                    //获取cell按钮在屏幕中的位置
     */
    
    /*
     获取cell在tableView中的位置
     CGRect rectInTableView = [tableView rectForRowAtIndexPath:indexPath];
     CGRect rectInSuperview = [tableView convertRect:rectInTableView toView:[tableView superview]];
     */
}

#pragma mark - 代理
-(UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}

@end


// iOS 表格 tableview 取消粘性 取消悬浮 顶部悬浮
/*
 - (void)scrollViewDidScroll:(UIScrollView *)scrollView {
 CGFloat sectionHeaderHeight = 50;
 if (self.tableViewBill.contentOffset.y<=sectionHeaderHeight&&self.tableViewBill.contentOffset.y>=0) {
 self.tableViewBill.contentInset = UIEdgeInsetsMake(-self.tableViewBill.contentOffset.y, 0, 0, 0);
 } else if (self.tableViewBill.contentOffset.y>=sectionHeaderHeight) {
 self.tableViewBill.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
 }
 }
 */

