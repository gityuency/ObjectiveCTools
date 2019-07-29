//
//  YXGoalReviewView.m
//  ObjectiveCTools
//
//  Created by EF on 2019/7/29.
//  Copyright © 2019 ChinaRapidFinance. All rights reserved.
//

#import "YXGoalReviewView.h"

static const CGFloat circuleWidthAndHeight = 40.0;

static const CGFloat fixedInfoViewHeight = 35.0;

static const CGFloat gapBetweenCircleAndText = 8.0;

static const CGFloat innerMargin = 16.0;

static UIColor *grayColor = nil;

static UIColor *itemHeightLightColor = nil;

@interface YXGoalReviewView()

@property (nonatomic, strong) NSMutableArray <NSString *>* subLayersRects;
@property (nonatomic, strong) NSMutableArray <CircularLayer *>* layersArray;
@property (nonatomic, strong) NSMutableArray <InfoView *>* infoViewsArray;

@end


@implementation YXGoalReviewView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setUpView];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setValue:(NSInteger)value {
    _value = value;
    [self refreLabel:value];
    [self refreshView:value - 1];
}

- (void)setStringsArray:(NSArray<NSString *> *)stringsArray {
    _stringsArray = stringsArray;
    
    [self setTotalCount:_stringsArray.count];
}

- (void)setTotalCount:(NSInteger)totalCount {
    _totalCount = totalCount;
        
    [_layersArray enumerateObjectsUsingBlock:^(CircularLayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperlayer];
    }];
    
    [_layersArray removeAllObjects];
    
    [_infoViewsArray enumerateObjectsUsingBlock:^(InfoView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    [_infoViewsArray removeAllObjects];
    
    for (int i = 0; i < totalCount; i ++) {
        CircularLayer *l = [[CircularLayer alloc] init];
        [self.layer addSublayer:l];
        [_layersArray addObject:l];
        InfoView *v = [[InfoView alloc] init];
        if (i < _stringsArray.count) {
            [v setInfo:[NSString stringWithFormat:@"%d", i + 1] desc:_stringsArray[i]];
        }
        [self addSubview:v];
        [_infoViewsArray addObject:v];
    }
    [self invalidateIntrinsicContentSize];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat orixX = (self.frame.size.width - (_totalCount * circuleWidthAndHeight + (_totalCount - 1) * innerMargin)) / 2;
    [_subLayersRects removeAllObjects];
    
    for (int index = 0; index < _layersArray.count; index ++) {
        CircularLayer *l = _layersArray[index];
        l.frame = CGRectMake(orixX + index * (circuleWidthAndHeight + innerMargin), 0, circuleWidthAndHeight, circuleWidthAndHeight);
        [_subLayersRects addObject:NSStringFromCGRect(l.frame)];
        InfoView *v = _infoViewsArray[index];
        v.center = CGPointMake(CGRectGetMidX(l.frame), circuleWidthAndHeight + v.frame.size.height / 2.0 + gapBetweenCircleAndText);
    }
}

- (void)refreLabel:(NSInteger)value {
    
    if (_totalCount != 5) {
        for (InfoView *view in _infoViewsArray) {
            view.hidden = NO;
            [view setInfoViewColor:NO];
        }
        return;
    }
    
    if (value == 0) {
        
        for (int index = 0; index < _infoViewsArray.count; index++) {
            
            InfoView *view = _infoViewsArray[index];
            
            if (index == 0 || index == _totalCount - 1) {
                view.hidden = NO;
                [view setInfoViewColor:YES];
            } else {
                view.hidden = YES;
                [view setInfoViewColor:NO];
            }
        }
    }
    
    if (value > 0 && value <= _totalCount) {
        for (int index = 0; index < _infoViewsArray.count; index++) {
            InfoView *view = _infoViewsArray[index];
            [view setInfoViewColor:NO];
            view.hidden = (index == value - 1 ? NO : YES);
        }
    }
}

- (void)refreshView:(NSInteger)value {
    for (int index = 0; index < _layersArray.count; index++) {
        CircularLayer *l= _layersArray[index];
        if (index <= value) {
            l.highLightLayer.backgroundColor = itemHeightLightColor.CGColor;
        } else {
            l.highLightLayer.backgroundColor = [UIColor whiteColor].CGColor;
        }
    }
}

- (void)setUpView {
    self.userInteractionEnabled = YES;
    grayColor = [UIColor colorWithRed:225/255.0 green:228/255.0 blue:235/255.0 alpha:1];
    itemHeightLightColor = [UIColor colorWithRed:59/255.0 green:199/255.0 blue:54/255.0 alpha:1];
    _subLayersRects = [NSMutableArray array];
    _layersArray = [NSMutableArray array];
    _infoViewsArray = [NSMutableArray array];
    _value = 0;
    _totalCount = 5;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self touchesMoved:touches withEvent:event];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint location = [touches.allObjects.firstObject locationInView:self];
    for (int selectedIndex = 0; selectedIndex < _subLayersRects.count; selectedIndex ++) {
        CGRect rect = CGRectFromString(_subLayersRects[selectedIndex]);
        if (CGRectContainsPoint(rect, location)) {
            [self refreLabel:selectedIndex];
            self.value = selectedIndex + 1;
            [self sendActionsForControlEvents:UIControlEventValueChanged];
            [self refreshView:selectedIndex];
            return;
        }
    }
}

@end

@interface InfoView()

@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) UILabel *descLabel;

@end

@implementation InfoView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setUpView];
}

