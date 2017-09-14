//
//  ULMainCheckUseViewController.m
//  ULab
//
//  Created by 周维康 on 2017/6/15.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULMainCheckUseViewController.h"
#import "ULUserObjectModel.h"
#import "ULLabObjectViewModel.h"

@interface ULMainCheckUseViewController () <UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) UITableView *tableView;  /**< tableView */
@property (nonatomic, strong) UIImageView *bottomView;  /**< bottomView */
@property (nonatomic, strong) UIButton *useButton;  /**< button */
@property (nonatomic, strong) ULUserObjectModel *model;  /**< model */
@property (nonatomic, strong) ULLabObjectViewModel *viewModel;  /**< vm */
@property (nonatomic, strong) NSNumber *number;  /**< number */
@property (nonatomic, strong) UIPickerView *pickerView;  /**< <#comment#> */
@property (nonatomic, strong) UILabel *numLabel;  /**< 数量 */
@property (nonatomic, strong) UIView *whiteView;  /**< <#comment#> */

@end

@implementation ULMainCheckUseViewController
{
    NSArray *_nameArray;
    NSArray *_detailArray;
}

- (instancetype)initWithObjectModel:(ULUserObjectModel *)model
{
    self.model = model;
    self = [super init];
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.pickerView selectRow:0 inComponent:0 animated:YES];
}
- (void)ul_layoutNavigation
{
    self.title = @"使用登记";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)ul_addSubviews
{
    _nameArray = @[@"物品名称：", @"物品编号：", @"规格参数：", @"联系方式：", @"使用数量："];
    _detailArray = @[self.model.objectName, [NSString stringWithFormat:@"%@",@(self.model.objectId)], self.model.specification?:@"", [[NSUserDefaults standardUserDefaults] objectForKey:@"private_user_account"], @"请选择数量"];
    self.viewModel = [[ULLabObjectViewModel alloc] init];
    [self.view addSubview:self.useButton];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomView];
    [self.view setNeedsUpdateConstraints];
    [self.view updateConstraintsIfNeeded];
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
        self.numLabel.text = [NSString stringWithFormat:@"%lu",[self.pickerView selectedRowInComponent:0]+1];
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
}

- (void)ul_bindViewModel
{
    [self.viewModel.lendCommand.executionSignals.flatten subscribeNext:^(id x) {
        if ([x[@"success"] integerValue]) {
            [ULProgressHUD showWithMsg:@"借用成功"];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else if([x[@"errCode"] integerValue] == 50014){
            [ULProgressHUD showWithMsg:@"对不起，您没有借用权限"];
            
        }else if([x[@"errCode"] integerValue] == 50008){
            [ULProgressHUD showWithMsg:@"借用失败，积分不够"];
        }else{
            [ULProgressHUD showWithMsg:@"借用失败"];
        }
        
    }];
}
- (void)updateViewConstraints
{
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(74);
        make.height.mas_equalTo(_nameArray.count*45);
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        make.height.mas_equalTo(33);
    }];
    [self.useButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.top.equalTo(self.tableView.mas_bottom).offset(40);
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(44);
    }];
    [super updateViewConstraints];
}

- (UIButton *)useButton
{
    if (!_useButton)
    {
        _useButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _useButton.backgroundColor = KButtonBlueColor;
        [_useButton setTitle:@"登记使用" forState:UIControlStateNormal];
        [_useButton setTitleColor:kCommonWhiteColor forState:UIControlStateNormal];
        _useButton.layer.cornerRadius = 5;
        _useButton.layer.masksToBounds = YES;
        [[_useButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            
            if (self.numLabel.text)
            {
                [self.viewModel.lendCommand execute:@{
                                                  @"senderId":[ULUserMgr sharedMgr].userId, //物品idid
                                                  @"itemId":@(self.model.objectId), //借用物品的id
                                                  @"quantity":@([self.numLabel.text integerValue])//借用数量，如果是动物分雌雄，例子：1/2（前面是雌，后面是雄）
                                                  }];
            } else {
                [ULProgressHUD showWithMsg:@"请选择数量" inView:self.view];
            }
        }];
    }
    return _useButton;
}

- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = kBackgroundColor;
        _tableView.rowHeight = 45;
        _tableView.scrollEnabled = NO;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ULMainCheckUseTableViewCellIdentifier"];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _nameArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"ULMainCheckUseTableViewCellIdentifier"];
    for (UIView *subView in cell.subviews)
    {
        [subView removeFromSuperview];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = _nameArray[indexPath.row];
    nameLabel.textColor = KTextGrayColor;
    nameLabel.font = kFont(kStandardPx(32));
    [cell addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell).offset(15);
        make.centerY.equalTo(cell);
    }];
    if (indexPath.row == 3)
    {
        UITextField *textField = [[UITextField alloc] init];
        textField.text = _detailArray[indexPath.row];
        textField.font = kFont(kStandardPx(32));
        textField.textAlignment = NSTextAlignmentCenter;
        @weakify(self)
        [[textField rac_textSignal] subscribeNext:^(id x) {
            @strongify(self)
            self.number = x;
        }];
        [self setTextFieldInputAccessoryView:textField];
        [cell addSubview:textField];
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(nameLabel.mas_right).offset (15);
            make.right.equalTo(cell).offset(-15);
            make.centerY.equalTo(cell);
        }];
    } else if (indexPath.row == 4) {
      
        self.numLabel = [[UILabel alloc] init];
        self.numLabel.textColor = KTextGrayColor;
        self.numLabel.font = kFont(kStandardPx(28));
        [cell addSubview:self.numLabel];
        [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(cell).offset(-15);
            make.centerY.equalTo(cell);
        }];
    } else {
        UILabel *detailLabel = [[UILabel alloc] init];
        detailLabel.textColor = KTextGrayColor;
        detailLabel.text = _detailArray[indexPath.row];
        detailLabel.font = kFont(kStandardPx(28));
        detailLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        detailLabel.textAlignment = NSTextAlignmentCenter;
        [cell addSubview:detailLabel];
        [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(cell).offset(-15);
            make.centerY.equalTo(cell);
        }];
    }
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = kBackgroundColor;
    [cell addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(cell);
        make.height.mas_equalTo(0.5);
    }];
    return cell;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.model.objectQuantity;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [NSString stringWithFormat:@"%@", @(row+1)];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 4)
    {
        [self.whiteView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_bottom).offset(-180-45);
        }];
    }
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.numLabel.text = [NSString stringWithFormat:@"%@", @(row+1)];
}
- (void)setTextFieldInputAccessoryView:(UITextField *)textField{
    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 40)];
    [topView setBarStyle:UIBarStyleDefault];
    UIBarButtonItem * spaceBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [doneBtn setTitle:@"完成" forState:UIControlStateNormal];
    doneBtn.frame = CGRectMake(2, 5, 40, 45);
    [doneBtn addTarget:self action:@selector(dealKeyboardHide) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *doneBtnItem = [[UIBarButtonItem alloc]initWithCustomView:doneBtn];
    NSArray * buttonsArray = [NSArray arrayWithObjects:spaceBtn,doneBtnItem,nil];
    [topView setItems:buttonsArray];
    [textField setInputAccessoryView:topView];
    [textField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [textField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
}
- (void)dealKeyboardHide {
    if ([self.numLabel.text isEqual:@""])
    self.numLabel.text = [NSString stringWithFormat:@"%@", @([self.pickerView selectedRowInComponent:0]+1)];
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
