//
//  ULForgetView.m
//  U-Lab
//
//  Created by 周维康 on 17/5/30.
//  Copyright © 2017年 周维康. All rights reserved.
//



#import "ULForgetView.h"
#import "ULHomeViewController.h"
#import "ULCountDownManager.h"

@interface ULForgetView() <UITextFieldDelegate>

@property (nonatomic, strong) UIImageView *userImageView;  /**< 手机号 */
@property (nonatomic, strong) UIImageView *validImageView;  /**< 验证码 */
@property (nonatomic, strong) UIImageView *pwdImageView;  /**< 密码 */
@property (nonatomic, strong) UITextField *userTextField;  /**< 手机号 */
@property (nonatomic, strong) UITextField *validTextField;  /**< 验证码 */
@property (nonatomic, strong) UITextField *pwdTextField;  /**< 密码 */
@property (nonatomic, strong) UIButton *getValidButton;  /**< 获取验证码 */
@property (nonatomic, strong) UIButton *registerButton;  /**< 注册按钮 */
@property (nonatomic, strong) UIButton *emailButton;  /**< 邮箱注册 */
@property (nonatomic, strong) UIImageView *bottomView;  /**< 底部花篮 */
@property (nonatomic, strong) UIButton *eyeButton;  /**< 查看密码 */
@property (nonatomic, copy) NSString *phoneNumber;  /**< 电话号码 */
@property (nonatomic, strong) UIButton *reEyeButton;  /**< <#comment#> */
@property (nonatomic, strong) UITextField *reTextField;  /**< 再次数日密码 */
@property (nonatomic, strong) UIImageView *reImageView;  /**< <#comment#> */

@end

@implementation ULForgetView
{
    UIView *_whiteView;
    UIView *_userLine;
    UIView *_validLine;
    UIView *_pwdLine;
    NSInteger type;
    BOOL _isLogin;
}

- (instancetype)initWithPhone:(NSString *)phoneNumber isLogin:(BOOL)isLogin
{
    type = 0;
    _isLogin = isLogin;
    self.phoneNumber = phoneNumber;
    if (self = [super init])
    {
        
    }
    return self;
}
- (void)ul_setupViews
{
    self.backgroundColor = kBackgroundColor;
    _whiteView = [[UIView alloc] init];
    _whiteView.backgroundColor = [UIColor whiteColor];
    _userLine = [[UIView alloc] init];
    _userLine.backgroundColor = kBackgroundColor;
    _validLine = [[UIView alloc] init];
    _validLine.backgroundColor = kBackgroundColor;
    _pwdLine = [[UIView alloc] init];
    _pwdLine.backgroundColor = kBackgroundColor;
    [self addSubview:_whiteView];
    [self addSubview:_userLine];
    [self addSubview:_validLine];
    [self addSubview:_pwdLine];
    [self addSubview:self.userImageView];
    [self addSubview:self.validImageView];
    [self addSubview:self.pwdImageView];
    [self addSubview:self.userTextField];
    [self addSubview:self.pwdTextField];
    [self addSubview:self.validTextField];
    [self addSubview:self.getValidButton];
    [self addSubview:self.registerButton];
    [self addSubview:self.bottomView];
    [self addSubview:self.emailButton];
    [self addSubview:self.eyeButton];
    [self addSubview:self.reTextField];
    [self addSubview:self.reImageView];
    [self addSubview:self.reEyeButton];
    [self updateConstraintsIfNeeded];
    [self setNeedsUpdateConstraints];
}

