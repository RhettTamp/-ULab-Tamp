//
//  ULUserDetailImproveViewController.m
//  U-Lab
//
//  Created by 周维康 on 2017/6/6.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULUserDetailImproveViewController.h"
#import "ULUserDetailImproveView.h"
#import "ULUserDetailViewModel.h"
#import "ULHomeViewController.h"
@interface ULUserDetailImproveViewController ()
@property (nonatomic, strong) ULUserDetailImproveView *improveView;  /**< 完善界面 */
@property (nonatomic, strong) ULUserDetailViewModel *viewModel;  /**< vm */
@end

@implementation ULUserDetailImproveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)ul_layoutNavigation
{
    self.navigationController.navigationBar.hidden = NO;
    self.title = @"完善信息";
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addButton.frame = CGRectMake(0, 0, 40, 17);
    [addButton setTitle:@"保存" forState:UIControlStateNormal];
    
//    addButton.titleLabel.font = kFont(kStandardPx(28));
    @weakify(self)
    [[addButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        if ([self.improveView.userName  isEqual: @""]|| !self.improveView.userName)
        {
            [ULProgressHUD showWithMsg:@"请填写姓名" inView:self.view];
        } else if (!self.improveView.sex) {
            [ULProgressHUD showWithMsg:@"请选择性别" inView:self.view];
        } else if (!self.improveView.role) {
            [ULProgressHUD showWithMsg:@"请选择身份" inView:self.view];
        } else if (([self.improveView.labName  isEqual: @""] || !self.improveView.labName) && ![self.improveView.role isEqual:@0]) {
            [ULProgressHUD showWithMsg:@"请填写实验室名称" inView:self.view];
        } else if (([self.improveView.location  isEqual: @""] || !self.improveView.location) && ![self.improveView.role isEqual:@0]) {
            [ULProgressHUD showWithMsg:@"请填写所在区域和地址" inView:self.view];
        } else {
            [ULProgressHUD showWithMsg:@"保存中" inView:self.view withBlock:^{
                @strongify(self)
                [self.viewModel.improveCommand execute:@{
                                                         @"userId" : [ULUserMgr sharedMgr].userId,
                                                         @"username" : self.improveView.userName,
                                                         @"sex" : self.improveView.sex,
                                                         @"role" : self.improveView.role,
                                                         @"laboratoryName" : self.improveView.labName,
                                                         @"labLocation" : self.improveView.location
                                                         }];
            }];

        }
        
    }];
    //    [addButton setTitle:@"新建" forState:UIControlStateNormal];
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:addButton];
    
    self.navigationItem.rightBarButtonItem = buttonItem;
}

- (void)ul_bindViewModel
{
    [self.viewModel.improveCommand.executionSignals.flatten subscribeNext:^(id x) {
        [JMSGUser updateMyInfoWithParameter:self.improveView.userName userFieldType:kJMSGUserFieldsNickname completionHandler:^(id resultObject, NSError *error) {
            if (!error) {
                [JMSGUser updateMyInfoWithParameter:[NSString stringWithFormat:@"%@", [ULUserMgr sharedMgr].userName] userFieldType:kJMSGUserFieldsRegion completionHandler:^(id resultObject, NSError *error) {
                    if (!error) {
                        
                        [ULProgressHUD showWithMsg:@"保存成功" inView:self.view];
                        ULHomeViewController *homeVC = [[ULHomeViewController alloc] init];
                        [self presentViewController:homeVC animated:YES completion:nil];

                    } else {
                        [ULProgressHUD showWithMsg:@"保存失败"];
                    }
                }];

        } else {
            [ULProgressHUD showWithMsg:@"保存失败"];
                //updateMyInfoWithPareter fail
            }
        }];
    }];
}

- (void)ul_addSubviews
{
    [self.view addSubview:self.improveView];
    [self.view updateConstraintsIfNeeded];
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    [self.improveView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [super updateViewConstraints];
}

- (ULUserDetailImproveView *)improveView
{
    if (!_improveView)
    {
        _improveView = [[ULUserDetailImproveView alloc] init];
    }
    return _improveView;
}

- (ULUserDetailViewModel *)viewModel
{
    if (!_viewModel)
    {
        self.viewModel = [[ULUserDetailViewModel alloc] init];
    }
    return _viewModel;
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
