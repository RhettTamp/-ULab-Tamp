//
//  ULGroupUsersViewController.m
//  ULab
//
//  Created by 周维康 on 2017/6/21.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULGroupUsersViewController.h"

@interface ULGroupUsersViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;  /**< 列表 */
@property (nonatomic, strong) UIImageView *bottomView;  /**< 底部花篮 */
@property (nonatomic, strong) UILabel *ownerLabel;  /**< <#comment#> */
@property (nonatomic, strong) UIView *ownerView;  /**< <#comment#> */
@property (nonatomic, strong) UILabel *userLabel;  /**< <#comment#> */
@property (nonatomic, strong) JMSGGroup *group;  /**< <#comment#> */

@end

@implementation ULGroupUsersViewController
{

}

- (instancetype)initWithGroup:(JMSGGroup *)group
{
    self.group = group;
    self = [super init];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)ul_layoutNavigation
{
    self.title = @"群成员";
}
- (void)ul_addSubviews
{
    self.view.backgroundColor = kBackgroundColor;
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomView];
    [self.view addSubview:self.ownerView];
    [self.view addSubview:self.ownerLabel];
    [self.view addSubview:self.userLabel];
    [self.view updateConstraintsIfNeeded];
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    [self.ownerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.top.equalTo(self.view).offset(64+8);
    }];
    [self.ownerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.ownerLabel.mas_bottom).offset(5);
        make.height.mas_equalTo(45);
    }];
    [self.userLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.top.equalTo(self.ownerView.mas_bottom).offset(8);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userLabel.mas_bottom).offset(5);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-33);
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(33);
    }];
    [super updateViewConstraints];
}



- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = kBackgroundColor;
        _tableView.scrollEnabled = NO;
        _tableView.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0);
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ULGroupUsersTableViewCellIdentifier"];
    }
    return _tableView;
}
- (UIImageView *)bottomView
{
    if (!_bottomView)
    {
        _bottomView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"register_bottom"]];
    }
    return _bottomView;
}

- (UILabel *)ownerLabel
{
    if (!_ownerLabel)
    {
        _ownerLabel = [[UILabel alloc] init];
        _ownerLabel.font = kFont(kStandardPx(28));
        _ownerLabel.textColor = kTextBlackColor;
        _ownerLabel.text = @"群主";
    }
    return _ownerLabel;
}

- (UIView *)ownerView
{
    if (!_ownerView)
    {
        _ownerView = [[UIView alloc] init];
        _ownerView.backgroundColor = kCommonWhiteColor;
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithColor:kCommonGrayColor]];
        imageView.layer.cornerRadius = 20;
        imageView.layer.masksToBounds = YES;
        [_ownerView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_ownerView).offset(15);
            make.centerY.equalTo(_ownerView);
            make.size.mas_equalTo(CGSizeMake(40, 40));
        }];
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.font = kFont(kStandardPx(28));
        nameLabel.textColor = kTextBlackColor;
        nameLabel.text = self.group.owner;
        [_ownerView addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imageView.mas_right).offset(14);
            make.centerY.equalTo(_ownerView);
        }];
    }
    return _ownerView;
}
- (UILabel *)userLabel
{
    if (!_userLabel)
    {
        _userLabel = [[UILabel alloc] init];
        _userLabel.font = kFont(kStandardPx(28));
        _userLabel.textColor = kTextBlackColor;
        _userLabel.text = @"其他成员";
    }
    return _userLabel;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.group.memberArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"ULGroupUsersTableViewCellIdentifier"];
    for (UIView *subview in cell.subviews)
    {
        [subview removeFromSuperview];
    }
    JMSGUser *user = self.group.memberArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:user.avatar]];
    imageView.layer.cornerRadius = 20;
    imageView.layer.masksToBounds = YES;
    [cell addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell).offset(15);
        make.centerY.equalTo(cell);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.font = kFont(kStandardPx(28));
    nameLabel.textColor = kTextBlackColor;
    nameLabel.text = user.username;
    [cell addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView.mas_right).offset(14);
        make.centerY.equalTo(cell);
    }];    UIView *line = [[UIView alloc] init];
    line.backgroundColor = kBackgroundColor;
    [cell addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(cell);
        make.height.mas_equalTo(0.5);
    }];
    return cell;
}
@end
