//
//  ULHelpViewController.m
//  U-Lab
//
//  Created by 周维康 on 17/5/26.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULHelpViewController.h"
#import "ULAboutViewController.h"
#import "ULFeedbackViewController.h"
#import "ULUseIntroViewController.h"
#import "ULHelpView.h"

@interface ULHelpViewController ()

@property (nonatomic, strong) ULHelpView *helpView;  /**< 帮助界面 */
@property (nonatomic, strong) UILabel *commonLabel;  /**< 常见问题 */
@property (nonatomic, strong) UIButton *useButton;  /**< 如何使用 */
@property (nonatomic, strong) UIButton *adviceButton;  /**< 建议 */
@property (nonatomic, strong) UIButton *aboutButton;  /**< 关于 */

@end

@implementation ULHelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)ul_addSubviews
{
    self.view.backgroundColor = kBackgroundColor;
    [self.view addSubview:self.commonLabel];
    [self.view addSubview:self.useButton];
    [self.view addSubview:self.adviceButton];
    [self.view addSubview:self.aboutButton];
    [self.view updateConstraintsIfNeeded];
    [self.view setNeedsUpdateConstraints];
    [self setButton:self.useButton title:@"如何使用U-Lab"];
    [self setButton:self.adviceButton title:@"建议与反馈"];
    [self setButton:self.aboutButton title:@"关于U-Lab"];
    [self.view updateConstraintsIfNeeded];
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    [self.commonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.top.equalTo(self.view).offset(82);
    }];
    [self.useButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.commonLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(45);
    }];

    [self.adviceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.useButton.mas_bottom).offset(9);
        make.left.right.height.equalTo(self.useButton);
    }];
    [self.aboutButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.adviceButton.mas_bottom).offset(9);
        make.left.right.height.equalTo(self.useButton);
    }];

    
    [super updateViewConstraints];
}
- (void)ul_layoutNavigation
{
    self.title = @"帮助";
}


- (UILabel *)commonLabel
{
    if (!_commonLabel)
    {
        _commonLabel = [[UILabel alloc] init];
        _commonLabel.text = @"常见问题";
        _commonLabel.textColor = [UIColor colorWithRGBHex:0x999999];
        _commonLabel.font = kFont(kStandardPx(28));
    }
    return _commonLabel;
}

- (UIButton *)useButton
{
    if (!_useButton)
    {
        _useButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _useButton.backgroundColor = kCommonWhiteColor;
        [[_useButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            ULUseIntroViewController *introVC = [[ULUseIntroViewController alloc] init];
            [self.navigationController pushViewController:introVC animated:YES];
        }];
    }
    return _useButton;
}

- (UIButton *)adviceButton
{
    if (!_adviceButton)
    {
        _adviceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _adviceButton.backgroundColor = kCommonWhiteColor;
        [[_adviceButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            ULFeedbackViewController *vc = [[ULFeedbackViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }];
    }
    return _adviceButton;
}

- (UIButton *)aboutButton
{
    if (!_aboutButton)
    {
        _aboutButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _aboutButton.backgroundColor = kCommonWhiteColor;
        [[_aboutButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            ULAboutViewController *vc = [[ULAboutViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }];
    }
    return _aboutButton;
}

- (void)setButton:(UIButton *)button title:(NSString *)title
{
    UILabel *label = [[UILabel alloc] init];
    label.text = title;
    label.font = kFont(kStandardPx(30));
    [button addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(button);
        make.left.equalTo(button).offset(15);
    }];
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = kBackgroundColor;
    [button addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(button);
        make.height.mas_equalTo(0.5);
    }];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_user_next"]];
    [button addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(button).offset(-15);
        make.centerY.equalTo(button);
        make.size.mas_equalTo(CGSizeMake(10, 15));
    }];
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
