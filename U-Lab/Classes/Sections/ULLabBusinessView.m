//
//  ULLabBusinessView.m
//  U-Lab
//
//  Created by 周维康 on 2017/6/8.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULLabBusinessView.h"
#import "ULLabBusinessViewModel.h"
#import "XYPieChartView.h"

@interface ULLabBusinessView()<PieChartDelegate>

@property (nonatomic, strong) UIView *lessView;  /**< 余额 */
@property (nonatomic, strong) UIView *monthView;  /**< 月份 */
@property (nonatomic, strong) UILabel *tipLabel;  /**< 分类支出 */
@property (nonatomic, strong) UIImageView *bottomView;  /**< 底部花篮 */
@property (nonatomic, strong) ULLabBusinessViewModel *viewModel;  /**< VM */
@property (nonatomic, strong) XYPieChartView *pieChartView;
@property (nonatomic, strong) UIButton *introlButton;
@property (nonatomic,strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UIButton *totleButton;
@property (nonatomic, strong) UIView *circleView;

@end
@implementation ULLabBusinessView
{
    NSMutableArray *_percentArray;
    NSMutableArray *_colorArray;
    NSMutableArray *_typeArray;
    BOOL isFirstIn;
    NSDate *_date;
}

- (void)ul_setupViews
{
    isFirstIn = YES;
    _date = [NSDate date];
    self.nextSubject = [RACSubject subject];
    self.backgroundColor = kBackgroundColor;
    _percentArray = [NSMutableArray array];
    _colorArray = [NSMutableArray array];
    _typeArray = [NSMutableArray array];
    [self addSubview:self.lessView];
    [self addSubview:self.monthView];
    [self addSubview:self.tipLabel];
    [self addSubview:self.bottomView];
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 45, screenWidth, 180)];
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    self.datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh"];
    self.datePicker.backgroundColor = kBackgroundColor;
    self.pickerView = [[UIView alloc] initWithFrame:CGRectMake(0, screenHeight-180-45, screenWidth, 180+45)];
    self.pickerView.backgroundColor = kBackgroundColor;
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    [window addSubview:self.pickerView];
    UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 45)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [self.pickerView addSubview:whiteView];
    //    [self.whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.right.equalTo(self);
    //        make.height.mas_equalTo(45);
    //        make.top.equalTo(window.mas_bottom).offset(-180-45);
    //    }];
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [doneButton setTitle:@"完成" forState:UIControlStateNormal];
    [doneButton setTitleColor:KButtonBlueColor forState:UIControlStateNormal];
    @weakify(self)
    [[doneButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        NSDate * date = [self.datePicker date];
        _date = date;
        NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM"];
        NSString * dateString = [formatter stringFromDate:date];
        [self.introlButton setTitle:dateString forState:UIControlStateNormal];
        self.pickerView.hidden = YES;
        [self.viewModel.getCommand execute:@{
                                                 @"labId": @([ULUserMgr sharedMgr].laboratoryId), //实验室id
                                                 @"year": @(self.datePicker.date.year), //年
                                                 @"month": @(self.datePicker.date.month) //月
                                                 }];
        
    }];
    [self.pickerView addSubview:doneButton];
    [doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(whiteView).offset(-15);
        make.centerY.equalTo(whiteView);
    }];
    [self.pickerView addSubview:self.datePicker];
    self.pickerView.hidden = YES;
    
}

