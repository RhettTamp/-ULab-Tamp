//
//  ULHelpView.m
//  U-Lab
//
//  Created by 周维康 on 17/5/26.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULHelpView.h"

@interface ULHelpView()

@property (nonatomic, strong) UILabel *commonLabel;  /**< 常见问题 */
@property (nonatomic, strong) UIButton *useButton;  /**< 如何使用 */
@property (nonatomic, strong) UIButton *lendButton;  /**< 借用物品 */
@property (nonatomic, strong) UIButton *adviceButton;  /**< 建议 */
@property (nonatomic, strong) UIButton *aboutButton;  /**< 关于 */

@end

@implementation ULHelpView

- (void)ul_setupViews
{
    }

- (void)updateConstraints
{
    [super updateConstraints];
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
    }
    return _useButton;
}

- (UIButton *)adviceButton
{
    if (!_adviceButton)
    {
        _adviceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _adviceButton.backgroundColor = kCommonWhiteColor;
    }
    return _adviceButton;
}

- (UIButton *)aboutButton
{
    if (!_aboutButton)
    {
        _aboutButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _aboutButton.backgroundColor = kCommonWhiteColor;
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
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
