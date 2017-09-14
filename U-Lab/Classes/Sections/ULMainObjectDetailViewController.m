//
//  ULMainObjectDetailViewController.m
//  ULab
//
//  Created by 周维康 on 2017/6/15.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULMainObjectDetailViewController.h"
#import "ULUserObjectModel.h"
#import "ULLabObjectShareDetailView.h"
#import "ULMainShareStatusViewController.h"
@interface ULMainObjectDetailViewController ()
@property (nonatomic, strong) ULLabObjectShareDetailView *detailView;  /**< detail */
@property (nonatomic, strong) ULUserObjectModel *model;  /**< <#comment#> */
@end

@implementation ULMainObjectDetailViewController


- (instancetype)initWithObjectModel:(ULUserObjectModel *)model
{
    self.model = model;
    self = [super init];
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)ul_bindViewModel
{
    [self.detailView.subject subscribeNext:^(id x) {
        ULMainShareStatusViewController *vc = [[ULMainShareStatusViewController alloc] init];
        [vc.popSubject subscribeNext:^(id x) {
//            self.dic = x;
        }];
        [self.navigationController pushViewController:vc animated:YES];
    }];
}
- (void)ul_addSubviews
{
    [self.view addSubview:self.detailView];
    [self.view updateConstraintsIfNeeded];
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    [self.detailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [super updateViewConstraints];
}

- (ULLabObjectShareDetailView *)detailView
{
    if (!_detailView)
    {
        _detailView = [[ULLabObjectShareDetailView alloc] initWithModel:self.model];
    }
    return _detailView;
}
- (void)ul_layoutNavigation
{
    self.title = @"物品详情";
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
