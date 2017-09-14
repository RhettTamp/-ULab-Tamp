//
//  ULLabSearchResultViewController.m
//  U-Lab
//
//  Created by 周维康 on 2017/6/3.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULLabSearchResultViewController.h"
#import "ULLabSearchResultView.h"
#import "ULLabIntroViewController.h"

@interface ULLabSearchResultViewController ()

@property (nonatomic, strong) ULLabSearchResultView *resultView;  /**< 搜索结果 */
@property (nonatomic,assign) NSInteger type;
@end

@implementation ULLabSearchResultViewController
{
    NSArray *_labArray;
    NSString *keyString;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (instancetype)initWithKey:(NSString *)key labArray:(NSArray *)labArray andType:(NSInteger)type
{
    _labArray = labArray;
    keyString = key;
    self.type = type;
    self = [super init];
    return self;
}
- (void)ul_bindViewModel
{
    [self.resultView.nextObject subscribeNext:^(id x) {
        ULLabModel *model = x;
        ULLabIntroViewController *vc = [[ULLabIntroViewController alloc]initWithModel:model];
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

- (void)ul_layoutNavigation
{
    self.title = @"实验室";
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

- (ULLabSearchResultView *)resultView
{
    if (!_resultView)
    {
        _resultView = [[ULLabSearchResultView alloc] initWithKey:keyString labArray:_labArray andType:self.type];
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
