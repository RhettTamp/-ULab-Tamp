//
//  ULMainApplyBuyViewController.m
//  ULab
//
//  Created by 周维康 on 2017/6/14.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULMainApplyBuyViewController.h"
#import "ULLabObjectViewModel.h"
#import "YYTextView.h"

@interface ULMainApplyBuyViewController () <UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource>
@property (nonatomic, strong) UITableView *tableView;  /**< 详情列表 */
@property (nonatomic, strong) UIButton *useButton;  /**< 使用按钮 */
@property (nonatomic, strong) UIImageView *bottomView;  /**< 底部花篮 */
@property (nonatomic, strong) UIScrollView *scrollView;  /**< 滑动背景板 */
@property (nonatomic, strong) UILabel *label;  /**< beizhu */
@property (nonatomic, strong) YYTextView *textView;  /**< beizhu */
@property (nonatomic, strong) ULLabObjectViewModel *viewModel;  /**< viewModel */
@property (nonatomic, strong) UIPickerView *pickerView;  /**< <#comment#> */
@property (nonatomic, strong) UIView *whiteView;  /**< <#comment#> */
@property (nonatomic, strong) UILabel *pinxiLabel;  /**< <#comment#> */

@end

@implementation ULMainApplyBuyViewController
{
    //    NSArray *_detailArray;
    NSArray *_titleArray;
    NSMutableArray *_detailArray;
    NSArray *_picekrArray;
}

- (void)ul_layoutNavigation
{
    self.title = @"申请购买";
}
- (void)ul_addSubviews
{
    _titleArray = @[@"类别", @"名称", @"数量", @"单位", @"规格型号", @"经销商", @"厂商", @"售后电话",];
    _detailArray = [NSMutableArray arrayWithObjects:@"", @"", @"", @"", @"", @"", @"", @"", nil];
    _picekrArray = @[@"耗材", @"试剂", @"动物", @"仪器", @"其他"];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.tableView];
    [self.scrollView addSubview:self.useButton];
    [self.scrollView addSubview:self.label];
    [self.scrollView addSubview:self.textView];
    [self.view addSubview:self.pickerView];
    [self.view addSubview:self.bottomView];
    [self.view updateConstraintsIfNeeded];
    [self.view setNeedsUpdateConstraints];
    self.pickerView = [[UIPickerView alloc] init];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    self.pickerView.backgroundColor = kBackgroundColor;
    self.whiteView = [[UIView alloc] init];
    self.whiteView.backgroundColor = kBackgroundColor;
    [self.view addSubview:self.whiteView];
    [self.whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(45);
        make.top.equalTo(self.view.mas_bottom);
    }];
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [doneButton setTitle:@"完成" forState:UIControlStateNormal];
    [doneButton setTitleColor:KButtonBlueColor forState:UIControlStateNormal];
    @weakify(self)
    [[doneButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        [self.whiteView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_bottom);
        }];
    }];
    [self.whiteView addSubview:doneButton];
    [doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.whiteView).offset(-15);
        make.centerY.equalTo(self.whiteView);
    }];
    [self.view addSubview:self.pickerView];
    [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.whiteView.mas_bottom);
        make.height.mas_equalTo(180);
    }];
    [self.pickerView selectRow:0 inComponent:0 animated:NO];
}

- (void)ul_bindViewModel
{
    [self.viewModel.buyCommand.executionSignals.flatten subscribeNext:^(id x) {
        [ULProgressHUD showWithMsg:@"申购成功"];
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)updateViewConstraints
{
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(64+18);
        make.height.mas_equalTo(screenHeight-64-33-18);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.scrollView);
        make.height.mas_equalTo(_titleArray.count*45);
    }];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.top.equalTo(self.tableView.mas_bottom).offset(10);
    }];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(120);
        make.top.equalTo(self.label.mas_bottom).offset(8);
    }];
    [self.useButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textView.mas_bottom).offset(54);
        make.centerX.equalTo(self.view);
        make.left.equalTo(self.view).offset(15);
        make.height.mas_equalTo(45);
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(33);
    }];
    [super updateViewConstraints];

}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 5;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _picekrArray[row];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (row == 0 || row == 1 || row == 4)
    {
        _titleArray = @[@"类别", @"名称", @"数量", @"单位", @"规格参数", @"经销商", @"厂商", @"售后电话",];
     
    } else if (row == 2) {
        _titleArray = @[@"类别", @"名称", @"雌性数量", @"雄性数量", @"出生日期", @"品系", @"经销商", @"厂商", @"售后电话",];
     
    } else {
        _titleArray = @[@"类别", @"名称", @"数量", @"单位", @"型号", @"经销商", @"厂商", @"售后电话",];
    
    }
    for (NSInteger i=0; i<_titleArray.count; i++)
    {
        _detailArray[i]=@"";
    }
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        [self.whiteView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_bottom).offset(-180-45);
        }];
    }
}

