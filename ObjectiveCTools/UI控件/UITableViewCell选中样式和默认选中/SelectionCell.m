//
//  SelectionCell.m
//  研究一下表格选中
//
//  Created by yuency on 2018/12/7.
//  Copyright © 2018年 yuency. All rights reserved.
//

#import "SelectionCell.h"

@implementation SelectionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    if (selected) {
        self.textLabel.text = @"选中";
        self.textLabel.textColor = [UIColor redColor];
        self.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        self.textLabel.text = @"somebody help!";
        self.textLabel.textColor = [UIColor blackColor];
        self.accessoryType = UITableViewCellAccessoryNone;
    }
}

+ (NSString *)forCellWithReuseIdentifier {
    return NSStringFromClass(SelectionCell.class);
}

@end
