//
//  ULUserChangePhoneViewController.m
//  ULab
//
//  Created by 周维康 on 2017/6/18.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULUserChangePhoneViewController.h"
#import "ULRegisterViewModel.h"

@interface ULUserChangePhoneViewController ()
@property (nonatomic, strong) NSNumber *type;  /**< <#comment#> */
@property (nonatomic, strong) UITextField *userTextField;  /**< <#comment#> */
@property (nonatomic, strong) UIImageView *userImageView;  /**< <#comment#> */
@property (nonatomic, strong) UIButton *getValidButton;  /**< <#comment#> */
@property (nonatomic, strong) UITextField *validTextField;  /**< <#comment#> */
@property (nonatomic, strong) UIImageView *validImageView;  /**< <#comment#> */
@property (nonatomic, strong) ULRegisterViewModel *viewModel;  /**< vm */
@property (nonatomic, strong) UIView *whiteView;  /**< <#comment#> */
@property (nonatomic, strong) UIButton *finishButton;  /**< <#comment#> */
@end

@implementation ULUserChangePhoneViewController

- (instancetype)initWithType:(NSNumber *)type
{
    self.type = type;
    self = [super init];
    return self;
}

- (void)ul_layoutNavigation
{
    if ([self.type  isEqual: @0])
    {
        self.title = @"修改手机号码";
    } else {
        self.title = @"修改邮箱";
    }
}

- (void)ul_addSubviews
{
    self.whiteView = [[UIView alloc] init];
    self.viewModel = [[ULRegisterViewModel alloc] init];
    self.whiteView.backgroundColor = kCommonWhiteColor;
    self.view.backgroundColor = kBackgroundColor;
    [self.view addSubview:self.whiteView];
    [self.view addSubview:self.userTextField];
    [self.view addSubview:self.getValidButton];
    [self.view addSubview:self.userImageView];
    [self.view addSubview:self.validImageView];
    [self.view addSubview:self.validTextField];
    [self.view addSubview:self.finishButton];
    [self.view updateConstraintsIfNeeded];
    [self.view setNeedsUpdateConstraints];
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = kBackgroundColor;
    [self.whiteView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.whiteView);
        make.bottom.equalTo(self.whiteView.mas_top).offset(45);
        make.height.mas_equalTo(0.5);
    }];
}

- (void)ul_bindViewModel
{
    [self.viewModel.validSubject subscribeNext:^(id x) {
        [ULProgressHUD showWithMsg:@"发送成功"];
        [[NSUserDefaults standardUserDefaults] setObject:x[@"data"][@"key"] forKey:@"user_key"];
    }];
    [self.viewModel.verifyContactSubject subscribeNext:^(id x) {
        NSLog(@"%@",x);
        NSLog(@"%@",x[@"success"]);
        if ([x[@"success"] integerValue] != 0) {
            if (self.userTextField.text.length == 11) {
                [ULUserMgr sharedMgr].userPhone = self.userTextField.text;
            }else{
                [ULUserMgr sharedMgr].userEmail = self.userTextField.text;
            }
            [ULUserMgr saveMgr];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshUserDetailView" object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [ULProgressHUD showWithMsg:@"验证码错误"];
        }
    }];
}
- (void)updateViewConstraints
{
    [self.whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(64);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(90);
    }];
    [self.userImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(25);
        make.top.equalTo(_whiteView).offset(11.5);
        make.size.mas_equalTo(CGSizeMake(15, 22));
    }];
    [self.getValidButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-25);
        make.centerY.equalTo(self.userTextField);
        make.size.mas_equalTo(CGSizeMake(90, 32));
    }];
    [self.userTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userImageView.mas_right).offset(18);
        make.centerY.equalTo(self.userImageView);
        make.right.equalTo(self.getValidButton.mas_left).with.offset(-24);
    }];
    [self.validImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userImageView.mas_bottom).offset(23);
        make.centerX.equalTo(self.userImageView);
        make.size.mas_equalTo(CGSizeMake(15, 22));
    }];
    [self.validTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userTextField);
        make.right.equalTo(self.view).with.offset(-50);
        make.centerY.equalTo(self.validImageView);
    }];
    [self.finishButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.top.equalTo(self.whiteView.mas_bottom).offset(45);
        make.height.mas_equalTo(44);
    }];
    [super updateViewConstraints];
}

