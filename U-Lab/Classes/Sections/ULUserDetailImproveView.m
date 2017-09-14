//
//  ULUserDetailImproveView.m
//  U-Lab
//
//  Created by 周维康 on 2017/6/6.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULUserDetailImproveView.h"
#import "ZWKAlertView.h"
@interface ULUserDetailImproveView()<UITextFieldDelegate, ZWKAlertViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UITextField *nameText;  /**< 姓名 */
@property (nonatomic, strong) UIButton *sexButton;  /**< 性别 */
@property (nonatomic, strong) UIButton *identifyButton; /**< 身份 */
@property (nonatomic, strong) UITextField *labText;  /**< 实验室名称 */
@property (nonatomic, strong) UIButton *areaButton;  /**< 区域 */
@property (nonatomic, strong) UITextField *detailText;  /**< 详细地址 */
@property (nonatomic, strong) UIImageView *bottomView;  /**< 底部花篮 */
@property (nonatomic, strong) ZWKAlertView *sexAlertView;  /**<  */
@property (nonatomic, strong) ZWKAlertView *roleAlertView;  /**< role */
@property (nonatomic, strong) UIPickerView *pickerView;  /**< <#comment#> */
@property (nonatomic, strong) UIView *whiteView;  /**< <#comment#> */
@property (nonatomic, strong) UILabel *areaLabel;  /**< <#comment#> */
@end

@implementation ULUserDetailImproveView
{
    NSMutableArray *_cityArray;
}

- (void)ul_setupViews
{
    _cityArray = [self getCityData];
    self.sexAlertView = [[ZWKAlertView alloc] initWithFuncArray:@[@"女", @"男"]];
    self.sexAlertView.delegate = self;
    self.roleAlertView = [[ZWKAlertView alloc] initWithFuncArray:@[@"普通用户", @"PI"]];
    self.roleAlertView.delegate = self;
    self.sex = @1;
    self.role = @0;
    self.userName = [ULUserMgr sharedMgr].userName? [ULUserMgr sharedMgr].userName: @"" ;
    self.location = [ULUserMgr sharedMgr].labLocation?[ULUserMgr sharedMgr].labLocation:@"";
    self.labName = [ULUserMgr sharedMgr].laboratoryName?[ULUserMgr sharedMgr].laboratoryName:@"";
    self.backgroundColor = kBackgroundColor;
    [self addSubview:self.nameText];
    [self addSubview:self.sexButton];
    [self addSubview:self.identifyButton];
    [self addSubview:self.labText];
    [self addSubview:self.areaButton];
    [self addSubview:self.detailText];
    [self addSubview:self.detailText];
    [self addSubview:self.bottomView];
    [self updateConstraintsIfNeeded];
    [self setNeedsUpdateConstraints];
    self.pickerView = [[UIPickerView alloc] init];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    self.pickerView.backgroundColor = kBackgroundColor;
    self.whiteView = [[UIView alloc] init];
    self.whiteView.backgroundColor = kBackgroundColor;
    [self addSubview:self.whiteView];
    [self.whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.mas_equalTo(45);
        make.top.equalTo(self.mas_bottom);
    }];
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [doneButton setTitle:@"完成" forState:UIControlStateNormal];
    [doneButton setTitleColor:KButtonBlueColor forState:UIControlStateNormal];
    @weakify(self)
    [[doneButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        [self.whiteView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_bottom);
        }];
    }];
    [self.whiteView addSubview:doneButton];
    [doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.whiteView).offset(-15);
        make.centerY.equalTo(self.whiteView);
    }];
    [self addSubview:self.pickerView];
    [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.whiteView.mas_bottom);
        make.height.mas_equalTo(180);
    }];

}

- (void)updateConstraints
{
    [self.nameText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(self);
        make.top.equalTo(self).offset(84);
        make.height.mas_equalTo(45);
    }];
    [self.sexButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.left.right.equalTo(self.nameText);
        make.top.equalTo(self.nameText.mas_bottom);
    }];
    [self.identifyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.sexButton.mas_bottom);
        make.height.mas_equalTo(45);
    }];
    [self.labText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.left.right.equalTo(self.nameText);
        make.top.equalTo(self.identifyButton.mas_bottom).offset(8);
    }];
    [self.areaButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(self.nameText);
        make.top.equalTo(self.labText.mas_bottom);
    }];
    [self.detailText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(self.nameText);
        make.top.equalTo(self.areaButton.mas_bottom);
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(33);
    }];
    [super updateConstraints];
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0)
    {
        return _cityArray.count;
    } else if (component == 1) {
        NSDictionary *dic = _cityArray[[pickerView selectedRowInComponent:0]];
        NSArray *array = dic[@"city"];
        return array.count;
    } else {
        NSDictionary *dic = _cityArray[[pickerView selectedRowInComponent:0]];
        NSArray *array = dic[@"city"];
        NSDictionary *areaDic = array[[pickerView selectedRowInComponent:1]];
        NSArray *areaArray = areaDic[@"area"];
        return areaArray.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0)
    {
        NSDictionary *dic = _cityArray[row];
        return dic[@"name"];
    } else if (component == 1) {
        NSDictionary *dic = _cityArray[[pickerView selectedRowInComponent:0]];
        NSArray *array = dic[@"city"];
        NSDictionary *areaDic = array[row];
        return areaDic[@"name"];
    } else {
        NSDictionary *dic = _cityArray[[pickerView selectedRowInComponent:0]];
        NSArray *array = dic[@"city"];
        NSDictionary *areaDic = array[[pickerView selectedRowInComponent:1]];
        NSArray *areaArray = areaDic[@"area"];
        return areaArray[row];
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component==0)
    {
        [pickerView reloadComponent:1];
        [pickerView reloadComponent:2];
    } else if (component == 1) {
        [pickerView reloadComponent:2];
    }
    NSDictionary *dic = _cityArray[[pickerView selectedRowInComponent:0]];
    NSArray *array = dic[@"city"];
    NSDictionary *areaDic = array[[pickerView selectedRowInComponent:1]];
    NSArray *areaArray = areaDic[@"area"];
    self.areaLabel.text = [NSString stringWithFormat:@"%@%@%@", dic[@"name"], areaDic[@"name"], areaArray[[pickerView selectedRowInComponent:2]]];
    self.location = [NSString stringWithFormat:@"%@%@",self.areaLabel.text ,_detailText.text];
}

