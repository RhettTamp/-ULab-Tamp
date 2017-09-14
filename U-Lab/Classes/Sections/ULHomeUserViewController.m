//
//  ULHomeUserViewController.m
//  U-Lab
//
//  Created by 周维康 on 17/5/21.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULHomeUserViewController.h"


@interface ULHomeUserViewController ()


@end

@implementation ULHomeUserViewController
{
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)updateViewConstraints
{
    [self.userView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [super updateViewConstraints];
}
- (void)ul_addSubviews
{
    [self.view addSubview:self.userView];
    [self.view updateConstraintsIfNeeded];
    [self.view setNeedsUpdateConstraints];
}

- (void)ul_bindViewModel
{

}
- (void)ul_layoutNavigation
{

}


- (ULHomeUserView *)userView
{
    if (!_userView)
    {
        _userView = [[ULHomeUserView alloc] init];
        _userView.backgroundColor = kCommonWhiteColor;
    }
    return _userView;
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
