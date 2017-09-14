//
//  ULHomeViewController.m
//  U-Lab
//
//  Created by 周维康 on 17/5/18.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULHomeViewController.h"
#import "ULHomeMainViewController.h"
#import "ULHomeUserViewController.h"
#import "ULHomeView.h"
#import "ULTabBarController.h"
#import "ULNavigationController.h"
#import "ULUserJobViewController.h"
#import "ULUserDetailViewController.h"
#import "ULUserObjectViewController.h"
#import "ULUserOrderViewController.h"
#import "ULUserLabViewController.h"
#import "ULSettingsViewController.h"
#import "ULUserDetailViewModel.h"
#import "ULLoginViewModel.h"
#import "ULLabViewModel.h"

@interface ULHomeViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) ULHomeUserViewController *userVC;  /**< 用户 */
@property (nonatomic, strong) ULTabBarController *tabBarC;  /**< 主界面 */
@property (nonatomic, strong) UIControl *blackView;  /**< 黑色背景板 */
@property (nonatomic, strong) UIScrollView *scrollView;  /**< 华东 */
@property (nonatomic, strong) ULLoginViewModel *loginVM;  /**< VM */
@property (nonatomic, strong) ULLabViewModel *labVM;  /**< VM */

@end

@implementation ULHomeViewController
{
    BOOL _hasShowUserView;
    NSArray *_nextControllerArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)ul_bindViewModel
{
    self.labVM = [[ULLabViewModel alloc] init];
    ULNavigationController *navigationC = self.tabBarC.viewControllers.firstObject;
    ULHomeMainViewController *mainVC = navigationC.viewControllers.firstObject;
    [self.userVC.userView.selectSubject subscribeNext:^(id x) {
        [UIView animateWithDuration:0.1f animations:^{
            self.scrollView.contentOffset = CGPointMake(238, 0);
            self.blackView.alpha = 0.0;
            [self.userVC.view.superview layoutIfNeeded];
            [self.userVC.view.superview updateConstraintsIfNeeded];
        }];
        Class vcClass = NSClassFromString(_nextControllerArray[[x integerValue]]);
        UIViewController *vc = [[vcClass alloc] init];
        [mainVC.navigationController pushViewController:vc animated:YES];
    }];
    @weakify(self)
    [mainVC.appearSubject subscribeNext:^(id x) {
        @strongify(self)
        self.scrollView.scrollEnabled = YES;
    }];
    [mainVC.disappearSubject subscribeNext:^(id x) {
        @strongify(self)
        self.scrollView.scrollEnabled = NO;
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
//    //2.上传文件
//    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"80-80.png", @"userHeader", nil];
//    [manager POST:@"http://www.wordd.space/ulab_user/usr/test" parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//        
//        //上传文件参数
//        NSData *data = UIImagePNGRepresentation([UIImage imageNamed:@"80-80.png"]);
//        [formData appendPartWithFileData:data name:@"userHeader" fileName:@"80-80.png" mimeType:@"image/jpeg"];
//        NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//        NSLog(@"%@", [data base64EncodedStringWithOptions:0]);
//    } progress:^(NSProgress * _Nonnull uploadProgress) {
//        
//        //打印上传进度
//        CGFloat progress = 100.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount;
//        NSLog(@"%.2lf%%", progress);
//        
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        
//        //请求成功
//        NSLog(@"请求成功：%@",responseObject);
//        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        
//        //请求失败
//        NSLog(@"请求失败：%@",error);
//        
//    }];
    [self.loginVM.loginCommand execute:@{
                                         @"userName" :[[NSUserDefaults standardUserDefaults] objectForKey:@"private_user_account"],
                                         @"password" : [[NSUserDefaults standardUserDefaults] objectForKey:@"user_password"]
                                         }];
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1200 repeats:YES block:^(NSTimer * _Nonnull timer) {
        [self.loginVM.loginCommand execute:@{
                                             @"userName" : [[NSUserDefaults standardUserDefaults] objectForKey:@"private_user_account"],
                                             @"password" : [[NSUserDefaults standardUserDefaults] objectForKey:@"user_password"]
                                             }];

    }];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    [self.labVM.labCommand execute:nil];
    [self.userVC.userView updateUserView];
    if (![ULUserMgr sharedMgr].laboratoryId) {
        [ULProgressHUD showWithMsg:@"请先加入实验室"];
    }
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    ULNavigationController *navigationC = self.tabBarC.viewControllers.firstObject;
    ULHomeMainViewController *mainVC = navigationC.viewControllers.firstObject;
    [mainVC.actionSubject subscribeNext:^(id x) {

        if (_hasShowUserView)
        {
            [UIView animateWithDuration:0.2f animations:^{
                self.scrollView.contentOffset = CGPointMake(238, 0);
                self.blackView.alpha = 0.0;
                [self.userVC.view.superview layoutIfNeeded];
                [self.userVC.view.superview updateConstraintsIfNeeded];
            }];
        } else {
            [UIView animateWithDuration:0.2f animations:^{
                self.scrollView.contentOffset = CGPointMake(0, 0);
                self.blackView.alpha = 0.5;
                [self.userVC.view.superview layoutIfNeeded];
                [self.userVC.view.superview updateConstraintsIfNeeded];
            }];

        }
    }];
    [super viewDidAppear:animated];
}

- (void)updateViewConstraints
{
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.userVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.equalTo(self.view);
        make.left.equalTo(_scrollView);
        make.width.mas_equalTo(238);
    }];
    [self.tabBarC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userVC.view.mas_right);
        make.top.and.bottom.equalTo(self.view);
        make.width.mas_equalTo(screenWidth);
    }];
    [self.blackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.tabBarC.view);
    }];
    [super updateViewConstraints];
}
- (void)ul_addSubviews
{
    _hasShowUserView = NO;
    _nextControllerArray = @[NSStringFromClass([ULUserDetailViewController class]), NSStringFromClass([ULUserObjectViewController class]), NSStringFromClass([ULUserOrderViewController class]), NSStringFromClass([ULUserLabViewController class]), NSStringFromClass([ULUserJobViewController class]), NSStringFromClass([ULSettingsViewController class])];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.tabBarC.view];
    [self.scrollView addSubview:self.userVC.view];
    [self.scrollView addSubview:self.blackView];
    [self.view updateConstraintsIfNeeded];
    [self.view setNeedsUpdateConstraints];
}

