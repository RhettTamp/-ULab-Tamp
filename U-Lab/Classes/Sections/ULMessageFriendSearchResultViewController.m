//
//  ULMessageFriendSearchResultViewController.m
//  ULab
//
//  Created by 周维康 on 2017/6/10.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULMessageFriendSearchResultViewController.h"
#import "ULMessageFriendSearchResultView.h"
#import "ULMessageGroupDetailViewController.h"

@interface ULMessageFriendSearchResultViewController ()

@property (nonatomic, strong) ULMessageFriendSearchResultView *resultView;  /**< 搜索结果 */
@end

@implementation ULMessageFriendSearchResultViewController
{
    NSArray *_labArray;
    NSString *keyString;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (instancetype)initWithKey:(NSString *)key labArray:(NSArray *)labArray
{
    _labArray = labArray;
    keyString = key;
    self = [super init];
    return self;
}
- (void)ul_bindViewModel
{
    [self.resultView.nextSubject subscribeNext:^(id x) {
        ULMessageGroupDetailViewController *detailVC = [[ULMessageGroupDetailViewController alloc] initWithGroup:x];
        [self.navigationController pushViewController:detailVC animated:YES];
    }];
}

- (void)ul_layoutNavigation
{
    self.title = @"查找结果";
}

- (void)ul_addSubviews
{
    [self.view addSubview:self.resultView];
    [self.view setNeedsUpdateConstraints];
    [self.view updateConstraintsIfNeeded];
}

- (void)updateViewConstraints
{
    [self.resultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [super updateViewConstraints];
}

- (ULMessageFriendSearchResultView *)resultView
{
    if (!_resultView)
    {
        _resultView = [[ULMessageFriendSearchResultView alloc] initWithKey:keyString labArray:_labArray];
    }
    return _resultView;
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
