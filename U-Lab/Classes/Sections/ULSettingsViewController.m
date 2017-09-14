//
//  ULSettingsViewController.m
//  U-Lab
//
//  Created by 周维康 on 17/5/24.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULSettingsViewController.h"
#import "ULAboutViewController.h"
#import "ULFeedbackViewController.h"
#import "ULUserManagerViewController.h"
#import "ULHelpViewController.h"
#import "ULSettingView.h"
@interface ULSettingsViewController ()

@property (nonatomic, strong) ULSettingView *setView;  /**< 设置页面 */
@end

@implementation ULSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)ul_addSubviews
{
    [self.view addSubview:self.setView];
    [self.view updateConstraintsIfNeeded];
    [self.view setNeedsUpdateConstraints];
}

- (void)ul_layoutNavigation
{
    self.title = @"设置";
}

- (void)ul_bindViewModel
{
    [self.setView.aboutSubject subscribeNext:^(id x) {
        if ([x  isEqual: @2])
        {
            ULHelpViewController *aboutVC = [[ULHelpViewController alloc] init];
            [self.navigationController pushViewController:aboutVC animated:YES];
        } else if ([x isEqual:@1]) {
            ULUserManagerViewController *userVC = [[ULUserManagerViewController alloc] init];
            [self.navigationController pushViewController:userVC animated:YES];
        }
    }];
}
- (void)updateViewConstraints
{
    [self.setView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [super updateViewConstraints];
}
- (ULSettingView *)setView
{
    if (!_setView)
    {
        _setView = [[ULSettingView alloc] init];
    }
    return _setView;
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
