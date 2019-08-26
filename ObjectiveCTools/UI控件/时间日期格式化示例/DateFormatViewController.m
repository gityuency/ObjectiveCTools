//
//  DateFormatViewController.m
//  ObjectiveCTools
//
//  Created by EF on 2019/8/26.
//  Copyright © 2019 姬友大人. All rights reserved.
//

#import "DateFormatViewController.h"
#import "YXDateFormat.h"

@interface DateFormatViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,copy)NSString *timeString;
@property(nonatomic,strong)NSArray *dataArray;
@property(nonatomic,strong)UITableView *tableView;

@end

@implementation DateFormatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"固定的时间字符串格式化";
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,  self.view.frame.size.height)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    
    self.timeString = @"2017-04-16 13:08:06";
    
    //星期
    NSString *time0 = self.timeString.dd_formatWeekDay;
    
    //2017年04月16日
    NSString *time1 = self.timeString.dd_formatNianYueRi;
    
    //2017年04月
    NSString *time2 = self.timeString.dd_formatNianYue;
    
    //04月16日
    NSString *time3 = self.timeString.dd_formatYueRi;
    
    //2017年
    NSString *time4 = self.timeString.dd_formatNian;
    
    //13时08分01秒
    NSString *time5 = self.timeString.dd_formatShiFenMiao;
    
    //13时08分
    NSString *time6 = self.timeString.dd_formatShiFen;
    
    //08分01秒
    NSString *time7 = self.timeString.dd_formatFenMiao;
    
    //2017-04-16
    NSString *time8 = self.timeString.dd_format_yyyy_MM_dd;
    
    //2017-04
    NSString *time9 = self.timeString.dd_format_yyyy_MM;
    
    //04-16
    NSString *time10 = self.timeString.dd_format_MM_dd;
    
    //2017
    NSString *time11 = self.timeString.dd_format_yyyy;
    
    //13:08:06
    NSString *time12 = self.timeString.dd_format_HH_mm_ss;
    
    //13:08
    NSString *time13 = self.timeString.dd_format_HH_mm;
    
    //08:06
    NSString *time14 = self.timeString.dd_format_mm_ss;
    
    self.dataArray = @[time0,time1,time2,time3,time4,time5,time6,time7,time8,time9,time10,time11,time12,time13,time14];
    
}

#pragma mark - tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    view.backgroundColor = [UIColor blueColor];
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, view.frame.size.width-32, view.frame.size.height)];
    lab.text = [NSString stringWithFormat:@"%@ 转换为下面格式↓",self.timeString];
    lab.textColor = [UIColor whiteColor];
    [view addSubview:lab];
    return view;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = self.dataArray[indexPath.row];
    return cell;
    
}

@end
