//
//  ULUserManagerViewController.m
//  ULab
//
//  Created by 周维康 on 2017/6/21.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULUserManagerViewController.h"
#import "ULNavigationController.h"
#import "ULLoginViewController.h"
#import "ULForgetViewController.h"
#import "ZWKAlertView.h"
@interface ULUserManagerViewController ()<ZWKAlertViewDelegate>

@property (nonatomic, strong) UIButton *logoutButton;  /**< <#comment#> */
@property (nonatomic, strong) UIButton *reButton;  /**< <#comment#> */
@property (nonatomic, strong) UIImageView *bottomView;  /**< 底部花篮 */
@property (nonatomic, strong) ZWKAlertView *alertView;  /**< <#comment#> */
@end

@implementation ULUserManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}


- (void)ul_addSubviews
{
    self.alertView = [[ZWKAlertView alloc] initWithFuncArray:@[@"退出登录"]];
    self.alertView.delegate = self;
    self.view.backgroundColor = kBackgroundColor;
    [self.view addSubview:self.logoutButton];
    [self.view addSubview:self.reButton];
    [self.view addSubview:self.bottomView];
    [self.view updateConstraintsIfNeeded];
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    [self.logoutButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(64+14);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(45);
    }];
    [self.reButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.logoutButton.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(45);
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(33);
    }];
    [super updateViewConstraints];
}

- (UIImageView *)bottomView
{
    if (!_bottomView)
    {
        _bottomView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"register_bottom"]];
    }
    return _bottomView;
}

- (UIButton *)logoutButton
{
    if (!_logoutButton)
    {
        _logoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _logoutButton.backgroundColor = kCommonWhiteColor;
        [[_logoutButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            [self.alertView show];
        }];
        UILabel *label = [[UILabel alloc] init];
        label.text = @"退出登录";
        label.font = kFont(kStandardPx(30));
        label.textColor = KTextGrayColor;
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_user_next"]];
        [_logoutButton addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_logoutButton).offset(-15);
            make.centerY.equalTo(_logoutButton);
            make.size.mas_equalTo(CGSizeMake(10, 15));
        }];
        [_logoutButton addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_logoutButton).offset(15);
            make.centerY.equalTo(_logoutButton);
        }];
    }
    return _logoutButton;
}

- (UIButton *)reButton
{
    if (!_reButton)
    {
        _reButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _reButton.backgroundColor = kCommonWhiteColor;
        [[_reButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            ULForgetViewController  *vc = [[ULForgetViewController alloc] initWithPhone:[ULUserMgr sharedMgr].userPhone isLogin:YES];
            [self.navigationController pushViewController:vc animated:YES];
        }];
        UILabel *label = [[UILabel alloc] init];
        label.text = @"修改密码";
        label.font = kFont(kStandardPx(30));
        label.textColor = KTextGrayColor;
        [_reButton addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_reButton).offset(15);
            make.centerY.equalTo(_reButton);
        }];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_user_next"]];
        [_reButton addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_reButton).offset(-15);
            make.centerY.equalTo(_reButton);
            make.size.mas_equalTo(CGSizeMake(10, 15));
        }];
    }
    return _reButton;

}
- (void)alertView:(ZWKAlertView *)alertView didClickAtIndex:(NSInteger)index
{
    if (index == 0)
    {
        [self.alertView hide];
        @weakify(self)
        [JMSGUser logout:^(id resultObject, NSError *error) {
            if (!error) {
                @strongify(self)
                [[ULUserMgr sharedMgr] removeMgr];
                NSData *archiveUserData = [NSKeyedArchiver archivedDataWithRootObject:[ULUserMgr sharedMgr]];
                [[NSUserDefaults standardUserDefaults] setObject:archiveUserData forKey:@"ulab_user"];
                
                CATransition *animation = [CATransition animation];
                animation.duration = 0.3;
                animation.timingFunction = UIViewAnimationCurveEaseInOut;
                animation.type = kCATransitionReveal;
                animation.subtype = kCATransitionFromBottom;
                [self.view.window.layer addAnimation:animation forKey:nil];
                ULLoginViewController *loginVC = [[ULLoginViewController alloc] init];
                ULNavigationController *navigationC = [[ULNavigationController alloc] initWithRootViewController:loginVC];
                //    self.modalTransitionStyle = UIModalTransitionStylePartialCurl;
                [self presentViewController:navigationC animated:NO completion:nil];
                

            } else {
                [[ULUserMgr sharedMgr] removeMgr];
                NSData *archiveUserData = [NSKeyedArchiver archivedDataWithRootObject:[ULUserMgr sharedMgr]];
                [[NSUserDefaults standardUserDefaults] setObject:archiveUserData forKey:@"ulab_user"];
                
                CATransition *animation = [CATransition animation];
                animation.duration = 0.3;
                animation.timingFunction = UIViewAnimationCurveEaseInOut;
                animation.type = kCATransitionReveal;
                animation.subtype = kCATransitionFromBottom;
                [self.view.window.layer addAnimation:animation forKey:nil];
                ULLoginViewController *loginVC = [[ULLoginViewController alloc] init];
                ULNavigationController *navigationC = [[ULNavigationController alloc] initWithRootViewController:loginVC];
                //    self.modalTransitionStyle = UIModalTransitionStylePartialCurl;
                [self presentViewController:navigationC animated:NO completion:nil];
//                [ULProgressHUD showWithMsg:@"请求失败" inView:self.view];
            }
        }];
    }
}
- (void)ul_layoutNavigation
{
    self.title = @"账号管理";
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
