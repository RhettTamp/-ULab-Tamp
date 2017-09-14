//
//  ULMessageUserDetailViewController.m
//  ULab
//
//  Created by 周维康 on 2017/6/11.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULMessageUserDetailViewController.h"
#import "ULLabMemberModel.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ULMessageUserDetailViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *detailTableView;  /**< 详情列表 */
@property (nonatomic, strong) UIView *headerView;  /**< 顶部按钮 */
@property (nonatomic, strong) UIImageView *bottomView;  /**< 底部花篮 */
@property (nonatomic, strong) JMSGUser *user;  /**< <#comment#> */
@property (nonatomic, strong) ULLabMemberModel *model;  /**< <#comment#> */
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) UIButton *agreeButton;
@property (nonatomic, strong) UIButton *refuseButton;
@property (nonatomic, strong) UILabel *stateLabel;

@end

@implementation ULMessageUserDetailViewController
{
    NSArray *_nameArray;
    NSArray *_detailArray;
}

- (instancetype)initWithUser:(JMSGUser *)user
{
    self.user = user;
    self = [super init];
    return self;
}
- (instancetype)initWithModel:(ULLabMemberModel *)model andType:(NSInteger)type
{
    self.model = model;
    self.type = type;
    self = [super init];
    return self;
}

- (void)ul_addSubviews
{
    _nameArray = @[@"手机号码", @"研究方向", @"常用邮箱", @"毕业院校"];
    if (self.model)
    {
        _detailArray = @[self.model.memberPhone?:@"", self.model.research?:@"", self.model.memberEmail?:@"", self.model.school?:@""];
    } else {
        _detailArray = @[self.user.username, @"", @"", @""];
    }
    [self.view addSubview:self.detailTableView];
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.bottomView];
    if (self.type == 1) {
        if ([self.model.menberStatus integerValue] == 0) {
            [self.view addSubview:self.agreeButton];
            [self.view addSubview:self.refuseButton];
            
        }else if ([self.model.menberStatus integerValue] == 1){
            [self.view addSubview:self.stateLabel];
            self.stateLabel.text = @"已同意";
        }else{
            [self.view addSubview:self.stateLabel];
            self.stateLabel.text = @"已拒绝";
        }
    }
    [self.view updateConstraintsIfNeeded];
    [self.view setNeedsUpdateConstraints];

}

- (void)ul_layoutNavigation
{
    self.title = @"用户详情";
}

- (void)updateViewConstraints
{
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(64+15);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(88);
    }];
    [self.detailTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom).offset(15);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-33);
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(33);
    }];
    if (self.type == 1) {
        if ([self.model.menberStatus integerValue] == 0) {
            [self.agreeButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.view.mas_bottom).offset(-80);
                make.size.mas_equalTo(CGSizeMake(80, 40));
                make.centerX.equalTo(self.view).offset(-50);
            }];
            
            [self.refuseButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.view.mas_bottom).offset(-80);
                make.size.mas_equalTo(CGSizeMake(80, 40));
                make.centerX.equalTo(self.view).offset(50);
            }];
            
        }else if ([self.model.menberStatus integerValue] == 1){
            [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.view);
                make.bottom.equalTo(self.view).offset(-80);
            }];
            self.stateLabel.text = @"已同意";
        }else{
            [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.view);
                make.bottom.equalTo(self.view).offset(-80);
            }];
            self.stateLabel.text = @"已拒绝";
        }
        
    }
    [super updateViewConstraints];
}


- (UIButton *)refuseButton{
    if (!_refuseButton) {
        _refuseButton = [UIButton new];
        [_refuseButton setTitle:@"拒绝" forState:UIControlStateNormal];
        [_refuseButton setTitleColor:kCommonWhiteColor forState:UIControlStateNormal];
        _refuseButton.backgroundColor = kCommonRedColor;
        _refuseButton.layer.cornerRadius = 4;
        [[_refuseButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            ULBaseRequest *request = [[ULBaseRequest alloc]init];
            request.isJson = NO;
            [request postDataWithParameter:@{@"labApplyId":self.model.applyId,
                                             @"status":@(-1)} session:YES progress:nil success:^(ULBaseRequest *request, NSDictionary *responseObject) {
                                                 _refuseButton.hidden = YES;
                                                 _agreeButton.hidden = YES;
                                                 [self.view addSubview:self.stateLabel];
                                                 self.stateLabel.text = @"已拒绝";
                                                 [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                                                     make.centerX.equalTo(self.view);
                                                     make.bottom.equalTo(self.view).offset(-80);
                                                 }];
                                             } failure:^(ULBaseRequest *request, NSError *error) {
                                                 [ULProgressHUD showWithMsg:@"请求失败"];
                                             } withPath:@"ulab_lab/lab/labApply/status"];
        }];
    }
    return _refuseButton;
}

