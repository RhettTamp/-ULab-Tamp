//
//  ULForgetViewController.m
//  U-Lab
//
//  Created by 周维康 on 17/5/18.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULForgetViewController.h"
#import "ULForgetView.h"

@interface ULForgetViewController ()

@property (nonatomic, strong) ULForgetView *forgetView;  /**< 主界面 */
@property (nonatomic, strong) ULForgetViewModel *viewModel;  /**< VM */
@property (nonatomic, copy) NSString *phoneNumber;  /**< 手机号码 */
@end

@implementation ULForgetViewController
{
    BOOL _isLogin;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (instancetype)init
{
    return [self initWithPhone:nil];
}
- (instancetype)initWithPhone:(NSString *)phoneNumber
{
    self.phoneNumber = phoneNumber;
    _isLogin = NO;
    if (self = [super init])
    {
        
    }
    return self;
}

- (instancetype)initWithPhone:(NSString *)phoneNumber isLogin:(BOOL)isLogin
{
    _isLogin = isLogin;
    self.phoneNumber = phoneNumber;
    self = [super init];
    return self;
}
- (void)ul_layoutNavigation
{
    self.title = @"修改密码";
    self.navigationController.navigationBar.hidden = NO;
}

- (void)ul_addSubviews
{
    [self.view addSubview:self.forgetView];
    [self.view updateConstraintsIfNeeded];
    [self.view setNeedsUpdateConstraints];
}

- (void)ul_bindViewModel
{
    self.viewModel = self.forgetView.viewModel;
    if (_isLogin)
        [self.viewModel.changeSubject subscribeNext:^(id x) {
            if ([x[@"errCode"] integerValue] == 0)
            {
                [JMSGUser loginWithUsername:[[NSUserDefaults standardUserDefaults] objectForKey:@"private_user_account"]  password:[[NSUserDefaults standardUserDefaults] objectForKey:@"user_password"] completionHandler:^(id resultObject, NSError *error) {
                    if (!error)
                    {
                        [ULProgressHUD hide];
                        [ULProgressHUD showWithMsg:@"修改成功" inView:self.view];
                        [self.navigationController popViewControllerAnimated:YES];
                        
                    } else {
                        [ULProgressHUD hide];
                        [ULProgressHUD showWithMsg:@"请求失败"];
                    }
                }];
                
            } else if ([x[@"errCode"]  isEqual: @50004]) {
                [ULProgressHUD hide];
                [ULProgressHUD showWithMsg:@"验证码错误" inView:self.view];
            } else {
                [ULProgressHUD hide];
                [ULProgressHUD showWithMsg:x[@"message"] inView:self.view];
            }
        }];
    else
        [self.viewModel.forgetSubject subscribeNext:^(id x) {
            if ([x[@"errCode"]  isEqual: @0])
            {
                [ULProgressHUD hide];
                [ULProgressHUD showWithMsg:@"修改成功"];
                [self.navigationController popViewControllerAnimated:YES];
            } else if ([x[@"errCode"]  isEqual: @50004]) {
                [ULProgressHUD hide];
                [ULProgressHUD showWithMsg:@"验证码错误" inView:self.view];
            } else {
                [ULProgressHUD hide];
                [ULProgressHUD showWithMsg:x[@"message"] inView:self.view];
            }
        }];
    
}

- (void)updateViewConstraints
{
    [self.forgetView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [super updateViewConstraints];
}

- (ULForgetView *)forgetView
{
    if (!_forgetView)
    {
        _forgetView = [[ULForgetView alloc] initWithPhone:self.phoneNumber isLogin:_isLogin];
    }
    return _forgetView;
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
