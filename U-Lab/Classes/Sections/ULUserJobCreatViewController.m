//
//  ULUserJobCreatViewController.m
//  U-Lab
//
//  Created by 周维康 on 2017/6/7.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULUserJobCreatViewController.h"
#import "ULUserJobCreatView.h"

@interface ULUserJobCreatViewController ()

@property (nonatomic, strong) ULUserJobCreatView *creatView;  /**< 工作创建视图 */

@end

@implementation ULUserJobCreatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)ul_layoutNavigation
{
    self.title = @"新建工作";
}

- (void)ul_addSubviews
{
    [self.view addSubview:self.creatView];
    [self.view updateConstraintsIfNeeded];
    [self.view setNeedsUpdateConstraints];
}

- (void)ul_bindViewModel
{
    @weakify(self)
    [self.creatView.finishSubject subscribeNext:^(id x) {
        @strongify(self)
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)updateViewConstraints
{
    [self.creatView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [super updateViewConstraints];
}

- (ULUserJobCreatView *)creatView
{
    if (!_creatView)
    {
        _creatView = [[ULUserJobCreatView alloc] init];
    }
    return _creatView;
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
