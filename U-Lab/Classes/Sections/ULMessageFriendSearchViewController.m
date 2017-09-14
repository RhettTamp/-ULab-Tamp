//
//  ULMessageFriendSearchViewController.m
//  ULab
//
//  Created by 周维康 on 2017/6/10.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULMessageFriendSearchViewController.h"
#import "ULMessageFriendSearchResultViewController.h"
#import "ULMessageFriendSearchView.h"

@interface ULMessageFriendSearchViewController ()

@property (nonatomic, strong) ULMessageFriendSearchView *searchView;  /**< view */

@end

@implementation ULMessageFriendSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)ul_bindViewModel
{
    @weakify(self)
    [self.searchView.viewModel.searchCommand.executionSignals.flatten subscribeNext:^(id x) {
        @strongify(self)
        NSArray *friendArray = x;
        [ULProgressHUD hide];
        if (friendArray.count == 0)
        {
            [ULProgressHUD showWithMsg:@"搜索无结果" inView:self.view];
        } else if (friendArray.count>0) {
            ULMessageFriendSearchResultViewController *resultVC = [[ULMessageFriendSearchResultViewController alloc] initWithKey:self.searchView.viewModel.searchString labArray:friendArray];
            [self.navigationController pushViewController:resultVC animated:YES];
        }
    }];
}

- (void)ul_layoutNavigation
{
    self.title = @"搜索";
}
- (void)ul_addSubviews
{
    [self.view addSubview:self.searchView];
    [self.view updateConstraintsIfNeeded];
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [super updateViewConstraints];
}


- (ULMessageFriendSearchView *)searchView
{
    if (!_searchView)
    {
        _searchView = [[ULMessageFriendSearchView alloc] init];
    }
    return _searchView;
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
