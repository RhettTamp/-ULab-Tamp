//
//  ULLoginView.m
//  U-Lab
//
//  Created by 周维康 on 17/5/18.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULLoginView.h"
#import "ULLoginViewModel.h"



@interface ULLoginView() <UITextFieldDelegate>

@property (nonatomic, strong) UIImageView *ulabImageView;  /**< 背景ulab图片 */
@property (nonatomic, strong) UITextField *userTextField;  /**< 账户 */
@property (nonatomic, strong) UITextField *pwdTextField;  /**< 密码 */
@property (nonatomic, strong) UIImageView *userImageView;  /**< 用户图片 */
@property (nonatomic, strong) UIImageView *pwdImageView;  /**< 密码图片 */
@property (nonatomic, strong) UIImageView *backgroundImageView;  /**< 背景图片 */
@property (nonatomic, strong) UIButton *loginButton;  /**< 登录按钮 */
@property (nonatomic, strong) UIButton *forgetButton;  /**< 忘记密码 */
@property (nonatomic, strong) UIButton *registerButton;  /**< 注册按钮 */
@property (nonatomic, strong) UILabel *tipLabel;  /**< 同意协议 */
@property (nonatomic, strong) UIButton *rememberButton;  /**< <#comment#> */
@property (nonatomic, strong) UILabel *rememberLabel;  /**< <#comment#> */

@end
@implementation ULLoginView
{
    UIView *_userLine;
    UIView *_pwdLine;
}

- (instancetype)initWithViewModel:(id<ULViewModelProtocol>)viewModel
{
    self.viewModel = viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)updateConstraints
{
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.ulabImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(161);
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(180, 46));
    }];
    [self.userImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.ulabImageView.mas_bottom).with.offset(91);
        make.left.equalTo(self).with.offset(46);
        make.size.mas_equalTo(CGSizeMake(15, 22));
    }];
    [self.userTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userImageView.mas_right).offset(20);
        make.centerY.equalTo(self.userImageView);
        make.right.equalTo(self).offset(-45);
    }];
    [_userLine mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.userTextField);
        make.height.mas_equalTo(0.5);
        make.bottom.equalTo(self.userTextField).offset(5);
    }];
    [self.pwdImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.centerX.equalTo(self.userImageView);
        make.top.equalTo(self.userImageView.mas_bottom).offset(39);
        make.size.mas_equalTo(CGSizeMake(20.5, 19));
    }];
    [self.pwdTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.userTextField);
        make.centerY.equalTo(self.pwdImageView);
    }];
    [_pwdLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.pwdTextField);
        make.height.equalTo(_userLine);
        make.bottom.equalTo(self.pwdTextField).with.offset(5);
    }];
    [self.rememberButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.pwdTextField).offset(-12);
        make.size.mas_equalTo(CGSizeMake(30, 20));
        make.top.equalTo(_pwdLine.mas_bottom).offset(8);
    }];
    [self.rememberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.rememberButton.mas_right).offset(6);
        make.centerY.equalTo(self.rememberButton);
    }];
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(40);
        make.top.equalTo(self.rememberButton.mas_bottom).with.offset(20);
        make.centerX.equalTo(self);
    }];
    [self.forgetButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.pwdImageView);
        make.top.equalTo(self.loginButton.mas_bottom).offset(20);
    }];
    [self.registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-46);
        make.top.equalTo(self.forgetButton);
    }];
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-10);
        make.centerX.equalTo(self);
    }];
    [super updateConstraints];
}

- (void)ul_setupViews
{
    [self addSubview:self.backgroundImageView];
    [self addSubview:self.ulabImageView];
    [self addSubview:self.userImageView];
    [self addSubview:self.pwdImageView];
    [self addSubview:self.pwdTextField];
    [self addSubview:self.userTextField];
    [self addSubview:self.loginButton];
    [self addSubview:self.forgetButton];
    [self addSubview:self.registerButton];
    [self addSubview:_userLine];
    [self addSubview:_pwdLine];
    [self addSubview:self.tipLabel];
    [self addSubview:self.rememberButton];
    [self addSubview:self.rememberLabel];
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    [self registerNotification];
}

- (void)registerNotification
{
    @weakify(self)
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillShowNotification object:nil]
     subscribeNext:^(NSNotification *notification) {
         @strongify(self)
         NSDictionary *info = [notification userInfo];
         NSValue *keyboardFrameValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
         CGRect keyboardFrame = [keyboardFrameValue CGRectValue];
         [UIView animateWithDuration:1.0f animations:^{
             [self.ulabImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                 make.top.equalTo(self).offset(161-keyboardFrame.size.height/2);
             }];
             [self.ulabImageView.superview layoutIfNeeded];
         }];
         
         
     }];
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillHideNotification object:nil] subscribeNext:^(id x) {
        @strongify(self)
        [UIView animateWithDuration:1.0f animations:^{
            [self.ulabImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self).offset(161);
            }];
            [self.ulabImageView.superview layoutIfNeeded];
        }];
    }];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:UIKeyboardWillShowNotification];
    [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:UIKeyboardWillHideNotification];
}
#pragma mark - lazyLoad
- (ULLoginViewModel *)viewModel
{
    if (!_viewModel)
    {
        _viewModel = [[ULLoginViewModel alloc] init];
    }
    return _viewModel;
}