- (void)ul_bindViewModel
{
    self.viewModel = [[ULLabBusinessViewModel alloc] init];
    [self.viewModel.getCommand execute:@{
                                         @"labId": @([ULUserMgr sharedMgr].laboratoryId), //实验室id
                                         @"year": @([NSDate date].year), //年
                                         @"month": @([NSDate date].month) //月
                                         }];
    [self.viewModel.nextSubject subscribeNext:^(id x) {
        if (self.pieChartView) {
            [self.pieChartView removeFromSuperview];
            self.pieChartView = nil;
            [_typeArray removeAllObjects];
            [_colorArray removeAllObjects];
            [_percentArray removeAllObjects];
            isFirstIn = YES;
        }
        if (self.circleView) {
            [self.circleView removeFromSuperview];
        }

        CGFloat width = 240/375.0*screenWidth;
        CGRect pieChartFrame = CGRectMake((screenWidth-width)/ 2, self.tipLabel.frame.origin.y+self.tipLabel.frame.size.height+20, width, width);
        NSDictionary *dic = x;
        if (dic && ![dic isKindOfClass:[NSNull class]]) {
            NSInteger total = 0;
            NSArray *values = [dic allValues];
            NSArray *keys = [dic allKeys];
            if (values.count > 0 && keys.count > 0) {
                
                _typeArray = [keys mutableCopy];
                for (NSInteger i=0; i<values.count; i++)
                {
                    if ([values[i] isKindOfClass:[NSNull class]]) {
                        continue;
                    }
                    total = total + [values[i] integerValue];
                }
                
                for (NSInteger i=0; i<values.count; i++)
                {
                    if ([values[i] isKindOfClass:[NSNull class]]) {
                        continue;
                    }
                    [_percentArray addObject:@([values[i] floatValue]/total*100)];
                };
                
                // 初始化饼图
                NSMutableArray *pieChartArray = [NSMutableArray array];
                for (NSInteger i=0; i<keys.count; i++)
                {
                    NSNumber *number = keys[i];
                    NSString *title;
                    if ([values[i] isKindOfClass:[NSNull class]]) {
                        continue;
                    }
                    if ([number integerValue] == 1)
                    {
                        title = [NSString stringWithFormat:@"耗材%@%%", @([values[i] integerValue]/total*100)];
                        [_colorArray addObject:kRedColor];
                    } else if ([number integerValue] == 2) {
                        title = [NSString stringWithFormat:@"试剂%@%%", @([values[i] integerValue]/total*100)];
                        [_colorArray addObject:kGreenColor];
                    } else if ([number integerValue] == 3) {
                        title = [NSString stringWithFormat:@"动物%@%%", @([values[i] integerValue]/total*100)];
                        [_colorArray addObject:kYellowColor];
                        
                    } else if ([number integerValue] == 4) {
                        title = [NSString stringWithFormat:@"仪器%@%%", @([values[i] integerValue]/total*100)];
                        [_colorArray addObject:kBlueColor];
                        
                    } else {
                        title = [NSString stringWithFormat:@"其他%@%%", @([values[i] integerValue]/total*100)];
                        [_colorArray addObject:kPurpleColor];
                        
                    }
                    NSString *percent = [NSString stringWithFormat:@"%@", @([values[i] integerValue]/total)];
                    NSString *amount = [NSString stringWithFormat:@"%@", values[i]];
                    [pieChartArray addObject:@{@"title":title, @"percent":percent, @"amount":amount}];
                }
                self.pieChartView = [[XYPieChartView alloc] initWithFrame:pieChartFrame withPieChartTypeArray:pieChartArray withPercentArray:_percentArray withColorArray:_colorArray];
                
                self.pieChartView.delegate = self;
                
                // 当有一项数据的百分比小于你所校验的数值时，会将该项数值百分比移出饼图展示（校验数值从0~100）
                [self.pieChartView setCheckLessThanPercent:16];
                
                // 刷新加载
                [self.pieChartView reloadChart];
                
                NSMutableAttributedString * str = [[NSMutableAttributedString alloc] initWithString:@"总支出"];
                [str addAttribute:NSFontAttributeName value:kFont(21) range:NSMakeRange(0, 3)];
                [str addAttribute:NSForegroundColorAttributeName value:kBlueColor range:NSMakeRange(0, 3)];
                // 设置圆心标题（NSMutableAttributedString类型）
                [self.pieChartView setTitleText:str];
                
                [self addSubview:self.pieChartView];
                UILabel *tintLabel = [[UILabel alloc]init];
                tintLabel.text = @"点击可查看对应部分明细";
                tintLabel.textColor = KTextGrayColor;
                [self addSubview:tintLabel];
                [tintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(self);
                    make.bottom.equalTo(self).offset(-60);
                }];
                [self addTintView];
            }else{
                UIView *circleView = [[UIView alloc]initWithFrame:pieChartFrame];
                circleView.layer.cornerRadius = width/2.0;
                circleView.layer.borderColor = kCommonGrayColor.CGColor;
                circleView.layer.borderWidth = 30;
                [self addSubview:circleView];
                self.totleButton = [[UIButton alloc]init];
                [_totleButton setTitle:@"总支出" forState:UIControlStateNormal];
                [_totleButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
                _totleButton.titleLabel.font = kFont(21);
                [_totleButton addTarget:self action:@selector(totleButtonClicked) forControlEvents:UIControlEventTouchUpInside];
                [circleView addSubview:_totleButton];
                [_totleButton mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(circleView);
                    make.centerY.equalTo(circleView);
                }];
                UILabel *tintLabel = [[UILabel alloc]init];
                tintLabel.text = @"点击可查看对应部分明细";
                tintLabel.textColor = KTextGrayColor;
                [self addSubview:tintLabel];
                [tintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(self);
                    make.bottom.equalTo(self).offset(-60);
                }];
                [self.circleView removeFromSuperview];
            }
        }else{
            UIView *circleView = [[UIView alloc]initWithFrame:pieChartFrame];
            circleView.layer.cornerRadius = width/2.0;
            circleView.layer.borderColor = kCommonGrayColor.CGColor;
            circleView.layer.borderWidth = 30;
            [self addSubview:circleView];
            self.totleButton = [[UIButton alloc]init];
            [_totleButton setTitle:@"总支出" forState:UIControlStateNormal];
            [_totleButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            _totleButton.titleLabel.font = kFont(21);
            [_totleButton addTarget:self action:@selector(totleButtonClicked) forControlEvents:UIControlEventTouchUpInside];
            [circleView addSubview:_totleButton];
            [_totleButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(circleView);
                make.centerY.equalTo(circleView);
            }];
            UILabel *tintLabel = [[UILabel alloc]init];
            tintLabel.text = @"点击可查看对应部分明细";
            tintLabel.textColor = KTextGrayColor;
            [self addSubview:tintLabel];
            [tintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self);
                make.bottom.equalTo(self).offset(-60);
            }];
            self.circleView = circleView;
        }
        
    }];
}