- (NSMutableArray *)getCityData
{
    NSArray *jsonArray = [[NSArray alloc]init];
    NSData *fileData = [[NSData alloc]init];
    NSUserDefaults *UD = [NSUserDefaults standardUserDefaults];
    if ([UD objectForKey:@"city"] == nil) {
        NSString *path;
        path = [[NSBundle mainBundle] pathForResource:@"province" ofType:@"json"];
        fileData = [NSData dataWithContentsOfFile:path];
        
        [UD setObject:fileData forKey:@"city"];
        [UD synchronize];
    }
    else {
        fileData = [UD objectForKey:@"city"];
    }
    NSMutableArray *array = [[NSMutableArray alloc]initWithCapacity:0];
    jsonArray = [NSJSONSerialization JSONObjectWithData:fileData options:NSJSONReadingMutableLeaves error:nil];
    for (NSDictionary *dict in jsonArray) {
        [array addObject:dict];
    }
    return array;
}

- (void)alertView:(ZWKAlertView *)alertView didClickAtIndex:(NSInteger)index
{
    if (alertView == self.sexAlertView)
    {
        self.sex = @(index);
        for (UIView *subview in self.sexButton.subviews)
        {
            if ([subview class] == [UILabel class])
            {
                UILabel *label = (UILabel *)subview;
                if (![label.text  isEqual: @"性别："])
                {
                    label.text = index==0? @"女":@"男";
                }
            }
        }
    } else {
        for (UIView *subview in self.identifyButton.subviews)
        {
            if ([subview class] == [UILabel class])
            {
                UILabel *label = (UILabel *)subview;
                if (![label.text  isEqual: @"身份："])
                {
                    if (index == 0)
                    {
                        label.text = @"普通用户";
                        self.role = @0;
                        _detailText.hidden = YES;
                        _labText.hidden = YES;
                        _areaButton.hidden = YES;
                    } else {
                        label.text = @"PI";
                        self.role = @2;
                        _detailText.hidden = NO;
                        _labText.hidden = NO;
                        _areaButton.hidden = NO;
                    }
                }
            }
        }
    }
    [alertView hide];
}
- (void)ul_bindViewModel
{
    
}

- (UITextField *)nameText
{
    if (!_nameText)
    {
        _nameText = [[UITextField alloc] init];
        [self setText:_nameText name:@"姓名：" detail:[ULUserMgr sharedMgr].userName];
        _nameText.delegate = self;
        @weakify(self)
        [[_nameText rac_textSignal] subscribeNext:^(id x) {
            @strongify(self)
            self.userName = x;
        }];
    }
    return _nameText;
}

- (UIButton *)sexButton
{
    if (!_sexButton)
    {
        _sexButton = [UIButton buttonWithType:UIButtonTypeCustom];
        NSString *sex = [self.sex isEqual:@0]? @"女" : @"男";
        [self setButton:_sexButton name:@"性别：" detail:sex];
        [[_sexButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            [self.nameText resignFirstResponder];
            [self.labText resignFirstResponder];
            [self.areaButton resignFirstResponder];
            [self.detailText resignFirstResponder];
            [self.sexAlertView show];
            [self.whiteView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.mas_bottom);
            }];
        }];
    }
    return _sexButton;
}

- (UIButton *)identifyButton
{
    if (!_identifyButton)
    {
        _identifyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        NSString *role;
        if ([self.role  isEqual: @0])
        {
            role = @"普通用户";
        } else if ([self.role  isEqual: @1]){
            role = @"管家";
        } else {
            role = @"PI";
        }
        [self setButton:_identifyButton name:@"身份：" detail:role];
        @weakify(self)
        [[_identifyButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self)
            [self.nameText resignFirstResponder];
            [self.labText resignFirstResponder];
            [self.areaButton resignFirstResponder];
            [self.detailText resignFirstResponder];
            [self.roleAlertView show];
            [self.whiteView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.mas_bottom);
            }];
        }];
    }
    return _identifyButton;
}

