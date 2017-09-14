//
//  ULMessageGroupDetailView.m
//  ULab
//
//  Created by 周维康 on 2017/6/11.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULMessageGroupDetailView.h"

@interface ULMessageGroupDetailView()

@property (nonatomic, strong) JMSGGroup *group;  /**< 群组信息 */
@property (nonatomic, strong) UIView *headerView;  /**< 顶部头 */
@property (nonatomic, strong) UIView *userView;  /**< 群主 */
@property (nonatomic, strong) UIView *memberView;  /**< 群成员 */
@property (nonatomic, strong) UIView *detailView;  /**< 群信息 */
@property (nonatomic, strong) UIButton *addButton;  /**< 申请加入 */
@property (nonatomic, strong) UIImageView *bottomView;  /**< 底部花篮 */
@end


@implementation ULMessageGroupDetailView

- (instancetype)initWithGroup:(JMSGGroup *)group
{
     self.group = group;
    if (self = [super init])
    {
       
    }
    return self;
}

- (void)ul_setupViews
{
    self.backgroundColor = kBackgroundColor;
    [self addSubview:self.headerView];
    [self addSubview:self.userView];
    [self addSubview:self.memberView];
    [self addSubview:self.detailView];
    [self addSubview:self.addButton];
    [self addSubview:self.bottomView];
    [self updateConstraintsIfNeeded];
    [self setNeedsUpdateConstraints];
}

- (void)updateConstraints
{
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.mas_equalTo(45);
        make.top.equalTo(self).offset(64+14);
    }];
    [self.userView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.headerView.mas_bottom);
        make.height.mas_equalTo(45);
    }];
    [self.memberView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.userView.mas_bottom);
        make.height.mas_equalTo(45);
    }];
    [self.detailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.memberView.mas_bottom).offset(18);
        CGRect rect = [self.group.desc boundingRectWithSize:CGSizeMake(screenWidth, screenHeight) options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:kFont(kStandardPx(28))} context:nil];
        make.height.mas_equalTo(rect.size.height+50);
    }];
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.centerX.equalTo(self);
        make.top.equalTo(self.detailView.mas_bottom).offset(40);
        make.height.mas_equalTo(45);
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(33);
    }];
    [super updateConstraints];
}

- (UIImageView *)bottomView
{
    if (!_bottomView)
    {
        _bottomView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"register_bottom"]];
    }
    return _bottomView;
}

- (UIView *)headerView
{
    if (!_headerView)
    {
        _headerView = [[UIView alloc] init];
        _headerView.backgroundColor = kCommonWhiteColor;
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.font = kFont(kStandardPx(32));
        nameLabel.text = @"群名称";
        nameLabel.textColor = kTextBlackColor;
        [_headerView addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_headerView).offset(15);
            make.centerY.equalTo(_headerView);
        }];
        UILabel *detailLabel = [[UILabel alloc] init];
        detailLabel.font = kFont(kStandardPx(32));
        detailLabel.text = self.group.name;
        detailLabel.textColor = kTextBlackColor;
        [_headerView addSubview:detailLabel];
        [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_headerView).offset(-15);
            make.centerY.equalTo(_headerView);
        }];
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = kBackgroundColor;
        [_headerView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(_headerView);
            make.height.mas_equalTo(0.5);
        }];
    }
    return _headerView;
}

- (UIView *)userView
{
    if (!_userView)
    {
        _userView = [[UIView alloc] init];
        _userView.backgroundColor = kCommonWhiteColor;
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.font = kFont(kStandardPx(30));
        nameLabel.text = @"群主：";
        nameLabel.textColor = kTextBlackColor;
        [_userView addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_userView).offset(15);
            make.centerY.equalTo(_userView);
        }];
        UILabel *detailLabel = [[UILabel alloc] init];
        detailLabel.font = kFont(kStandardPx(32));
        detailLabel.text = self.group.owner;
        detailLabel.textColor = kTextBlackColor;
        [_userView addSubview:detailLabel];
        [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_userView).offset(-15);
            make.centerY.equalTo(_userView);
        }];
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = kBackgroundColor;
        [_userView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(_headerView);
            make.height.mas_equalTo(0.5);
        }];
    }
    return _userView;
}

- (UIView *)memberView
{
    if (!_memberView)
    {
        _memberView = [[UIView alloc] init];
        _memberView.backgroundColor = kCommonWhiteColor;
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.font = kFont(kStandardPx(30));
        nameLabel.text = @"群成员：";
        nameLabel.textColor = kTextBlackColor;
        [_memberView addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_memberView).offset(5);
            make.centerY.equalTo(_memberView);
        }];
        UILabel *detailLabel = [[UILabel alloc] init];
        detailLabel.font = kFont(kStandardPx(32));
        detailLabel.text = [NSString stringWithFormat:@"%@人(加入群后可见)", @(self.group.memberArray.count)];
        detailLabel.textColor = kTextBlackColor;
        [_memberView addSubview:detailLabel];
        [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_memberView).offset(-5);
            make.centerY.equalTo(_memberView);
        }];
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = kBackgroundColor;
        [_memberView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(_headerView);
            make.height.mas_equalTo(0.5);
        }];
    }
    return _memberView;
}

- (UIView *)detailView
{
    if (!_detailView)
    {
        _detailView = [[UIView alloc] init];
        _detailView.backgroundColor = kCommonWhiteColor;
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.font = kFont(kStandardPx(30));
        nameLabel.text = @"群信息：";
        nameLabel.textColor = kTextBlackColor;
        [_detailView addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_detailView).offset(15);
            make.top.equalTo(_detailView).offset(10);
        }];
        UILabel *detailLabel = [[UILabel alloc] init];
        detailLabel.font = kFont(kStandardPx(32));
        detailLabel.text = self.group.desc;
        detailLabel.textColor = kTextBlackColor;
        [_detailView addSubview:detailLabel];
        [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_detailView).offset(-15);
            make.top.equalTo(nameLabel.mas_bottom).offset(5);
            make.centerX.equalTo(_detailView);
        }];
    }
    return _detailView;
}

- (UIButton *)addButton
{
    if (!_addButton)
    {
        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _addButton.layer.cornerRadius = 5;
        _addButton.layer.masksToBounds = YES;
        _addButton.backgroundColor = KButtonBlueColor;
        _addButton.titleLabel.font = kFont(kStandardPx(39));
        [_addButton setTitleColor:kCommonWhiteColor forState:UIControlStateNormal];
        [_addButton setTitle:@"申请加入" forState:UIControlStateNormal];
        @weakify(self)
        [[_addButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self)
            [self.group addMembersWithUsernameArray:@[[ULUserMgr sharedMgr].userPhone] completionHandler:^(id resultObject, NSError *error) {
                if (!error) {
                    _addButton.backgroundColor = [UIColor clearColor];
                    [_addButton setTitle:@"已加入" forState:UIControlStateNormal];
                    [_addButton setTitleColor:KTextGrayColor forState:UIControlStateNormal];
                    _addButton.userInteractionEnabled = NO;
                } else {
                    [ULProgressHUD showWithMsg:@"请求失败"];
                }
            }];
        }];
    }
    return _addButton;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