- (void)addTintView{
    UIView *tintView = [[UIView alloc]init];
    [self addSubview:tintView];
    [tintView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-100);
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(35*5, 10));
    }];
    NSArray *colorArray = @[kRedColor,kGreenColor,kYellowColor,kBlueColor,kPurpleColor];
    NSArray *titleArray = @[@"耗材",@"试剂",@"动物",@"仪器",@"其它"];
    for (int i = 0; i < 5; i++) {
        UIView *colorView = [[UIView alloc]init];
        colorView.backgroundColor = colorArray[i];
        [tintView addSubview:colorView];
        [colorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset((10+25)*i);
            make.size.mas_equalTo(CGSizeMake(10, 10));
            make.centerY.equalTo(tintView);
        }];
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.text = titleArray[i];
        titleLabel.font = kFont(10);
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [tintView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset((i+1)*10+i*25);
            make.centerY.equalTo(tintView);
            make.width.mas_equalTo(25);
        }];
    }
}

- (void)totleButtonClicked{
    //    [self.nextSubject sendNext:@{@"type":@0,@"date":_date}];
}

- (RACSubject *)totleSubject{
    if (!_totleSubject) {
        _totleSubject = [[RACSubject alloc]init];
    }
    return _totleSubject;
}

- (void)updateConstraints
{
    [self.lessView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self).offset(64+18);
        make.height.mas_equalTo(45);
    }];
    [self.monthView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(self.lessView);
        make.top.equalTo(self.lessView.mas_bottom);
    }];
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.monthView.mas_bottom).offset(30);
        make.centerX.equalTo(self);
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(33);
    }];
    [super updateConstraints];
}

