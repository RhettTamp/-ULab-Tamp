//
//  ULUserProjectCreatViewController.m
//  U-Lab
//
//  Created by 周维康 on 2017/6/6.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULUserProjectCreatViewController.h"
#import "ULUserLabCreatViewController.h"
#import "ULUserProjectCreatView.h"
@interface ULUserProjectCreatViewController ()

@property (nonatomic, strong) ULUserProjectCreatView *creatView;  /**< 新建仕途 */
@end

@implementation ULUserProjectCreatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)ul_addSubviews
{
    [self.view addSubview:self.creatView];
    [self.view updateConstraintsIfNeeded];
    [self.view setNeedsUpdateConstraints];
}

- (void)ul_layoutNavigation
{
    self.title = @"新建项目";
}

- (void)ul_bindViewModel
{
    [self.creatView.addSubject subscribeNext:^(id x) {
        ULUserLabCreatViewController *creatVC = [[ULUserLabCreatViewController alloc] init];
        @weakify(self)
        [creatVC.popSubject subscribeNext:^(id x) {
            @strongify(self)
            [self.creatView.finishSubject sendNext:x];
        }];
        [self.navigationController pushViewController:creatVC animated:YES];
    }];
    [self.creatView.popSubject subscribeNext:^(id x) {
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

- (ULUserProjectCreatView *)creatView
{
    if (!_creatView)
    {
        _creatView = [[ULUserProjectCreatView alloc] init];
    }
    return _creatView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
