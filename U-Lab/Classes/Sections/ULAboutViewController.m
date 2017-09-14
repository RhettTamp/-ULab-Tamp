//
//  ULAboutViewController.m
//  U-Lab
//
//  Created by 周维康 on 17/5/26.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULAboutViewController.h"
#import "ULAboutView.h"

@interface ULAboutViewController ()

@property (nonatomic, strong) ULAboutView *aboutView;  /**< 主页面 */
@end

@implementation ULAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)ul_addSubviews
{
    [self.view addSubview:self.aboutView];
    [self.view updateConstraintsIfNeeded];
    [self.view setNeedsUpdateConstraints];
}

- (void)ul_layoutNavigation
{
    self.title = @"关于U-Lab";
}
- (void)updateViewConstraints
{
    [self.aboutView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [super updateViewConstraints];
}

- (ULAboutView *)aboutView
{
    if (!_aboutView)
    {
        _aboutView = [[ULAboutView alloc] init];
    }
    return _aboutView;
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