- (UIButton *)loginButton
{
    if (!_loginButton)
    {
        _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
        [_loginButton setTitleColor:kCommonWhiteColor forState:UIControlStateNormal];
        _loginButton.backgroundColor = kCommonBlueColor;
        _loginButton.layer.cornerRadius = 5;
        _loginButton.layer.masksToBounds = YES;
        @weakify(self)
        [[_loginButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self)
            if ([self.userTextField.text  isEqual: @""])
            {
                [ULProgressHUD showWithMsg:@"请输入手机号或邮箱" inView:self];
            } else if ([self.pwdTextField.text isEqualToString:@""]) {
                [ULProgressHUD showWithMsg:@"请输入用户密码" inView:self];
            } else {
                [ULProgressHUD showWithMsg:@"登录中" inView:self withBlock:^{
                    [self.viewModel.loginCommand execute:@{
                                                           @"userName" : self.userTextField.text,
                                                           @"password" : self.pwdTextField.text
                                                           }];
//                    if (_rememberButton.selected)
//                    {
//                        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"user_remember"];
//                    } else {
//                        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"user_remember"];
//                    }

                }];
            }
                    }];
    }
    return _loginButton;
}

- (UIButton *)rememberButton
{
    if (!_rememberButton)
    {
        _rememberButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rememberButton setImage:[UIImage imageNamed:@"ulab_remember"] forState:UIControlStateNormal];
        [_rememberButton setImage:[UIImage imageNamed:@"ulab_remember_s"] forState:UIControlStateSelected];
        _rememberButton.titleLabel.font = kFont(kStandardPx(26));
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"user_remember"] isEqual:@"1"])
        {
            _rememberButton.selected = YES;
        } else {
            _rememberButton.selected = NO;
        }
        [[_rememberButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            _rememberButton.selected = !_rememberButton.isSelected;
            if (_rememberButton.selected)
            {
                [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"user_remember"];
            } else {
                [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"user_remember"];
            }
        }];
    }
    return _rememberButton;
}

- (UILabel *)rememberLabel
{
    if (!_rememberLabel)
    {
        _rememberLabel = [[UILabel alloc] init];
        _rememberLabel.text = @"记住密码";
        _rememberLabel.font = kFont(kStandardPx(32));
        _rememberLabel.textColor = KTextGrayColor;
    }
    return _rememberLabel;
}

- (UIButton *)forgetButton
{
    if (!_forgetButton)
    {
        _forgetButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_forgetButton setTitle:@"忘记密码" forState:UIControlStateNormal];
        [_forgetButton setTitleColor:kCommonGrayColor forState:UIControlStateNormal];
        _forgetButton.titleLabel.font = kFont(kStandardPx(26));
        [[_forgetButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            [self.viewModel.forgetSubject sendNext:nil];
        }];
    }
    return _forgetButton;
}

- (UIButton *)registerButton
{
    if (!_registerButton)
    {
        _registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_registerButton setTitle:@"注册新账号" forState:UIControlStateNormal];
        [_registerButton setTitleColor:kCommonBlueColor forState:UIControlStateNormal];
        _registerButton.titleLabel.font = kFont(kStandardPx(26));
        [[_registerButton rac_signalForControlEvents:UIControlEventTouchUpInside]
         subscribeNext:^(id x) {
             [self.viewModel.registerSubject sendNext:nil];
         }];
    }
    return _registerButton;
}
- (UIImageView *)backgroundImageView
{
    if (!_backgroundImageView)
    {
        _backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_background"]];
    }
    return _backgroundImageView;
}

- (UIImageView *)ulabImageView
{
    if (!_ulabImageView)
    {
        _ulabImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_ulab"]];
    }
    return _ulabImageView;
}

- (UIImageView *)userImageView
{
    if (!_userImageView)
    {
        _userImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_user"]];
    }
    return _userImageView;
}

- (UIImageView *)pwdImageView
{
    if (!_pwdImageView)
    {
        _pwdImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_password"]];
    }
    return _pwdImageView;
}

- (UITextField *)userTextField
{
    if (!_userTextField)
    {
        _userTextField = [[UITextField alloc] init];
        _userTextField.delegate = self;
        _userTextField.placeholder = @"请输入您的手机号或邮箱";
        _userTextField.font = kFont(kStandardPx(30));
        _userLine = [[UIView alloc] init];
        _userLine.backgroundColor = kCommonGrayColor;
        _userTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        if ([ULUserMgr sharedMgr].userPhone)
        _userTextField.text = [ULUserMgr sharedMgr].userPhone;
        [_userTextField addSubview:_userLine];
        
        _userTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"private_user_account"];
    }
    return _userTextField;
}

- (UITextField *)pwdTextField
{
    if (!_pwdTextField)
    {
        _pwdTextField = [[UITextField alloc] init];
        _pwdTextField.delegate = self;
        _pwdTextField.placeholder = @"请输入您的密码";
        _pwdTextField.font = kFont(kStandardPx(30));
        _pwdLine = [[UIView alloc] init];
        _pwdLine.backgroundColor = kCommonGrayColor;
        _pwdTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _pwdTextField.secureTextEntry = YES;
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"user_remember"] boolValue])
        {
            _pwdTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_password"];
        }
        [_pwdTextField addSubview:_pwdLine];
    }
    return _pwdTextField;
}

- (UILabel *)tipLabel
{
    if (!_tipLabel)
    {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.text = @"登录代表您已同意《U-Lab用户协议》";
        _tipLabel.textColor = kCommonGrayColor;
        _tipLabel.font = kFont(kStandardPx(18));
    }
    return _tipLabel;
}
#pragma mark - 收起键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.pwdTextField resignFirstResponder];
    [self.userTextField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.pwdTextField resignFirstResponder];
    [self.userTextField resignFirstResponder];
}
@end
