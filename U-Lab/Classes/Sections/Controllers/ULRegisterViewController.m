//
//  ULRegisterViewController.m
//  U-Lab
//
//  Created by 周维康 on 17/5/18.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULRegisterViewController.h"
#import "ULRegisterView.h"
#import "ULHomeViewController.h"
#import "ULUserDetailImproveViewController.h"
#import "ULLoginViewModel.h"
#import "JPUSHService.h"

@interface ULRegisterViewController ()

@property (nonatomic, strong) ULRegisterView *mainView;  /**< 视图 */
@property (nonatomic, strong) ULRegisterViewModel *viewModel;  /**< VM */
@property (nonatomic, strong) ULLoginViewModel *loginVM;  /**< <#comment#> */

@end

@implementation ULRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)ul_addSubviews
{
    self.loginVM = [[ULLoginViewModel alloc] init];
    [self.view addSubview:self.mainView];
    [self.view setNeedsUpdateConstraints];
    [self.view updateConstraintsIfNeeded];
}

- (void)updateViewConstraints
{
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [super updateViewConstraints];
}

- (void)ul_layoutNavigation
{
    self.title = @"注册";
    self.navigationController.navigationBar.hidden = NO;
}

- (void)ul_bindViewModel
{
    self.viewModel = self.mainView.viewModel;
    [self.viewModel.registerSubject subscribeNext:^(id x) {
        if ([x[@"errCode"] integerValue] == 0)
        {
            @weakify(self)
            
            [JMSGUser registerWithUsername:[[NSUserDefaults standardUserDefaults] objectForKey:@"private_user_account"]
                                  password:[[NSUserDefaults standardUserDefaults] objectForKey:@"user_password"]
                         completionHandler:^(id resultObject, NSError *error) {
                             if (!error) {
                                 @strongify(self)
                                 [ULProgressHUD hide];
                                 [ULProgressHUD showWithMsg:@"注册成功" inView:self.view];
                                 [self.loginVM.loginCommand execute:@{
                                                                      @"userName":[[NSUserDefaults standardUserDefaults] objectForKey:@"private_user_account"],//用户名
                                                                      @"password":[[NSUserDefaults standardUserDefaults] objectForKey:@"user_password"] //密码
                                                                      }];
                                 
                             } else {
                                 [ULProgressHUD showWithMsg:@"请求失败" inView:self.view];
                                 [[ULUserMgr sharedMgr] removeMgr];
                             }
                         }];
            
        } else if ([x[@"errCode"]  isEqual: @50006]) {
            [ULProgressHUD showWithMsg:@"用户已存在" inView:self.view];
        } else if ([x[@"errCode"]  isEqual: @50004]) {
            [ULProgressHUD showWithMsg:@"验证码错误" inView:self.view];
        } else {
            [ULProgressHUD showWithMsg:x[@"message"] inView:self.view];
        }
    }];
    [self.loginVM.successSubject subscribeNext:^(id x) {
        if ([x[@"errCode"]  isEqual: @0])
        {
            [JPUSHService setAlias:[[NSUserDefaults standardUserDefaults] objectForKey:@"private_user_account"] completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
                if (iResCode != 0) {
                    NSLog(@"JPush注册失败");
                }
            } seq:0];
            @weakify(self)
            [JMSGUser loginWithUsername:[[NSUserDefaults standardUserDefaults] objectForKey:@"private_user_account"] password:[[NSUserDefaults standardUserDefaults] objectForKey:@"user_password"] completionHandler:^(id resultObject, NSError *error) {
                if ([ULUserMgr sharedMgr].userPhone)
                    [[NSUserDefaults standardUserDefaults] setObject:[ULUserMgr sharedMgr].userPhone forKey:@"private_user_phone"];
                if ([ULUserMgr sharedMgr].userEmail){
                    [[NSUserDefaults standardUserDefaults] setObject:[ULUserMgr sharedMgr].userEmail forKey:@"private_user_Email"];
                }
                if (!error) {
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        [JMSGUser updateMyInfoWithParameter:[NSString stringWithFormat:@"%@",[ULUserMgr sharedMgr].userId] userFieldType:kJMSGUserFieldsRegion completionHandler:^(id resultObject, NSError *error) {
                            if (error) {
                                NSLog(@"%@",error);
                            }
                        }];
                    });
                    @strongify(self)
                    ULUserDetailImproveViewController *improveVC = [[ULUserDetailImproveViewController alloc] init];
                    [self.navigationController pushViewController:improveVC animated:YES];
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
    
}
- (ULRegisterView *)mainView
{
    if (!_mainView)
    {
        _mainView = [[ULRegisterView alloc] init];
    }
    return _mainView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