- (void)ul_bindViewModel
{
    [self.viewModel.validSubject subscribeNext:^(id x) {
        [ULProgressHUD showWithMsg:@"发送成功" inView:self];
        [[ULCountdownManager defaultManager]  scheduledCountDownWithKey:@"ULForgetGetValidateKey" timeInterval:60 countingDown:^(NSTimeInterval leftTimeInterval) {
            [self.getValidButton setTitle:[NSString stringWithFormat:@"%gs",leftTimeInterval] forState:UIControlStateNormal];
            self.getValidButton.backgroundColor = kCommonGrayColor;
            self.getValidButton.userInteractionEnabled = NO;
        } finished:^(NSTimeInterval finalTimeInterval) {
            self.getValidButton.backgroundColor = kCommonBlueColor;
            [self.getValidButton setTitle:@"再次获取" forState:UIControlStateNormal];
            self.getValidButton.userInteractionEnabled = YES;
        }];
        
        NSString *user_key = x[@"data"][@"key"];
        [[NSUserDefaults standardUserDefaults] setObject:user_key forKey:@"user_key"];
        
    }];
    [self.viewModel.validSubject subscribeError:^(NSError *error) {
        [ULProgressHUD showWithMsg:@"请求失败" inView:self];
    }];
}

- (void)updateConstraints
{
    [_whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(64);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(180);
    }];
    [self.userImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(25);
        make.top.equalTo(_whiteView).offset(11.5);
        make.size.mas_equalTo(CGSizeMake(15, 22));
    }];
    [self.getValidButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-25);
        make.centerY.equalTo(self.userTextField);
        make.size.mas_equalTo(CGSizeMake(90, 32));
    }];
    [self.userTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userImageView.mas_right).offset(18);
        make.centerY.equalTo(self.userImageView);
        make.right.equalTo(self.getValidButton.mas_left).with.offset(-24);
    }];
    [_userLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(_whiteView);
        make.top.equalTo(_whiteView).offset(45);
        make.height.mas_equalTo(0.5);
    }];
    [self.validImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userImageView.mas_bottom).offset(23);
        make.centerX.equalTo(self.userImageView);
        make.size.mas_equalTo(CGSizeMake(15, 22));
    }];
    [self.validTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userTextField);
        make.right.equalTo(self).with.offset(-50);
        make.centerY.equalTo(self.validImageView);
    }];
    [_validLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.height.equalTo(_userLine);
        make.top.equalTo(_whiteView).offset(90);
    }];
    [self.pwdImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.userImageView);
        make.top.equalTo(self.validImageView.mas_bottom).offset(26);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];
    
    [self.eyeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-25);
        make.centerY.equalTo(self.pwdImageView);
        make.size.mas_equalTo(CGSizeMake(30, 18));
    }];
    [self.pwdTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.pwdImageView.mas_right).offset(18);
        make.right.equalTo(self.eyeButton.mas_left).offset(-40);
        make.centerY.equalTo(self.pwdImageView);
    }];
    [_pwdLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.height.equalTo(_userLine);
        make.top.equalTo(_whiteView).offset(135);
    }];
    [self.reImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.userImageView);
        make.top.equalTo(self.pwdImageView.mas_bottom).offset(29);
        make.size.mas_equalTo(CGSizeMake(16, 16));
        
    }];
    [self.reEyeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-25);
        make.centerY.equalTo(self.reImageView);
        make.size.mas_equalTo(CGSizeMake(30, 18));
    }];
    [self.reTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.reImageView.mas_right).offset(18);
        make.right.equalTo(self.reEyeButton.mas_left).offset(-40);
        make.centerY.equalTo(self.reImageView);
    }];
    
    [self.registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.left.equalTo(self).offset(25);
        make.top.equalTo(self.reImageView.mas_bottom).offset(54);
        make.height.mas_equalTo(44);
    }];
    [self.emailButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-36);
        make.top.equalTo(self.registerButton.mas_bottom).offset(15);
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(33);
    }];
    [super updateConstraints];
}


#pragma mark - lazyLoad
- (ULForgetViewModel *)viewModel
{
    if (!_viewModel)
    {
        _viewModel = [[ULForgetViewModel alloc] init];
    }
    return _viewModel;
}