- (UITextField *)labText
{
    if (!_labText)
    {
        _labText = [[UITextField alloc] init];
        [self setText:_labText name:@"实验室名称：" detail:[ULUserMgr sharedMgr].laboratoryName];
        @weakify(self)
        [[_labText rac_textSignal] subscribeNext:^(id x) {
            @strongify(self)
            [self.whiteView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.mas_bottom);
            }];
            self.labName = x;
        }];
        _labText.hidden = YES;
    }
    return _labText;
}

- (UIButton *)areaButton
{
    if (!_areaButton)
    {
        _areaButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self setButton:_areaButton name:@"所在区域：" detail:nil];
//        [[_areaButton rac_textSignal] subscribeNext:^(id x) {
//            self.location = [NSString stringWithFormat:@"%@%@",_areaText.text,_detailText.text];
//        }];
        [[_areaButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            [self.whiteView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.mas_bottom).offset(-180-45);
            }];
            [self endEditing:YES];
        }];
        _areaButton.hidden = YES;
    }
    return _areaButton;
}

- (UITextField *)detailText
{
    if (!_detailText)
    {
        _detailText = [[UITextField alloc] init];
        [self setText:_detailText name:@"详细地址：" detail:[ULUserMgr sharedMgr].labLocation];
        [[_detailText rac_textSignal] subscribeNext:^(id x) {
            [self.whiteView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.mas_bottom);
            }];
            self.location = [NSString stringWithFormat:@"%@%@",self.areaLabel.text ,_detailText.text];
        }];
        _detailText.hidden = YES;
    }
    return _detailText;
}

- (UIImageView *)bottomView
{
    if (!_bottomView)
    {
        _bottomView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"register_bottom"]];
    }
    return _bottomView;
}
- (void)setText:(UITextField *)view name:(NSString *)nameString detail:(NSString *)detail
{
    view.backgroundColor = kCommonWhiteColor;
    UIView *whiteView = [[UIView alloc] init];
    whiteView.frame = CGRectMake(0, 0, 115, 45);
    whiteView.backgroundColor = kCommonWhiteColor;
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = nameString;
    nameLabel.textColor = KTextGrayColor;
    nameLabel.font = kFont(kStandardPx(28));
    nameLabel.frame = CGRectMake(15, 0, 100, 45);
    [whiteView addSubview:nameLabel];
    view.leftView = whiteView;
    view.leftViewMode = UITextFieldViewModeAlways;
//    UILabel *detailLabel = [[UILabel alloc] init];
    view.delegate = self;
    view.text = detail;
//    detailLabel.text = detail;
//    detailLabel.font = kFont(kStandardPx(28));
//    detailLabel.textColor = kTextBlackColor;
//    detailLabel.textAlignment = NSTextAlignmentCenter;
//    [view addSubview:detailLabel];
//    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(view).offset(100);
//        make.right.equalTo(view).offset(-25);
//    }];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = kBackgroundColor;
    [view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(view);
        make.height.mas_equalTo(0.5);
    }];
}

- (void)setButton:(UIButton *)view name:(NSString *)nameString detail:(NSString *)detail
{
    view.backgroundColor = kCommonWhiteColor;
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = nameString;
    nameLabel.textColor = KTextGrayColor;
    nameLabel.font = kFont(kStandardPx(28));
    [view addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).offset(15);
        make.centerY.equalTo(view);
    }];
    
    if (view == self.areaButton)
    {
        self.areaLabel = [[UILabel alloc] init];
     
        self.areaLabel.font = kFont(kStandardPx(28));
        self.areaLabel.textColor = kTextBlackColor;
        [view addSubview:self.areaLabel];
        [self.areaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view).offset(115);
            make.right.equalTo(view).offset(-45);
            make.centerY.equalTo(view);
        }];
    } else {
    UILabel *detailLabel = [[UILabel alloc] init];
    detailLabel.text = detail;
    detailLabel.font = kFont(kStandardPx(28));
    detailLabel.textColor = kTextBlackColor;
    [view addSubview:detailLabel];
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).offset(115);
        make.right.equalTo(view).offset(-45);
        make.centerY.equalTo(view);
    }];
    }
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = kBackgroundColor;
    [view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(view);
        make.height.mas_equalTo(0.5);
    }];
   
        UIImageView *next = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_user_next"]];
        [view addSubview:next];
        [next mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(view).offset(-15);
            make.centerY.equalTo(view);
            make.size.mas_equalTo(CGSizeMake(10, 15));
        }];
    

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.nameText resignFirstResponder];
    [self.labText resignFirstResponder];
    [self.detailText resignFirstResponder];
    [self.whiteView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_bottom);
    }];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.nameText resignFirstResponder];
    [self.labText resignFirstResponder];

    [self.detailText resignFirstResponder];
    return YES;
}
@end
