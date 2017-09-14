//
//  ULHomeUserView.m
//  U-Lab
//
//  Created by 周维康 on 17/5/20.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULHomeUserView.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ULHomeUserView()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIImageView *backgroundImageView;  /**< 背景 */
@property (nonatomic, strong) UIImageView *headerImageView;  /**< 头像 */
@property (nonatomic, strong) UITableView *userTableView;  /**< 功能列表 */
@property (nonatomic, strong) UILabel *nameLabel;  /**< 用户名 */

@end
@implementation ULHomeUserView
{
    NSArray *_cellImageArray;
    NSArray *_cellNameArray;
    NSArray *_cellSizeArray;
}
- (void)ul_bindViewModel
{
    self.selectSubject = [RACSubject subject];
}
- (void)updateUserView
{
    self.nameLabel.text = [ULUserMgr sharedMgr].userName;
}
- (void)ul_setupViews
{
    _cellNameArray = @[@"我的资料", @"我的物品", @"我的订单", @"我的项目", @"今日工作", @"设置"];
    _cellSizeArray = @[[NSValue valueWithCGSize:CGSizeMake(16, 16.5)], [NSValue valueWithCGSize:CGSizeMake(16, 16)], [NSValue valueWithCGSize:CGSizeMake(18.5, 17)], [NSValue valueWithCGSize:CGSizeMake(17, 16.5)], [NSValue valueWithCGSize:CGSizeMake(14.5, 13)], [NSValue valueWithCGSize:CGSizeMake(16.5, 16.5)]];
    _cellImageArray = @[@"home_user_data", @"home_user_object", @"home_user_order", @"home_user_test", @"home_user_job", @"home_user_setting"];
    [self addSubview:self.backgroundImageView];
    [self addSubview:self.headerImageView];
    [self addSubview:self.userTableView];
    [self addSubview:self.nameLabel];
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

- (void)updateConstraints
{
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.top.equalTo(self);
        make.height.mas_equalTo(247);
    }];
    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self.backgroundImageView);
        make.size.mas_equalTo(CGSizeMake(89, 89));
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerImageView.mas_bottom).offset(18);
        make.centerX.equalTo(self);
    }];
    [self.userTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backgroundImageView.mas_bottom).offset(45);
        make.left.right.bottom.equalTo(self);
    }];
    [super updateConstraints];
}

- (UIImageView *)backgroundImageView
{
    if (!_backgroundImageView)
    {
        _backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_user_background"]];
    }
    return _backgroundImageView;
}

- (UIImageView *)headerImageView
{
    if (!_headerImageView)
    {
        _headerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ulab_user_default"]];
        if ([ULUserMgr sharedMgr].avaterImageUrl&&[ULUserMgr sharedMgr].avaterImage) {
            self.headerImageView.image = [ULUserMgr sharedMgr].avaterImage;
        }else if ([ULUserMgr sharedMgr].avaterImageUrl){
            [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:[ULUserMgr sharedMgr].avaterImageUrl] placeholderImage:[UIImage imageNamed:@"ulab_user_default"]];
        }else if ([ULUserMgr sharedMgr].avaterImage){
            self.headerImageView.image = [ULUserMgr sharedMgr].avaterImage;
        }
        _headerImageView.layer.cornerRadius = 44.5;
        _headerImageView.layer.masksToBounds = YES;
        [[[NSNotificationCenter defaultCenter] rac_addObserverForName:kUserAvatorImageDidChange object:nil] subscribeNext:^(id x) {
            if ([ULUserMgr sharedMgr].avaterImageUrl&&[ULUserMgr sharedMgr].avaterImage) {
                self.headerImageView.image = [ULUserMgr sharedMgr].avaterImage;
            }else if ([ULUserMgr sharedMgr].avaterImageUrl){
                [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:[ULUserMgr sharedMgr].avaterImageUrl] placeholderImage:[UIImage imageNamed:@"ulab_user_default"]];
            }else if ([ULUserMgr sharedMgr].avaterImage){
                self.headerImageView.image = [ULUserMgr sharedMgr].avaterImage;
            }
        }];
    }
    return _headerImageView;
}

- (UITableView *)userTableView
{
    if (!_userTableView)
    {
        _userTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _userTableView.delegate = self;
        _userTableView.dataSource = self;
        _userTableView.rowHeight = 44;
        _userTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _userTableView.backgroundColor = kCommonWhiteColor;
        _userTableView.scrollEnabled = NO;
        [_userTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ULHomeUserTableViewCellIdentifier"];
    }
    return _userTableView;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel)
    {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = [ULUserMgr sharedMgr].userName;
        _nameLabel.font = kFont(kStandardPx(32));
        _nameLabel.textColor = [UIColor colorWithRGBHex:0x2d3f68];
    }
    return _nameLabel;
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.userTableView dequeueReusableCellWithIdentifier:@"ULHomeUserTableViewCellIdentifier"];
    UIImageView *cellImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:_cellImageArray[indexPath.row]]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell addSubview:cellImageView];
    [cellImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell);
        make.size.mas_equalTo([_cellSizeArray[indexPath.row] CGSizeValue]);
        make.left.equalTo(cell).offset(16);
    }];
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = _cellNameArray[indexPath.row];
    [cell addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell);
        make.left.equalTo(cellImageView.mas_right).offset(8);
    }];
    UIImageView *line = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_user_line"]];
    [cell addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.and.left.and.right.equalTo(cell);
        make.height.mas_equalTo(0.5);
    }];
    UIImageView *next = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_user_next"]];
    [cell addSubview:next];
    [next mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(cell).offset(-20);
        make.centerY.equalTo(cell);
        make.size.mas_equalTo(CGSizeMake(10, 15));
    }];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _cellImageArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.selectSubject sendNext:[NSNumber numberWithInteger:indexPath.row]];
}
@end