- (void)setUpView {
    
    _numberLabel = [[UILabel alloc] init];
    _numberLabel.font = [UIFont boldSystemFontOfSize:16];
    [self addSubview:_numberLabel];
    
    _descLabel = [[UILabel alloc] init];
    _descLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:_descLabel];
}

- (void)setInfo:(NSString *)index desc:(NSString *)description{
    self.numberLabel.text = index;
    self.descLabel.text = description;
    [self.numberLabel sizeToFit];
    [self.descLabel sizeToFit];
    [self invalidateIntrinsicContentSize];
}

- (void)setInfoViewColor:(BOOL)defaultColor {
    if (defaultColor) {
        self.numberLabel.textColor = grayColor;
        self.descLabel.textColor = grayColor;
    } else {
        self.numberLabel.textColor = [UIColor blackColor];
        self.descLabel.textColor = [UIColor blackColor];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.numberLabel.frame = CGRectMake((self.frame.size.width - self.numberLabel.frame.size.width) / 2.0, 0, self.numberLabel.frame.size.width, self.numberLabel.frame.size.height);
    self.descLabel.frame = CGRectMake((self.frame.size.width - self.descLabel.frame.size.width) / 2.0, CGRectGetMaxY(self.numberLabel.frame), self.descLabel.frame.size.width, self.descLabel.frame.size.height);
}

- (CGSize)systemLayoutSizeFittingSize:(CGSize)targetSize withHorizontalFittingPriority:(UILayoutPriority)horizontalFittingPriority verticalFittingPriority:(UILayoutPriority)verticalFittingPriority {
    return [self intrinsicContentSize];
}

- (CGSize)intrinsicContentSize {
    CGFloat w = MAX(self.numberLabel.frame.size.width, self.descLabel.frame.size.width);
    return CGSizeMake(w, fixedInfoViewHeight);
}

@end


@interface CircularLayer()

@end

@implementation CircularLayer

- (instancetype)initWithLayer:(id)layer {
    self = [super initWithLayer:layer];
    if (self) {
        [self setUp];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setUp];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp {
    self.frame = CGRectMake(0, 0, circuleWidthAndHeight, circuleWidthAndHeight);
    self.backgroundColor = UIColor.whiteColor.CGColor;
    CGFloat subwh = circuleWidthAndHeight * 0.6;
    
    self.borderColor = grayColor.CGColor;
    self.borderWidth = self.bounds.size.width * 0.1;
    self.cornerRadius = circuleWidthAndHeight / 2.0;
    
    CGFloat centerXY = (self.bounds.size.width - subwh) / 2.0;
    _highLightLayer = [[CALayer alloc] init];
    _highLightLayer.frame = CGRectMake(centerXY, centerXY, subwh, subwh);
    _highLightLayer.cornerRadius = subwh * 0.5;
    [self addSublayer:_highLightLayer];
}

@end


static const CGFloat circuleWidthAndHeightHalf = 20.0;

static const CGFloat innerMarginHalf = 8.0;

@interface LZGoalReviewDoneView()

@property (nonatomic, strong) NSMutableArray <CALayer *>* layersArray;

@end

@implementation LZGoalReviewDoneView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setUpView];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setValue:(NSInteger)value {
    _value = value;
    [self refreshView:value - 1];
}

- (void)setTotalCount:(NSInteger)totalCount {
    _totalCount = totalCount;
    
    [_layersArray enumerateObjectsUsingBlock:^(CALayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperlayer];
    }];
    
    [_layersArray removeAllObjects];
    
    for (int i = 0; i < totalCount; i ++) {
        CALayer *l = [[CALayer alloc] init];
        [self.layer addSublayer:l];
        [_layersArray addObject:l];
    }
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat orixX = (self.frame.size.width - (_totalCount * circuleWidthAndHeightHalf + (_totalCount - 1) * innerMarginHalf)) / 2;
    for (int index = 0; index < _layersArray.count; index ++) {
        CALayer *l = _layersArray[index];
        l.cornerRadius = circuleWidthAndHeightHalf / 2.0;
        l.frame = CGRectMake(orixX + index * (circuleWidthAndHeightHalf + innerMarginHalf), 0, circuleWidthAndHeightHalf, circuleWidthAndHeightHalf);
    }
}

- (void)refreshView:(NSInteger)value {
    for (int index = 0; index < _layersArray.count; index++) {
        CALayer *l= _layersArray[index];
        if (index <= value) {
            l.backgroundColor = itemHeightLightColor.CGColor;
        } else {
            l.backgroundColor = grayColor.CGColor;
        }
    }
}

- (void)setUpView {
    grayColor = [UIColor colorWithRed:225/255.0 green:228/255.0 blue:235/255.0 alpha:1];
    itemHeightLightColor = [UIColor colorWithRed:59/255.0 green:199/255.0 blue:54/255.0 alpha:1];
    _layersArray = [NSMutableArray array];
    _value = 0;
    _totalCount = 5;
}

- (CGSize)systemLayoutSizeFittingSize:(CGSize)targetSize withHorizontalFittingPriority:(UILayoutPriority)horizontalFittingPriority verticalFittingPriority:(UILayoutPriority)verticalFittingPriority {
    return [self intrinsicContentSize];
}

- (CGSize)intrinsicContentSize {
    CGFloat w = _totalCount * circuleWidthAndHeightHalf + (_totalCount - 1) * innerMarginHalf;
    return CGSizeMake(w, circuleWidthAndHeightHalf);
}

@end

