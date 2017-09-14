//
//  ULFeedbackView.m
//  U-Lab
//
//  Created by 周维康 on 17/5/28.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULFeedbackView.h"
#import "YYText.h"
#import "ULHelpViewModel.h"

@interface ULFeedbackView() <UITextFieldDelegate, YYTextViewDelegate>

@property (nonatomic, strong) UILabel *adviceLabel;  /**< 问题和意见 */
@property (nonatomic, strong) UILabel *phoneLabel;  /**< 联系电话 */
@property (nonatomic, strong) YYTextView *feedText;  /**< 反馈文本 */
@property (nonatomic, strong) UITextField *phoneTextField;  /**< 电话 */
@property (nonatomic, strong) UIButton *commitButton;  /**< 提交按钮 */
@property (nonatomic, strong) ULHelpViewModel *viewModel;  /**< viewmodel */
@end

@implementation ULFeedbackView

- (void)ul_setupViews
{
    self.popSubject = [RACSubject subject];
    self.viewModel = [[ULHelpViewModel alloc] init];
    self.backgroundColor = kBackgroundColor;
    [self addSubview:self.adviceLabel];
    [self addSubview:self.phoneTextField];
    [self addSubview:self.feedText];
    [self addSubview:self.phoneLabel];
    [self addSubview:self.commitButton];
    [self updateConstraintsIfNeeded];
    [self setNeedsUpdateConstraints];
}

- (void)ul_bindViewModel
{
    [self.viewModel.feedbackCommand.executionSignals.flatten subscribeNext:^(id x) {
        [ULProgressHUD showWithMsg:@"反馈成功"];
        [self.popSubject sendNext:nil];
    }];
}
- (void)updateConstraints
{
    [self.adviceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.top.equalTo(self).offset(64+30);
    }];
    [self.feedText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.adviceLabel.mas_bottom).offset(10);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(150);
    }];
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.feedText.mas_bottom).offset(30);
        make.left.equalTo(self.adviceLabel);
    }];
    [self.phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneLabel.mas_bottom).offset(10);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(45);
    }];
    [self.commitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.left.equalTo(self).offset(24);
        make.height.mas_equalTo(44);
        make.top.equalTo(self.phoneTextField.mas_bottom).offset(45);
    }];
    [super updateConstraints];
}
- (UILabel *)adviceLabel
{
    if (!_adviceLabel)
    {
        _adviceLabel = [[UILabel alloc] init];
        _adviceLabel.text = @"问题和意见";
        _adviceLabel.font = kFont(kStandardPx(28));
        _adviceLabel.textColor = KTextGrayColor;
    }
    return _adviceLabel;
}

- (UILabel *)phoneLabel
{
    if (!_phoneLabel)
    {
        _phoneLabel = [[UILabel alloc] init];
        _phoneLabel.textColor = KTextGrayColor;
        _phoneLabel.font = kFont(kStandardPx(28));
        _phoneLabel.text = @"联系电话";
    }
    return _phoneLabel;
}

- (YYTextView *)feedText
{
    if (!_feedText)
    {
        _feedText = [[YYTextView alloc] init];
        _feedText.placeholderText = @"请填写您对本产品的建议";
        _feedText.font = kFont(kStandardPx(34));
        _feedText.delegate = self;
        _feedText.placeholderFont = kFont(kStandardPx(34));
        _feedText.backgroundColor = kCommonWhiteColor;
        _feedText.textContainerInset = UIEdgeInsetsMake(10, 15, 0, -15);
    }
    return _feedText;
}

- (UITextField *)phoneTextField
{
    if (!_phoneTextField)
    {
        _phoneTextField = [[UITextField alloc] init];
        _phoneTextField.font = kFont(kStandardPx(34));
        _phoneTextField.placeholder = @"选填，便于我们与您联系";
        _phoneTextField.delegate = self;
        UIView *leftView = [[UIView alloc] init];
        leftView.backgroundColor = kCommonWhiteColor;
        leftView.frame = CGRectMake(0, 0, 14, 45);
        _phoneTextField.leftView = leftView;
        _phoneTextField.leftViewMode = UITextFieldViewModeAlways;
        _phoneTextField.backgroundColor = kCommonWhiteColor;
    }
    return _phoneTextField;
}

- (UIButton *)commitButton
{
    if (!_commitButton)
    {
        _commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _commitButton.layer.cornerRadius = 5;
        _commitButton.layer.masksToBounds = YES;
        _commitButton.backgroundColor = kCommonBlueColor;
        [_commitButton setTitleColor:kCommonWhiteColor forState:UIControlStateNormal];
        [_commitButton setTitle:@"提交" forState:UIControlStateNormal];
        [[_commitButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            if ([self.feedText.text  isEqual: @""])
            {
                [ULProgressHUD showWithMsg:@"请填写反馈内容"];
            } else {
                [ULProgressHUD showWithMsg:@"反馈中" inView:self withBlock:^{
                    [self.viewModel.feedbackCommand execute:@{
                                                              @"content" : self.feedText.text
                                                              }];

                }];
                        }
        }];
    }
    return _commitButton;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.phoneTextField resignFirstResponder];
    [self.feedText resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.feedText resignFirstResponder];
    [self.phoneTextField resignFirstResponder];
}
@end