- (UIScrollView *)scrollView
{
    if (!_scrollView)
    {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.contentSize = CGSizeMake(screenWidth, _titleArray.count*45+88+164+140);
        _scrollView.backgroundColor = kBackgroundColor;
        _scrollView.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0);
    }
    return _scrollView;
}

- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] init];
        _tableView.rowHeight = 45;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ULMainApplyBuyTableViewCellIdentifier"];
    }
    return _tableView;
}

- (UIImageView *)bottomView
{
    if (!_bottomView)
    {
        _bottomView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"register_bottom"]];
    }
    return _bottomView;
}

- (UIButton *)useButton
{
    if (!_useButton)
    {
        _useButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _useButton.backgroundColor = KButtonBlueColor;
        [_useButton setTitle:@"申请购买" forState:UIControlStateNormal];
        [_useButton setTitleColor:kCommonWhiteColor forState:UIControlStateNormal];
        @weakify(self)
        [[_useButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self)
            __block BOOL isStop= NO;
            [_detailArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (idx!=0&&[obj isEqual:@""])
                {
                    [ULProgressHUD showWithMsg:[NSString stringWithFormat:@"请填写%@", _titleArray[idx]]];
                    isStop = YES;
                    *stop = YES;
                }
            }];
            if (!isStop)
            [ULProgressHUD showWithMsg:@"申请购买中" inView:self.view withBlock:^{
                @strongify(self)
                if ([self.pickerView selectedRowInComponent:0]==2)
                {
                    [self.viewModel.buyCommand execute:@{
                                                         @"itemType": @([self.pickerView selectedRowInComponent:0]+1),
                                                         @"labId" : @([ULUserMgr sharedMgr].laboratoryId),
                                                         @"itemName": _detailArray[1], //物品名字
                                                         @"quantity": [NSString stringWithFormat:@"%@/%@", _detailArray[2], _detailArray[3]], //数量
                                                         @"unitMeasurement":@"只", //单位
                                                         @"specification":_detailArray[5], //规格型号
                                                         @"factory":_detailArray[7], //厂商
                                                         @"dealer":_detailArray[6], //经销商
                                                         @"afterServicePhone":_detailArray[8], //售后电话
                                                         @"description": self.textView.text//备注
                                                         }];

                } else {
                    [self.viewModel.buyCommand execute:@{
                                                         @"itemType": @([self.pickerView selectedRowInComponent:0]+1),
                                                         @"labId" : @([ULUserMgr sharedMgr].laboratoryId),
                                                         @"itemName": _detailArray[0+1], //物品名字
                                                         @"quantity": @([_detailArray[1+1] integerValue]), //数量
                                                         @"unitMeasurement":_detailArray[2+1] , //单位
                                                         @"specification":_detailArray[3+1], //规格型号
                                                         @"factory":_detailArray[5+1], //厂商
                                                         @"dealer":_detailArray[4+1], //经销商
                                                         @"afterServicePhone":_detailArray[6+1], //售后电话
                                                         @"description": self.textView.text//备注
                                                         }];

                }
                           }];
            
        }];
    }
    return _useButton;
}

- (UILabel *)label
{
    if (!_label)
    {
        _label = [[UILabel alloc] init];
        _label.text = @"备注";
        _label.textColor = KTextGrayColor;
        _label.font = kFont(kStandardPx(24));
    }
    return _label;
}

