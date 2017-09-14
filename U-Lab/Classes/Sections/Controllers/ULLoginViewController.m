//
//  ULLoginViewController.m
//  U-Lab
//
//  Created by 周维康 on 17/5/13.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULLoginViewController.h"
#import "ULLoginView.h"
#import "ULLoginViewModel.h"
#import "ULTabBarController.h"
#import "ULRegisterViewController.h"
#import "ULForgetViewController.h"
#import "ULHomeViewController.h"
#import "ULUserDetailImproveViewController.h"
#import "JPUSHService.h"


@interface ULLoginViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) ULLoginView *mainView;  /**< 总视图 */
@property (nonatomic, strong) ULLoginViewModel *loginViewModel;  /**< VM */

@end

@implementation ULLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)updateViewConstraints
{
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [super updateViewConstraints];
}

- (void)ul_addSubviews
{
    [self.view addSubview:self.mainView];
    [self.view setNeedsUpdateConstraints];
    [self.view updateConstraintsIfNeeded];
}

- (void)ul_bindViewModel
{
    self.loginViewModel = _mainView.viewModel;
    [_mainView.viewModel.successSubject subscribeNext:^(id x) {
        if ([x[@"errCode"]  isEqual: @0])
        {
            [JPUSHService setAlias:[[NSUserDefaults standardUserDefaults] objectForKey:@"private_user_account"] completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
                if (iResCode != 0) {
                    NSLog(@"JPush注册失败");
                }
            } seq:0];
            @weakify(self)
            NSString *account;
            if ([ULUserMgr sharedMgr].regType == 0) {
                account = [ULUserMgr sharedMgr].userPhone;
            }else{
                account = [ULUserMgr sharedMgr].userEmail;
            }
            [JMSGUser loginWithUsername:account password:[[NSUserDefaults standardUserDefaults] objectForKey:@"user_password"] completionHandler:^(id resultObject, NSError *error) {
                if ([ULUserMgr sharedMgr].userPhone){
                    [[NSUserDefaults standardUserDefaults] setObject:[ULUserMgr sharedMgr].userPhone forKey:@"private_user_phone"];
                }
                if ([ULUserMgr sharedMgr].userEmail){
                    [[NSUserDefaults standardUserDefaults] setObject:[ULUserMgr sharedMgr].userEmail forKey:@"private_user_userEmail"];
                }if (!error) {
                    @strongify(self)
                    [ULProgressHUD hide];
                    [ULProgressHUD showWithMsg:@"登录成功" inView:self.view];
                    if (![ULUserMgr sharedMgr].userName)
                    {
                        ULUserDetailImproveViewController *improveVC = [[ULUserDetailImproveViewController alloc] init];
                        [self.navigationController pushViewController:improveVC animated:YES];
                    } else {
                        ULHomeViewController *homeVC = [[ULHomeViewController alloc] init];
                        [self presentViewController:homeVC animated:YES completion:nil];
                    }
                } else {
                    [ULProgressHUD hide];
                    [ULProgressHUD showWithMsg:@"请求失败" inView:self.view];
                    [[ULUserMgr sharedMgr] removeMgr];
                }
                
                
            }];
        } else if ([x[@"errCode"]  isEqual: @50005]) {
            [ULProgressHUD hide];
            [ULProgressHUD showWithMsg:@"密码错误或者用户不存在" inView:self.view];
        } else {
            [ULProgressHUD hide];
            [ULProgressHUD showWithMsg:x[@"message"] inView:self.view];
        }
       
    }];
    [_mainView.viewModel.successSubject subscribeError:^(NSError *error) {
        [ULProgressHUD hide];
        [ULProgressHUD showWithMsg:@"请求失败" inView:self.view];
    }];
    
    [_mainView.viewModel.registerSubject subscribeNext:^(id x) {
        ULRegisterViewController *registerVC = [[ULRegisterViewController alloc] init];
        [self.navigationController pushViewController:registerVC animated:YES];
    }];
    [_mainView.viewModel.forgetSubject subscribeNext:^(id x) {
        [ULProgressHUD hide];
        ULForgetViewController *forgetVC = [[ULForgetViewController alloc] init];
        [self.navigationController pushViewController:forgetVC animated:YES];
    }];
}

- (void)ul_layoutNavigation
{
    self.navigationController.navigationBar.hidden = YES;
    self.title = @"登录";
}
#pragma mark - lazyLoad
- (ULLoginView *)mainView
{
    if (!_mainView)
    {
        _mainView = [[ULLoginView alloc] init];
    }
    return _mainView;
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