- (UIButton *)agreeButton{
    if (!_agreeButton) {
        _agreeButton = [UIButton new];
        [_agreeButton setTitle:@"同意" forState:UIControlStateNormal];
        [_agreeButton setTitleColor:kCommonWhiteColor forState:UIControlStateNormal];
        _agreeButton.backgroundColor = kCommonBlueColor;
        _agreeButton.layer.cornerRadius = 4;
        [[_agreeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            ULBaseRequest *request = [[ULBaseRequest alloc]init];
            request.isJson = NO;
            [request postDataWithParameter:@{@"labApplyId":self.model.applyId,
                                             @"status":@1} session:YES progress:nil success:^(ULBaseRequest *request, NSDictionary *responseObject) {
                                                 _refuseButton.hidden = YES;
                                                 _agreeButton.hidden = YES;
                                                 [self.view addSubview:self.stateLabel];
                                                 [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                                                     make.centerX.equalTo(self.view);
                                                     make.bottom.equalTo(self.view).offset(-80);
                                                 }];
                                                 self.stateLabel.text = @"已同意";
                                             } failure:^(ULBaseRequest *request, NSError *error) {
                                                 [ULProgressHUD showWithMsg:@"请求失败"];
                                             } withPath:@"ulab_lab/lab/labApply/status"];
        }];
    }
    return _agreeButton;
}

- (UILabel *)stateLabel{
    if (!_stateLabel) {
        _stateLabel = [[UILabel alloc]init];
        _stateLabel.textColor = kCommonGrayColor;
    }
    return _stateLabel;
}

- (UITableView *)detailTableView
{
    if (!_detailTableView)
    {
        _detailTableView = [[UITableView alloc] init];
        _detailTableView.delegate = self;
        _detailTableView.dataSource = self;
        _detailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _detailTableView.backgroundColor = kBackgroundColor;
        _detailTableView.scrollEnabled = NO;
        [_detailTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ULMessageUserDetailTableViewCellIdentifier"];
    }
    return _detailTableView;
}

- (UIView *)headerView
{
    if (!_headerView)
    {
        _headerView = [[UIView alloc] init];
        _headerView.backgroundColor = kCommonWhiteColor;
        UIImageView *headerImageView;
        if (self.model){
            headerImageView = [[UIImageView alloc] init];
            [headerImageView sd_setImageWithURL:[NSURL URLWithString:_model.headImage] placeholderImage:[UIImage imageNamed:@"ulab_user_default"]];
        }else{
            if (self.user.avatar)
            headerImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.user.avatar]]]];
        else
            headerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ulab_user_default"]];
        }
        headerImageView.layer.cornerRadius = 25.5;
        headerImageView.layer.masksToBounds = YES;
        [_headerView addSubview:headerImageView];
        [headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_headerView);
            make.left.equalTo(_headerView).offset(15);
            make.size.mas_equalTo(CGSizeMake(51, 51));
        }];
        UILabel *nameLabel = [[UILabel alloc] init];
        if (self.model)
        {
            nameLabel.text = self.model.memberName;
        } else {
            nameLabel.text = self.user.nickname;
        }
        
        nameLabel.textColor = [UIColor blackColor];
        nameLabel.font = kFont(kStandardPx(34));
        [_headerView addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(headerImageView.mas_right).offset(17);
            make.top.equalTo(_headerView).offset(21);
        }];
        UILabel *detailLabel = [[UILabel alloc] init];
        if (self.model)
        {
            detailLabel.text = self.model.labName;
        } else {
            detailLabel.text = @"";
        }
        detailLabel.textColor = KTextGrayColor;
        detailLabel.font = kFont(kStandardPx(28));
        [_headerView addSubview:detailLabel];
        [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(nameLabel);
            make.top.equalTo(nameLabel.mas_bottom).offset(13);
        }];
    }
    return _headerView;
}

- (UIImageView *)bottomView
{
    if (!_bottomView)
    {
        _bottomView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"register_bottom"]];
    }
    return _bottomView;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _detailArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [self.detailTableView dequeueReusableCellWithIdentifier:@"ULMessageUserDetailTableViewCellIdentifier"];
    UILabel *nameLabel = [[UILabel alloc] init];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    nameLabel.font = kFont(kStandardPx(30));
    nameLabel.text = _nameArray[indexPath.row];
    nameLabel.textColor = KTextGrayColor;
    [cell addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell).offset(15);
        make.centerY.equalTo(cell);
    }];
    UILabel *detailLabel = [[UILabel alloc] init];
    detailLabel.textColor = KTextGrayColor;
    detailLabel.text = _detailArray[indexPath.row];
    detailLabel.font = kFont(kStandardPx(30));
    [cell addSubview:detailLabel];
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(cell).offset(-15);
        make.centerY.equalTo(cell);
    }];
    return cell;
}

@end