- (ULLabObjectViewModel *)viewModel
{
    if (!_viewModel)
    {
        _viewModel = [[ULLabObjectViewModel alloc] init];
    }
    return _viewModel;
}
- (YYTextView *)textView
{
    if (!_textView)
    {
        _textView = [[YYTextView alloc] init];
        _textView.textContainerInset = UIEdgeInsetsMake(10, 15, 0, -15);
        _textView.font = kFont(kStandardPx(28));
        _textView.backgroundColor = kCommonWhiteColor;
        _textView.placeholderText = @"填写备注";
        [self setTextFieldInputAccessoryView:nil];
    }
    return _textView;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"ULMainApplyBuyTableViewCellIdentifier"];
    for (UIView *subview in cell.subviews)
    {
        [subview removeFromSuperview];
    }
    cell.backgroundColor = kCommonWhiteColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = _titleArray[indexPath.row];
    nameLabel.textColor = kTextBlackColor;
    nameLabel.font = kFont(kStandardPx(28));
    [cell addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell).offset(15);
        make.centerY.equalTo(cell);
    }];
    if (indexPath.row !=0)
    {
        UITextField *textField = [[UITextField alloc] init];
        textField.textAlignment = NSTextAlignmentRight;
        textField.placeholder = [NSString stringWithFormat:@"请填写%@", _titleArray[indexPath.row]];
        [self setTextFieldInputAccessoryView:textField];
        textField.font = kFont(kStandardPx(28));
        textField.textColor = kTextBlackColor;
        if (indexPath.row == 2&&[self.pickerView selectedRowInComponent:0]!=2)
        {
            textField.keyboardType = UIKeyboardTypeNumberPad;
        } else if ((indexPath.row == 2 || indexPath.row==3)&&[self.pickerView selectedRowInComponent:0]==2)
        {
            textField.keyboardType = UIKeyboardTypeNumberPad;
        }
        [cell addSubview:textField];
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(cell).offset(-15);
            make.centerY.equalTo(cell);
        }];
        [[textField rac_textSignal] subscribeNext:^(id x) {
            _detailArray[indexPath.row] = x;
        }];
    } else {
        UIImageView *next = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_user_next"]];
        [cell addSubview:next];
        [next mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(cell).offset(-15);
            make.centerY.equalTo(cell);
            make.size.mas_equalTo(CGSizeMake(10, 15));
        }];
        self.pinxiLabel = [[UILabel alloc] init];
        self.pinxiLabel.text = _picekrArray[[self.pickerView selectedRowInComponent:0]];
        self.pinxiLabel.font = kFont(kStandardPx(28));
        self.pinxiLabel.textColor = kTextBlackColor;
        
        [cell addSubview:self.pinxiLabel];
        [self.pinxiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(next.mas_left).offset(-5);
            make.centerY.equalTo(cell);
        }];
    }
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = kBackgroundColor;
    [cell addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.and.left.and.right.equalTo(cell);
        make.height.mas_equalTo(0.5);
    }];
    
    return cell;
}

- (void)setTextFieldInputAccessoryView:(UITextField *)textField{
    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 30)];
    [topView setBarStyle:UIBarStyleDefault];
    UIBarButtonItem * spaceBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [doneBtn setTitle:@"完成" forState:UIControlStateNormal];
    doneBtn.frame = CGRectMake(2, 5, 40, 45);
    [doneBtn addTarget:self action:@selector(dealKeyboardHide) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *doneBtnItem = [[UIBarButtonItem alloc]initWithCustomView:doneBtn];
    NSArray * buttonsArray = [NSArray arrayWithObjects:spaceBtn,doneBtnItem,nil];
    [topView setItems:buttonsArray];
    if (textField)
    {
        [textField setInputAccessoryView:topView];
        [textField setAutocorrectionType:UITextAutocorrectionTypeNo];
        [textField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    } else {
        [self.textView setInputAccessoryView:topView];
        [self.textView setAutocorrectionType:UITextAutocorrectionTypeNo];
        [self.textView setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    }
}

- (void)dealKeyboardHide {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

@end
