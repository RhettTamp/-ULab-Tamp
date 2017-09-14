//
//  ULAboutView.m
//  U-Lab
//
//  Created by 周维康 on 17/5/26.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULAboutView.h"

@interface ULAboutView()

@property (nonatomic, strong) UIImageView *backgroundImageView;  /**< 背景板 */
@property (nonatomic, strong) UILabel *comeLabel;  /**< 归属 */
@property (nonatomic, strong) UIImageView *signImageView;  /**< 标志 */
@property (nonatomic, strong) UIImageView *bottomImageView;  /**< 底部花篮 */

@end
@implementation ULAboutView

- (void)ul_setupViews
{
    [self addSubview:self.backgroundImageView];
    [self addSubview:self.comeLabel];
    [self addSubview:self.signImageView];
    [self addSubview:self.bottomImageView];
    [self updateConstraintsIfNeeded];
    [self setNeedsUpdateConstraints];
}

- (void)updateConstraints
{
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.signImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(180, 46));
        make.top.equalTo(self.backgroundImageView).offset(155+64);
    }];
    [self.comeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.signImageView.mas_bottom).offset(89);
    }];
    [self.bottomImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(33);
    }];

    [super updateConstraints];
}

- (UIImageView *)backgroundImageView
{
    if (!_backgroundImageView)
    {
        _backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_background"]];
    }
    return _backgroundImageView;
}

- (UIImageView *)signImageView
{
    if (!_signImageView)
    {
        _signImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_ulab"]];
    }
    return _signImageView;
}

- (UILabel *)comeLabel
{
    if (!_comeLabel)
    {
        _comeLabel = [[UILabel alloc] init];
        _comeLabel.textAlignment = NSTextAlignmentCenter;
        _comeLabel.font = kFont(kStandardPx(30));
        _comeLabel.text = @"U-Lab V1.0.0.0\n\n归属于第三军医大学脑部研究中心\n\n由重庆逼逼牛科技有限公司开发维护";
    }
    return _comeLabel;
}

- (UIImageView *)bottomImageView
{
    if (!_bottomImageView)
    {
        _bottomImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"register_bottom"]];
    }
    return _bottomImageView;
}
@end
