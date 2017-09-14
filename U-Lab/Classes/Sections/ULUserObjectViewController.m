//
//  ULUserObjectViewController.m
//  U-Lab
//
//  Created by 周维康 on 17/5/29.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULUserObjectViewController.h"
#import "ULMainObjectDetailViewController.h"
#import "ULUserObjectModel.h"
#import "ULUserObjectView.h"

@interface ULUserObjectViewController ()
@property (nonatomic, strong) ULUserObjectView *objectView;  /**< 主页面 */
@end

@implementation ULUserObjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)ul_addSubviews
{
    [self.view addSubview:self.objectView];
    [self.view updateConstraintsIfNeeded];
    [self.view setNeedsUpdateConstraints];
}

- (void)ul_layoutNavigation
{
    self.title = @"我的物品";
}

- (void)ul_bindViewModel
{
    @weakify(self)
    [self.objectView.nextSubject subscribeNext:^(id x) {
        @strongify(self)
        ULMainObjectDetailViewController *detailVC = [[ULMainObjectDetailViewController alloc] initWithObjectModel:x];
        [self.navigationController pushViewController:detailVC animated:YES];
    }];
}

- (void)updateViewConstraints
{
    [self.objectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [super updateViewConstraints];
}
- (ULUserObjectView *)objectView
{
    if (!_objectView)
    {
        _objectView = [[ULUserObjectView alloc] init];
    }
    return _objectView;
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
