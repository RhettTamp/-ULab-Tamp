//
//  ULLabFriendViewController.m
//  U-Lab
//
//  Created by 周维康 on 2017/6/8.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULLabFriendViewController.h"
#import "ULLabDetailViewController.h"
#import "ULLabFriendView.h"
#import "ULLabViewController.h"

@interface ULLabFriendViewController ()

@property (nonatomic, strong) ULLabFriendView *friendView;  /**< 友好实验室 */
@end

@implementation ULLabFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)ul_layoutNavigation
{
    self.title = @"友好实验室";
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addButton.frame = CGRectMake(0, 0, 17, 17);
    [addButton setBackgroundImage:[UIImage imageNamed:@"home_user_add"] forState:UIControlStateNormal];
    @weakify(self)
    [[addButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        [[UIApplication sharedApplication].keyWindow endEditing:YES];
        ULLabViewController *vc = [[ULLabViewController alloc] init];
        vc.type = 1;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:addButton];
    
    self.navigationItem.rightBarButtonItem = buttonItem;
}

- (void)ul_addSubviews
{
    [self.view addSubview:self.friendView];
    [self.view updateConstraintsIfNeeded];
    [self.view setNeedsUpdateConstraints];
}

- (void)viewWillAppear:(BOOL)animated{
    [self.friendView updataViews];
    [super viewWillAppear:animated];
}

- (void)ul_bindViewModel
{
    @weakify(self)
    [_friendView.nextSubject subscribeNext:^(id x) {
        @strongify(self)
        ULLabDetailViewController *detailVC = [[ULLabDetailViewController alloc] initWithStatus:[x[@"isAgree"] integerValue] labModel:x[@"model"]];
        [self.navigationController pushViewController:detailVC animated:YES];
    }];
}
- (void)updateViewConstraints
{
    [self.friendView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [super updateViewConstraints];
}
- (ULLabFriendView *)friendView
{
    if (!_friendView)
    {
        _friendView = [[ULLabFriendView alloc] init];
        
    }
    return _friendView;
}


@end
