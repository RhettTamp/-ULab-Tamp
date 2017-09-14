//
//  ULUserLabViewController.m
//  U-Lab
//
//  Created by 周维康 on 17/5/29.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULUserLabViewController.h"
#import "ULUserProjectCreatViewController.h"
#import "ULUserProjectEditViewController.h"
#import "ULUserLabView.h"
@interface ULUserLabViewController ()
@property (nonatomic, strong) ULUserLabView *labView;  /**< 实验室 */
@end

@implementation ULUserLabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.labView updateLabView];
}
- (void)ul_addSubviews
{
    [self.view addSubview:self.labView];
    [self.view updateConstraintsIfNeeded];
    [self.view setNeedsUpdateConstraints];
}

- (void)ul_layoutNavigation
{
    self.title = @"我的项目";
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    addButton.rac_command = self.labView.viewModel.addCommand;
    addButton.frame = CGRectMake(0, 0, 18, 17);
    @weakify(self)
    [[addButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        ULUserProjectCreatViewController *creatVC = [[ULUserProjectCreatViewController alloc] init];
        [self.navigationController pushViewController:creatVC animated:YES];
    }];
    [addButton setBackgroundImage:[UIImage imageNamed:@"home_user_add"] forState:UIControlStateNormal];
//    [addButton setTitle:@"新建" forState:UIControlStateNormal];
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:addButton];
    self.navigationItem.rightBarButtonItem = buttonItem;
}

- (void)ul_bindViewModel
{
    [self.labView.nextSubject subscribeNext:^(id x) {
        ULUserProjectEditViewController *editVC = [[ULUserProjectEditViewController alloc] initWithLabArray:x[@"labArray"]
                                                    andProjectId:x[@"projectId"]];
        [self.navigationController pushViewController:editVC animated:YES];
    }];
}
- (void)updateViewConstraints
{
    [self.labView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [super updateViewConstraints];
}

- (ULUserLabView *)labView
{
    if (!_labView)
    {
        _labView = [[ULUserLabView alloc] init];
    }
    return _labView;
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