- (UIButton *)registerButton
{
    if (!_registerButton)
    {
        _registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_registerButton setTitle:@"确定" forState:UIControlStateNormal];
        [_registerButton setTitleColor:kCommonWhiteColor forState:UIControlStateNormal];
        _registerButton.backgroundColor = kCommonBlueColor;
        _registerButton.layer.cornerRadius = 5;
        _registerButton.layer.masksToBounds = YES;
        @weakify(self)
        [[_registerButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self)
            if (self.userTextField.text.length < 6)
            {
                [ULProgressHUD showWithMsg:@"请输入正确的手机号或邮箱" inView:self];
            } else if ([self.validTextField.text isEqualToString:@""]) {
                [ULProgressHUD showWithMsg:@"请输入验证码" inView:self];
            } else if ([self.pwdTextField.text isEqualToString:@""]) {
                [ULProgressHUD showWithMsg:@"请输入密码" inView:self];
            } else if (self.pwdTextField.text != self.reTextField.text) {
                [ULProgressHUD showWithMsg:@"请确保两次输入密码一致" inView:self];
            } else {
                [ULProgressHUD showWithMsg:@"密码修改中" inView:self withBlock:^{
                    [JMSGUser loginWithUsername:[[NSUserDefaults standardUserDefaults] objectForKey:@"private_user_account"] password:[[NSUserDefaults standardUserDefaults] objectForKey:@"user_password"] completionHandler:^(id resultObject, NSError *error) {
                        if (!error) {
                            NSLog(@"JMSG login success");
                        }
                    }];
                    if (_isLogin) {
                        [self.viewModel.changeCommand execute:@{                                                                @"newPassword" : self.pwdTextField.text,
                                                                                                                                @"verificationCode" : self.validTextField.text,
                                                                                                                                @"key" : [[NSUserDefaults standardUserDefaults] objectForKey:@"user_key"],
                                                                                                                                }];
                    }else
                        
                        [self.viewModel.forgetCommand execute:@{
                                                                @"type":@(type),
                                                                @"userName" : self.userTextField.text,
                                                                @"newPassword" : self.pwdTextField.text,
                                                                @"verificationCode" : self.validTextField.text,
                                                                @"key" : [[NSUserDefaults standardUserDefaults] objectForKey:@"user_key"],
                                                                }];
                    
                }];
            }
            
        }];
    }
    return _registerButton;
}

- (UIButton *)emailButton
{
    if (!_emailButton)
    {
        _emailButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_emailButton setTitle:@"点此用邮箱修改" forState:UIControlStateNormal];
        [_emailButton setTitleColor:kCommonBlueColor forState:UIControlStateNormal];
        _emailButton.titleLabel.font = kFont(kStandardPx(26));
        [[_emailButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            if (type == 0) {
                type = 1;
                [_emailButton setTitle:@"点此用手机注册" forState:UIControlStateNormal];
                NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:@"请输入您的邮箱"];
                [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 7)];
                _userTextField.attributedPlaceholder = str;
            }else{
                type = 0;
                [_emailButton setTitle:@"点此用邮箱注册" forState:UIControlStateNormal];
                NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:@"请输入您的手机号"];
                [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 8)];
                _userTextField.attributedPlaceholder = str;
            }
            
        }];
    }
    return _emailButton;
}

- (UIButton *)getValidButton
{
    if (!_getValidButton)
    {
        _getValidButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_getValidButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_getValidButton setTitleColor:kCommonWhiteColor forState:UIControlStateNormal];
        _getValidButton.backgroundColor = kCommonBlueColor;
        _getValidButton.layer.cornerRadius = 5;
        _getValidButton.layer.masksToBounds = YES;
        _getValidButton.titleLabel.font = kFont(kStandardPx(26));
        @weakify(self)
        [[_getValidButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self)
            if ([self isValidateEmail:self.userTextField.text])
            {
                [self.getValidButton setBackgroundImage:[UIImage imageWithColor:kCommonLightGrayColor] forState:UIControlStateNormal];
                [self.viewModel.validCommand execute:@{@"emailAddress" : self.userTextField.text}];
            } else if (self.userTextField.text.length == 11) {
                [self.getValidButton setBackgroundImage:[UIImage imageWithColor:kCommonLightGrayColor] forState:UIControlStateNormal];
                [self.viewModel.validCommand execute:@{@"phoneNumber" : self.userTextField.text}];
            } else {
                [ULProgressHUD showWithMsg:@"请输入正确的手机号或邮箱" inView:self];
            }
        }];
    }
    return _getValidButton;
}

-(BOOL)isValidateEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