- (void)ul_layoutNavigation
{
}

- (UIScrollView *)scrollView
{
    if (!_scrollView)
    {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.pagingEnabled = YES;
        _scrollView.contentSize = CGSizeMake(screenWidth+238, screenHeight);
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.contentOffset = CGPointMake(238, 0);
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.bounces = NO;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (ULLoginViewModel *)loginVM
{
    if (!_loginVM)
    {
        _loginVM = [[ULLoginViewModel alloc] init];
    }
    return _loginVM;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.blackView.alpha = (1-scrollView.contentOffset.x/238)*0.5;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _hasShowUserView = !_hasShowUserView;
}
- (ULHomeUserViewController *)userVC
{
    if (!_userVC)
    {
        _userVC = [[ULHomeUserViewController alloc] init];
    }
    return _userVC;
}

- (ULTabBarController *)tabBarC
{
    if (!_tabBarC)
    {
        _tabBarC = [[ULTabBarController alloc] init];
    }
    return _tabBarC;
}

- (UIControl *)blackView
{
    if (!_blackView)
    {
        _blackView = [[UIControl alloc] init];
        _blackView.alpha = 0.0;
        [[_blackView rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @weakify(self)
            
            [UIView animateWithDuration:0.2f animations:^{
                @strongify(self)
                self.scrollView.contentOffset = CGPointMake(238, 0);
                self.blackView.alpha = 0.0;
                [self.userVC.view.superview layoutIfNeeded];
            }];
        }];
        _blackView.backgroundColor = [UIColor blackColor];
    }
    return _blackView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
