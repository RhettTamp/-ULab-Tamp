//
//  ULMessageFriendSearchView.m
//  ULab
//
//  Created by 周维康 on 2017/6/10.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULMessageFriendSearchView.h"

@interface ULMessageFriendSearchView() <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *textField;  /**< 输入框 */
@property (nonatomic, strong) UIButton *searchButton;  /**< 查找按钮 */
@property (nonatomic, strong) UILabel *tipLabel;  /**< 提示 */

@end

@implementation ULMessageFriendSearchView

- (void)ul_setupViews
{
    self.backgroundColor = kBackgroundColor;
    [self addSubview:self.textField];
    [self addSubview:self.searchButton];
    [self addSubview:self.tipLabel];
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}
- (void)ul_bindViewModel
{
    _searchButton.rac_command = self.viewModel.searchCommand;
    @weakify(self)
    [_searchButton.rac_command.executionSignals.flatten subscribeNext:^(id x) {
        @strongify(self)
        [ULProgressHUD hide];
        [self.textField resignFirstResponder];
    }];
    [[_textField rac_textSignal] subscribeNext:^(id x) {
        @strongify(self)
        self.viewModel.searchString = x;
    }];
    [_searchButton.rac_command.errors subscribeNext:^(NSError *error) {
        [ULProgressHUD showWithMsg:@"请求失败" inView:self];
    }];
}
- (void)updateConstraints
{
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

- (UILabel *)tipLabel
{
    if (!_tipLabel)
    {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.text = @"添加一个好友／群";
        _tipLabel.font = kFont(kStandardPx(34));
        _tipLabel.textColor = [UIColor blackColor];
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
        [_searchButton setBackgroundImage:[UIImage imageNamed:@"home_searchButton"] forState:UIControlStateNormal];
    }
    return _searchButton;
}

- (ULMessageFriendViewModel *)viewModel
{
    if (!_viewModel)
    {
        _viewModel = [[ULMessageFriendViewModel alloc] init];
    }
    return _viewModel;
}
- (UITextField *)textField
{
    if (!_textField)
    {
        _textField = [[UITextField alloc] init];
        NSAttributedString *attributeString = [[NSAttributedString alloc] initWithString:@"请输入注册账号/群号" attributes:@{NSForegroundColorAttributeName : kCommonBlueColor}];
        _textField.attributedPlaceholder = attributeString;
        _textField.delegate = self;
        _textField.layer.cornerRadius = kStandardPx(28);
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
