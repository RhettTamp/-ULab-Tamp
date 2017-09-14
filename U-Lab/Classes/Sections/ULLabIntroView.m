//
//  ULLabIntroView.m
//  U-Lab
//
//  Created by 周维康 on 2017/6/7.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULLabIntroView.h"
#import "ULLabModel.h"

@interface ULLabIntroView()

@property (nonatomic, strong) UIView *whiteView;  /**< 白色背景 */
@property (nonatomic, strong) UILabel *nameLabel;  /**< 实验室名称 */
@property (nonatomic, strong) UILabel *piLabel;  /**< pi */
@property (nonatomic, strong) UILabel *introLabel;  /**< 简介 */
@property (nonatomic, strong) UILabel *labLabel;  /**< 实验室 */
@property (nonatomic, strong) UILabel *searchLabel;  /**< 研究方向 */
@property (nonatomic, strong) UILabel *searchDetailLabel;  /**< 研究方向 */
@property (nonatomic, strong) UILabel *placeLabel;  /**< 地址 */
@property (nonatomic, strong) UILabel *placeDetailLabel;  /**< 具体地址 */
@property (nonatomic, strong) UIImageView *bottomView;  /**< 底部花篮 */

//@property (nonatomic, strong) UILabel *labTextLabel;  /**< 实验室 */
@end

@implementation ULLabIntroView

- (instancetype)initWithModel:(ULLabModel *)model
{
    self = [super init];
    if (self) {
        self.model = model;
        [self reloadData];
    }
    return self;
}

- (void)reloadData{
    if (self.model) {
        self.nameLabel.text = self.model.labName;
        self.piLabel.text = [NSString stringWithFormat:@"PI：%@", self.model.piName];
        self.labLabel.text = self.model.labIntroduction;
        self.searchDetailLabel.text = self.model.labResearch;
        self.placeDetailLabel.text = self.model.labLocation;
        [self updateConstraints];
    }else{
        self.nameLabel.text = [ULUserMgr sharedMgr].laboratoryName;
        self.piLabel.text = [NSString stringWithFormat:@"PI：%@",[ULUserMgr sharedMgr].labPiName];
        self.labLabel.text = [ULUserMgr sharedMgr].labIntro;
        self.searchDetailLabel.text = [ULUserMgr sharedMgr].labResearch?:@"";
        self.placeDetailLabel.text = [ULUserMgr sharedMgr].labLocation;
    }
}

- (void)ul_setupViews
{
    self.backgroundColor = kBackgroundBlueColor;
    [self addSubview:self.whiteView];
    [self.whiteView addSubview:self.nameLabel];
    [self.whiteView addSubview:self.piLabel];
    [self.whiteView addSubview:self.introLabel];
    [self.whiteView addSubview:self.labLabel];
    [self.whiteView addSubview:self.searchLabel];
    [self.whiteView addSubview:self.searchDetailLabel];
    [self.whiteView addSubview:self.placeLabel];
    [self.whiteView addSubview:self.placeDetailLabel];
    [self addSubview:self.bottomView];
    
    [self updateConstraintsIfNeeded];
    [self setNeedsUpdateConstraints];
}

- (void)updateConstraints
{
    [self.whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(110);
        make.bottom.equalTo(self).offset(-80);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.whiteView).offset(12);
        make.top.equalTo(self.whiteView).offset(26.5);
    }];
    [self.piLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(12);
    }];
    [self.introLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.top.equalTo(self.piLabel.mas_bottom).offset(18);
    }];

    [self.labLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.top.equalTo(self.introLabel.mas_bottom).offset(14);
    }];
    [self.searchLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.top.equalTo(self.labLabel.mas_bottom).offset(18);
    }];
    [self.searchDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.top.equalTo(self.searchLabel.mas_bottom).offset(14);
    }];
    [self.placeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.top.equalTo(self.searchDetailLabel.mas_bottom).offset(18);
    }];
    [self.placeDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.top.equalTo(self.placeLabel.mas_bottom).offset(14);
        make.width.mas_lessThanOrEqualTo(screenWidth-30-12-12);
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(33);
    }];
    [super updateConstraints];
}

- (UIView *)whiteView
{
    if (!_whiteView)
    {
        _whiteView = [[UIView alloc] init];
        _whiteView.backgroundColor = kCommonWhiteColor;
    }
    return _whiteView;
}
- (UILabel *)nameLabel
{
    if (!_nameLabel)
    {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = [ULUserMgr sharedMgr].laboratoryName;
        _nameLabel.font = [UIFont systemFontOfSize:kStandardPx(32) weight:2];
        _nameLabel.textColor = kTextBlackColor;
    }
    return _nameLabel;
}

- (UILabel *)piLabel
{
    if (!_piLabel)
    {
        _piLabel = [[UILabel alloc] init];
//        _piLabel.text = [NSString stringWithFormat:@"PI：%@", [ULUserMgr sharedMgr].labPiName];
        _piLabel.font = kFont(kStandardPx(26));
        _piLabel.textColor = kTextBlackColor;
    }
    return _piLabel;
}
- (UILabel *)introLabel
{
    if (!_introLabel)
    {
        _introLabel = [[UILabel alloc] init];
        _introLabel.text = @"实验室简介：";
        _introLabel.font = [UIFont systemFontOfSize:kStandardPx(28) weight:2];
        _introLabel.textColor = kTextBlackColor;
    }
    return _introLabel;
}
- (UILabel *)labLabel
{
    if (!_labLabel)
    {
        _labLabel = [[UILabel alloc] init];
//        _labLabel.text = [ULUserMgr sharedMgr].labIntro;
        _labLabel.font = kFont(kStandardPx(24));
        _labLabel.textColor = KTextGrayColor;
    }
    return _labLabel;
}
- (UILabel *)searchLabel
{
    if (!_searchLabel)
    {
        _searchLabel = [[UILabel alloc] init];
        _searchLabel.text = @"研究方向：";
        _searchLabel.font = [UIFont systemFontOfSize:kStandardPx(28) weight:2];
        _searchLabel.textColor = kTextBlackColor;
    }
    return _searchLabel;
}
- (UILabel *)searchDetailLabel
{
    if (!_searchDetailLabel)
    {
        _searchDetailLabel = [[UILabel alloc] init];
//        _searchDetailLabel.text = [ULUserMgr sharedMgr].labResearch?:@"";
        _searchDetailLabel.font = kFont(kStandardPx(24));
        _searchDetailLabel.textColor = KTextGrayColor;
    }
    return _searchDetailLabel;
}


- (UILabel *)placeLabel
{
    if (!_placeLabel)
    {
        _placeLabel = [[UILabel alloc] init];
        _placeLabel.text = @"地址：";
        _placeLabel.font = [UIFont systemFontOfSize:kStandardPx(28) weight:2];
        _placeLabel.textColor = kTextBlackColor;
    }
    return _placeLabel;
}

- (UILabel *)placeDetailLabel
{
    if (!_placeDetailLabel)
    {
        _placeDetailLabel = [[UILabel alloc] init];
//        _placeDetailLabel.text = [ULUserMgr sharedMgr].labLocation;
        _placeDetailLabel.font = kFont(kStandardPx(24));
        _placeDetailLabel.textColor = KTextGrayColor;
        _placeDetailLabel.numberOfLines = 0;
    }
    return _placeDetailLabel;
}

- (UIImageView *)bottomView
{
    if (!_bottomView)
    {
        _bottomView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"register_bottom"]];
    }
    return _bottomView;
}
@end
