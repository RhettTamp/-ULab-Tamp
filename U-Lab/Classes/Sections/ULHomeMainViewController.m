//
//  ULHomeMainViewController.m
//  U-Lab
//
//  Created by 周维康 on 17/5/21.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULHomeMainViewController.h"
#import "ULMainShareViewController.h"
#import "ULMainApplyBuyViewController.h"
#import "ULHomeView.h"
#import "ULMainSearchViewController.h"
#import <SDWebImage/UIButton+WebCache.h>

@interface ULHomeMainViewController ()

@property (nonatomic, strong) ULHomeView *mainView;  /**< 主视图 */

@end

@implementation ULHomeMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (instancetype)init
{
    self.appearSubject = [RACSubject subject];
    self.disappearSubject = [RACSubject subject];
    if (self = [super init])
    {
        
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.appearSubject sendNext:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.disappearSubject sendNext:nil];
}

- (void)updateViewConstraints
{
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.width.mas_equalTo([UIApplication sharedApplication].keyWindow.frame.size.width);
        make.top.and.bottom.equalTo(self.view);
    }];
    [super updateViewConstraints];
}
- (void)ul_addSubviews
{
    [self.view addSubview:self.mainView];
    [self.view updateConstraintsIfNeeded];
    [self.view setNeedsUpdateConstraints];
}

- (void)ul_bindViewModel
{
    @weakify(self)
    self.actionSubject = [RACSubject subject];
    [self.mainView.shareSubject subscribeNext:^(id x) {
        @strongify(self)
        ULMainShareViewController *shareVC = [[ULMainShareViewController alloc] initWithShareType:[x integerValue]+1];
        [self.navigationController pushViewController:shareVC animated:YES];
    }];
    [self.mainView.applyBuySubject subscribeNext:^(id x) {
        @strongify(self)
        ULMainApplyBuyViewController *applyVC = [[ULMainApplyBuyViewController alloc] init];
        [self.navigationController pushViewController:applyVC animated:YES];
    }];
    [self.mainView.searchSubject subscribeNext:^(id x) {
        @strongify(self)
        ULMainSearchViewController *searchVC = [[ULMainSearchViewController alloc]  initWithObjectDic:x];
        [self.navigationController pushViewController:searchVC animated:YES];
    }];
}
- (void)ul_layoutNavigation
{
    self.title = @"U-Labor";
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"ulab_user_default"] forState:UIControlStateNormal];
    if ([ULUserMgr sharedMgr].avaterImageUrl&&[ULUserMgr sharedMgr].avaterImage) {
        [button setBackgroundImage:[ULUserMgr sharedMgr].avaterImage forState:UIControlStateNormal];
    }else if ([ULUserMgr sharedMgr].avaterImageUrl){
        [button sd_setImageWithURL:[NSURL URLWithString:[ULUserMgr sharedMgr].avaterImageUrl] forState:UIControlStateNormal];
    }else if ([ULUserMgr sharedMgr].avaterImage){
        [button setBackgroundImage:[ULUserMgr sharedMgr].avaterImage forState:UIControlStateNormal];
    }
    button.frame = CGRectMake(0, 0, 30, 30);
    button.layer.cornerRadius = 15;
    button.layer.masksToBounds = YES;
    @weakify(self);
    [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        [self.actionSubject sendNext:nil];
        [[UIApplication sharedApplication].keyWindow endEditing:YES];
    }];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = leftItem;
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:kUserAvatorImageDidChange object:nil] subscribeNext:^(id x) {
        NSLog(@"%@",[ULUserMgr sharedMgr].avaterImage);
//        [button setBackgroundImage:[ULUserMgr sharedMgr].avaterImage forState:UIControlStateNormal];
        if ([ULUserMgr sharedMgr].avaterImageUrl&&[ULUserMgr sharedMgr].avaterImage) {
            [button setBackgroundImage:[ULUserMgr sharedMgr].avaterImage forState:UIControlStateNormal];
        }else if ([ULUserMgr sharedMgr].avaterImageUrl){
            [button sd_setImageWithURL:[NSURL URLWithString:[ULUserMgr sharedMgr].avaterImageUrl] forState:UIControlStateNormal];
        }else if ([ULUserMgr sharedMgr].avaterImage){
            [button setBackgroundImage:[ULUserMgr sharedMgr].avaterImage forState:UIControlStateNormal];
        }
    }];
}
- (ULHomeView *)mainView
{
    if (!_mainView)
    {
        _mainView = [[ULHomeView alloc] init];
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