- (UIView *)lessView
{
    if (!_lessView)
    {
        _lessView = [[UIView alloc] init];
        _lessView.backgroundColor = kCommonWhiteColor;
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.text = @"我的余额：";
        nameLabel.textColor = kTextBlackColor;
        nameLabel.font = kFont(kStandardPx(30));
        [_lessView addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_lessView).offset(15);
            make.centerY.equalTo(_lessView);
        }];
        _introLabel = [[UITextField alloc] init];
        NSNumber *labMoney = [[NSUserDefaults standardUserDefaults]objectForKey:@"labMoney"];
        _introLabel.text = [ULUserMgr sharedMgr].labMoney?[NSString stringWithFormat:@"%@",[ULUserMgr sharedMgr].labMoney]:@"0";
        _introLabel.textColor = kTextBlackColor;
        _introLabel.font = kFont(kStandardPx(30));
        _introLabel.textAlignment = NSTextAlignmentRight;
        _introLabel.enabled = NO;
        [_lessView addSubview:_introLabel];
        [_introLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_lessView).offset(-15);
            make.centerY.equalTo(_lessView);
            make.width.mas_equalTo(100);
        }];
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = kBackgroundColor;
        [_lessView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(_lessView);
            make.height.mas_equalTo(0.5);
        }];
    }
    return _lessView;
}

- (UIView *)monthView
{
    if (!_monthView)
    {
        _monthView = [[UIView alloc] init];
        _monthView.backgroundColor = kCommonWhiteColor;
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.text = @"查询日期：";
        nameLabel.textColor = kTextBlackColor;
        nameLabel.font = kFont(kStandardPx(30));
        [_monthView addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_monthView).offset(15);
            make.centerY.equalTo(_monthView);
        }];
        UIButton *introlButton = [[UIButton alloc] init];
        [introlButton setTitle:[[NSDate nowTime] substringToIndex:7] forState:UIControlStateNormal];
        [introlButton setTitleColor:kTextBlackColor forState:UIControlStateNormal];
        introlButton.titleLabel.font = kFont(kStandardPx(30));
        [introlButton addTarget:self action:@selector(choiceTime) forControlEvents:UIControlEventTouchUpInside];
        [_monthView addSubview:introlButton];
        [introlButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_monthView).offset(-15);
            make.centerY.equalTo(_monthView);
        }];
        self.introlButton = introlButton;
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = kBackgroundColor;
        [_monthView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(_monthView);
            make.height.mas_equalTo(0.5);
        }];
    }
    return _monthView;
}

- (void)choiceTime{
    //    [self.whiteView mas_updateConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(self.mas_bottom).offset(-180-45);
    //    }];
    [self endEditing:YES];
    self.pickerView.hidden = NO;
}

- (UILabel *)tipLabel
{
    if (!_tipLabel)
    {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.text = @"分类支出";
        _tipLabel.font = kFont(kStandardPx(34));
        _tipLabel.textColor = KTextGrayColor;
    }
    return _tipLabel;
}



- (UIImageView *)bottomView
{
    if (!_bottomView)
    {
        _bottomView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"register_bottom"]];
    }
    return _bottomView;
}

#pragma mark - <选中扇形回调>
- (void)selectedFinish:(XYPieChartView *)pieChartView index:(NSInteger)index selectedType:(NSDictionary *)selectedType {
    if (isFirstIn) {
        isFirstIn = NO;
        return;
    }
    NSNumber *type;
    UIColor *color = _colorArray[index];
    if (CGColorEqualToColor(kRedColor.CGColor, color.CGColor)) {
        type = @1;
    }else if (CGColorEqualToColor(kGreenColor.CGColor, color.CGColor)){
        type = @2;
    }else if (CGColorEqualToColor(kYellowColor.CGColor, color.CGColor)){
        type = @3;
    }else if(CGColorEqualToColor(kBlueColor.CGColor, color.CGColor)){
        type = @4;
    }else{
        type = @5;
    }
    [self.nextSubject sendNext:@{@"type":type,@"date":_date}];
}

#pragma mark - <点击扇形同心圆回调>
- (void)onCenterClick:(XYPieChartView *)PieChartView {
    
}

@end
