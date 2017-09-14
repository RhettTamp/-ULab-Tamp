//
//  ULUserJobViewController.m
//  U-Lab
//
//  Created by 周维康 on 17/5/29.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULUserJobViewController.h"
#import "ULUserJobCreatViewController.h"
#import "ULUserOtherJobViewController.h"
#import "ULUserJobView.h"
#import "ULUserJobChangeViewController.h"

@interface ULUserJobViewController ()

@property (nonatomic, strong) ULUserJobView *jobView;  /**< 工作视图 */

@end

@implementation ULUserJobViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.jobView.updateViewSubject sendNext:nil];
}

- (void)ul_bindViewModel
{
    [self.jobView.nextSubject subscribeNext:^(id x) {
        if (x){
            ULUserJobChangeViewController *vc = [[ULUserJobChangeViewController alloc] initWithJob:x andType:1];
            [self.navigationController pushViewController:vc animated:YES];
        } else {
        ULUserOtherJobViewController *jobVC = [[ULUserOtherJobViewController alloc] init];
        [self.navigationController pushViewController:jobVC animated:YES];
        }
    }];
}
- (void)ul_layoutNavigation
{
    self.title = @"今日工作";
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addButton.frame = CGRectMake(0, 0, 18, 17);
    @weakify(self)
    [[addButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        ULUserJobCreatViewController *creatVC = [[ULUserJobCreatViewController alloc] init];
        [self.navigationController pushViewController:creatVC animated:YES];
    }];
    [addButton setBackgroundImage:[UIImage imageNamed:@"home_user_add"] forState:UIControlStateNormal];
    //    [addButton setTitle:@"新建" forState:UIControlStateNormal];
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:addButton];
    self.navigationItem.rightBarButtonItem = buttonItem;
}

- (void)ul_addSubviews
{
    [self.view addSubview:self.jobView];
    [self.view updateConstraintsIfNeeded];
    [self.view setNeedsUpdateConstraints];
}
- (void)updateViewConstraints
{
    [super updateViewConstraints];
    [self.jobView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (ULUserJobView *)jobView
{
    if (!_jobView)
    {
        _jobView = [[ULUserJobView alloc] init];
    }
    return _jobView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