- (UIButton *)finishButton
{
    if (!_finishButton)
    {
        _finishButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_finishButton setTitle:@"完成" forState:UIControlStateNormal];
        [_finishButton setTitleColor:kCommonWhiteColor forState:UIControlStateNormal];
        _finishButton.backgroundColor = kCommonBlueColor;
        _finishButton.layer.cornerRadius = 5;
        _finishButton.layer.masksToBounds = YES;
        @weakify(self)
        [[_finishButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self)
            if (self.userTextField.text.length < 6)
            {
                [ULProgressHUD showWithMsg:@"请输入正确的手机号或邮箱" inView:self.view];
            } else if ([self.validTextField.text isEqualToString:@""]) {
                [ULProgressHUD showWithMsg:@"请输入验证码" inView:self.view];
            } else {
                NSString *code = self.validTextField.text;
                [ULProgressHUD showWithMsg:@"修改中" inView:self.view whileExecutingBlock:^{
                    [self.viewModel.verifyContactCommand execute:@{
                                                                   @"contact":self.userTextField.text,
                                                                   @"verificationCode" : code,
                                                                   @"key" : [[NSUserDefaults standardUserDefaults] objectForKey:@"user_key"],
                                                                   }];}];
            }
            
        }];
    }
    return _finishButton;
}

- (UIImageView *)userImageView
{
    if (!_userImageView)
    {
        _userImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_user"]];
    }
    return _userImageView;
}

- (UITextField *)userTextField
{
    if (!_userTextField)
    {
        _userTextField = [[UITextField alloc] init];
        if ([self.type isEqual:@0]){
            _userTextField.placeholder = @"请输入您的手机号";
            _userTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"private_user_phone"];
        }else{
            _userTextField.placeholder = @"请输入您的邮箱";
            _userTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"private_user_email"];}
        _userTextField.font = kFont(kStandardPx(30));
        _userTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _userTextField;
}

- (UITextField *)validTextField
{
    if (!_validTextField)
    {
        _validTextField = [[UITextField alloc] init];
        _validTextField.placeholder = @"请输入验证码";
        _validTextField.font = kFont(kStandardPx(30));
        _validTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _validTextField;
}

- (UIImageView *)validImageView
{
    if (!_validImageView)
    {
        _validImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"register_valid"]];
    }
    return _validImageView;
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
            if ([self isValidateEmail:self.userTextField.text] && [self.type isEqual:@2])
            {
                [ULProgressHUD showWithMsg:@"验证码获取中" inView:self.view withBlock:^{
                    [self.getValidButton setBackgroundImage:[UIImage imageWithColor:kCommonLightGrayColor] forState:UIControlStateNormal];
                    [self.viewModel.validCommand execute:@{@"emailAddress" : self.userTextField.text}];
                }];
            } else if (self.userTextField.text.length == 11 && [self.type isEqual:@0]) {
                [ULProgressHUD showWithMsg:@"验证码获取中" inView:self.view withBlock:^{
                    [self.getValidButton setBackgroundImage:[UIImage imageWithColor:kCommonLightGrayColor] forState:UIControlStateNormal];
                    [self.viewModel.validCommand execute:@{@"phoneNumber" : self.userTextField.text}];
                }];
            } else {
                if ([self.type isEqual:@0])
                    [ULProgressHUD showWithMsg:@"请输入正确的手机号" inView:self.view];
                else
                    [ULProgressHUD showWithMsg:@"请输入正确的邮箱"];
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
