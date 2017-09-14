//
//  ULLabSearchView.m
//  U-Lab
//
//  Created by 周维康 on 2017/6/3.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULLabSearchView.h"
#import "ULSearchLabViewModel.h"

@interface ULLabSearchView() <UITextFieldDelegate>

@property (nonatomic, strong) UIImageView *backgroundImageView;  /**< 背景 */
@property (nonatomic, strong) UITextField *textField;  /**< 输入框 */
@property (nonatomic, strong) UIButton *searchButton;  /**< 查找按钮 */
@property (nonatomic, strong) UILabel *tipLabel;  /**< 提示 */
@property (nonatomic, strong) NSArray *labArray;  /**< 实验室数组 */
@end
@implementation ULLabSearchView

- (void)ul_setupViews
{
    [self addSubview:self.backgroundImageView];
    [self addSubview:self.textField];
    [self addSubview:self.searchButton];
    [self addSubview:self.tipLabel];
    if (!self.isFirstShow) {
        _tipLabel.text = @"查找实验室";
        NSAttributedString *attributeString = [[NSAttributedString alloc] initWithString:@"搜索实验室" attributes:@{NSForegroundColorAttributeName : kCommonBlueColor}];
        _textField.attributedPlaceholder = attributeString;
    }
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}
- (void)ul_bindViewModel
{
    self.labArray = [NSArray array];
    self.searchSubject = [RACSubject subject];
    @weakify(self)
    [[_searchButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        [ULProgressHUD showWithMsg:@"搜索中" inView:self withBlock:^{
            [self.viewModel.searchCommand execute:self.textField.text];
        }];
    }];
    [self.viewModel.searchCommand.executionSignals.flatten subscribeNext:^(id x) {
        @strongify(self)
        [ULProgressHUD hide];
        [self.textField resignFirstResponder];
        self.labArray = x;
        if (self.labArray.count == 0)
        {
            [ULProgressHUD showWithMsg:@"搜索无结果" inView:self];
        } else if (self.labArray.count>0) {
            [self.searchSubject sendNext:x];
        }
    }];
    [[_textField rac_textSignal] subscribeNext:^(id x) {
        @strongify(self)
        self.viewModel.searchKey = x;
    }];
    [self.viewModel.searchCommand.errors subscribeNext:^(NSError *error) {
        [ULProgressHUD showWithMsg:@"请求失败" inView:self];
    }];
}
- (void)updateConstraints
{
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(64+70);
    }];
    [self.searchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-15);
        make.top.equalTo(self.tipLabel.mas_bottom).offset(60);
        make.size.mas_equalTo(CGSizeMake(58, 28));
    }];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self.searchButton.mas_left).offset(-8);
        make.height.mas_equalTo(28);
        make.centerY.equalTo(self.searchButton);
    }];
    
    [super updateConstraints];
}

- (UIImageView *)backgroundImageView
{
    if (!_backgroundImageView)
    {
        _backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ulab_background"]];
    }
    return _backgroundImageView;
}

- (UILabel *)tipLabel
{
    if (!_tipLabel)
    {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.text = @"您还没加入实验室";
        _tipLabel.font = kFont(kStandardPx(34));
        _tipLabel.textColor = KTextGrayColor;
    }
    return _tipLabel;
}
- (UIButton *)searchButton
{
    if (!_searchButton)
    {
        _searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_searchButton setTitle:@"搜索" forState:UIControlStateNormal];
        [_searchButton setTitleColor:kCommonWhiteColor forState:UIControlStateNormal];
        [_searchButton setBackgroundImage:[UIImage imageWithColor:KButtonBlueColor] forState:UIControlStateNormal];
        _searchButton.layer.cornerRadius = 5;
        _searchButton.layer.masksToBounds = YES;
    }
    return _searchButton;
}

- (ULSearchLabViewModel *)viewModel
{
    if (!_viewModel)
    {
        _viewModel = [[ULSearchLabViewModel alloc] init];
    }
    return _viewModel;
}
- (UITextField *)textField
{
    if (!_textField)
    {
        _textField = [[UITextField alloc] init];
        NSAttributedString *attributeString = [[NSAttributedString alloc] initWithString:@"请加入一个实验室" attributes:@{NSForegroundColorAttributeName : kCommonBlueColor}];
        _textField.attributedPlaceholder = attributeString;
        _textField.delegate = self;
        _textField.layer.cornerRadius = 5;
        _textField.layer.borderWidth = 0.8;
        _textField.backgroundColor = kCommonWhiteColor;
        _textField.layer.borderColor = kCommonLightGrayColor.CGColor;
        _textField.layer.masksToBounds = YES;
        _textField.textColor = [UIColor colorWithRGBHex:0x333333];
        _textField.leftViewMode = UITextFieldViewModeAlways;
        UIView *whiteView = [[UIView alloc] init];
        whiteView.backgroundColor = kCommonWhiteColor;
        whiteView.frame = CGRectMake(0, 0, 25, 25);
        _textField.leftView = whiteView;
    }
    return _textField;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.textField resignFirstResponder];
}
@end
