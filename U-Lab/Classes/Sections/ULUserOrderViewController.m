//
//  ULMyOrderViewController.m
//  U-Lab
//
//  Created by 周维康 on 17/5/22.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULUserOrderViewController.h"
#import "ULUserOrderView.h"
#import "ULLendApplyViewController.h"
@interface ULUserOrderViewController ()

@property (nonatomic, strong) ULUserOrderView *orderView;  /**< 订单视图 */

@end

@implementation ULUserOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)ul_addSubviews
{
    [self.view addSubview:self.orderView];
    [self.view updateConstraintsIfNeeded];
    [self.view setNeedsUpdateConstraints];
}

- (void)ul_bindViewModel
{
    [self.orderView.nextSubject subscribeNext:^(id x) {
        NSNumber *type = x[@"type"];
        ULLendApplyViewController *vc = [[ULLendApplyViewController alloc] initWithModel:x[@"data"] andType:type];
        [self.navigationController pushViewController:vc animated:YES];
    }];
}
- (void)ul_layoutNavigation
{
    self.title = @"我的订单";
}
- (void)updateViewConstraints
{
    [self.orderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [super updateViewConstraints];
}
- (ULUserOrderView *)orderView
{
    if (!_orderView)
    {
        _orderView = [[ULUserOrderView alloc] init];
    }
    return _orderView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