- (UIButton *)eyeButton
{
    if (!_eyeButton)
    {
        _eyeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_eyeButton setImage:[UIImage imageNamed:@"register_eye"] forState:UIControlStateNormal];
        [_eyeButton setImage:[UIImage imageNamed:@"register_eye_s"] forState:UIControlStateSelected];
        [_eyeButton setTitleColor:kCommonGrayColor forState:UIControlStateNormal];
        _eyeButton.titleLabel.font = kFont(kStandardPx(26));
        @weakify(self)
        [[_eyeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self)
            self.eyeButton.selected = !self.eyeButton.isSelected;
            if (self.eyeButton.selected)
            {
                self.pwdTextField.secureTextEntry = NO;
            } else {
                self.pwdTextField.secureTextEntry = YES;
            }
        }];
    }
    return _eyeButton;
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

- (UIImageView *)validImageView
{
    if (!_validImageView)
    {
        _validImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"register_valid"]];
    }
    return _validImageView;
}


- (UITextField *)userTextField
{
    if (!_userTextField)
    {
        _userTextField = [[UITextField alloc] init];
        _userTextField.delegate = self;
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:@"请输入您的手机号"];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 8)];
        _userTextField.attributedPlaceholder = str;
        //        _userTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"private_user_phone"];
        _userTextField.font = kFont(kStandardPx(30));
        _userTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [_userTextField addSubview:_userLine];
        _userTextField.text = self.phoneNumber;
    }
    return _userTextField;
}
- (UIButton *)reEyeButton
{
    if (!_reEyeButton)
    {
        _reEyeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_reEyeButton setImage:[UIImage imageNamed:@"register_eye"] forState:UIControlStateNormal];
        [_reEyeButton setImage:[UIImage imageNamed:@"register_eye_s"] forState:UIControlStateSelected];
        [_reEyeButton setTitleColor:kCommonGrayColor forState:UIControlStateNormal];
        _reEyeButton.titleLabel.font = kFont(kStandardPx(26));
        @weakify(self)
        [[_reEyeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self)
            self.reEyeButton.selected = !self.reEyeButton.isSelected;
            if (self.reEyeButton.selected)
            {
                self.reTextField.secureTextEntry = NO;
            } else {
                self.reTextField.secureTextEntry = YES;
            }
        }];
    }
    return _reEyeButton;
}

- (UIImageView *)reImageView
{
    if (!_reImageView)
    {
        _reImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_password"]];
    }
    return _reImageView;
}


- (UITextField *)pwdTextField
{
    if (!_pwdTextField)
    {
        _pwdTextField = [[UITextField alloc] init];
        _pwdTextField.delegate = self;
        _pwdTextField.placeholder = @"设置新密码（6到20位字符）";
        _pwdTextField.font = kFont(kStandardPx(30));
        _pwdTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _pwdTextField.secureTextEntry = YES;
    }
    return _pwdTextField;
}

- (UITextField *)validTextField
{
    if (!_validTextField)
    {
        _validTextField = [[UITextField alloc] init];
        _validTextField.delegate = self;
        _validTextField.placeholder = @"请输入验证码";
        _validTextField.font = kFont(kStandardPx(30));
        _validTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _validTextField;
}

- (UITextField *)reTextField
{
    if (!_reTextField)
    {
        _reTextField = [[UITextField alloc] init];
        _reTextField.delegate = self;
        _reTextField.placeholder = @"重复新密码";
        _reTextField.font = kFont(kStandardPx(30));
        _reTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _reTextField.secureTextEntry = YES;
        _reTextField.backgroundColor = kCommonWhiteColor;
    }
    return _reTextField;
}

- (UIImageView *)bottomView
{
    if (!_bottomView)
    {
        _bottomView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"register_bottom"]];
    }
    return _bottomView;
}
#pragma mark - 收起键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.pwdTextField resignFirstResponder];
    [self.validTextField resignFirstResponder];
    [self.userTextField resignFirstResponder];
    [self.reTextField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.pwdTextField resignFirstResponder];
    [self.validTextField resignFirstResponder];
    [self.userTextField resignFirstResponder];
    [self.reTextField resignFirstResponder];
}
@end


