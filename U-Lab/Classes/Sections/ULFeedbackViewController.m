//
//  ULFeedbackViewController.m
//  U-Lab
//
//  Created by 周维康 on 17/5/28.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULFeedbackViewController.h"
#import "ULFeedbackView.h"

@interface ULFeedbackViewController ()

@property (nonatomic, strong) ULFeedbackView *feedView;  /**< 反馈 */
@end

@implementation ULFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)ul_addSubviews
{
    [self.view addSubview:self.feedView];
    [self.view setNeedsUpdateConstraints];
    [self.view updateConstraintsIfNeeded];
}

- (void)ul_layoutNavigation
{
    self.title = @"反馈与建议";
}

- (void)ul_bindViewModel
{
    [self.feedView.popSubject subscribeNext:^(id x) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
}
- (void)updateViewConstraints
{
    [self.feedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [super updateViewConstraints];
}

- (ULFeedbackView *)feedView
{
    if (!_feedView)
    {
        _feedView = [[ULFeedbackView alloc] init];
    }
    return _feedView;
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
