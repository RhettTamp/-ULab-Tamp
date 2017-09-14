//
//  ULSettingView.m
//  U-Lab
//
//  Created by 周维康 on 17/5/24.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULSettingView.h"

@interface ULSettingView()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *mainTableView;  /**< 主列表 */
@property (nonatomic, strong) UIImageView *bottomView;  /**< 底部花篮 */

@end

@implementation ULSettingView
{
    NSArray *_funcArray;
    NSArray *_statusArray;
}

- (void)ul_setupViews
{
    self.aboutSubject = [RACSubject subject];
    self.backgroundColor = kBackgroundColor;
    _funcArray = @[@"语言选择：", @"帐号管理：", @"帮助"];
    _statusArray = @[@"中文", @"", @""];
    [self addSubview:self.mainTableView];
    [self addSubview:self.bottomView];
    [self updateConstraintsIfNeeded];
    [self setNeedsUpdateConstraints];
}

- (void)updateConstraints
{
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(15);
        make.bottom.equalTo(self).offset(-33);
        make.left.right.equalTo(self);
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(33);
    }];
    [super updateConstraints];
}

- (UITableView *)mainTableView
{
    if (!_mainTableView)
    {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.scrollEnabled = NO;
        _mainTableView.backgroundColor = kBackgroundColor;
        [_mainTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ULSettingMainTableViewCellIdentifier"];
    }
    return _mainTableView;
}

- (UIImageView *)bottomView
{
    if (!_bottomView)
    {
        _bottomView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"register_bottom"]];
    }
    return _bottomView;
}
#pragma mark - UITableViewDelegate & datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _funcArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.aboutSubject sendNext:@(indexPath.row)];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.mainTableView dequeueReusableCellWithIdentifier:@"ULSettingMainTableViewCellIdentifier"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UILabel *funcLabel = [[UILabel alloc] init];
    funcLabel.font = kFont(kStandardPx(30));
    funcLabel.text = _funcArray[indexPath.row];
    funcLabel.textColor = KTextGrayColor;
    [cell addSubview:funcLabel];
    [funcLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell).offset(15);
        make.centerY.equalTo(cell);
    }];
    UILabel *statusLabel = [[UILabel alloc] init];
    statusLabel.textColor = KTextGrayColor;
    statusLabel.text = _statusArray[indexPath.row];
    statusLabel.font = kFont(kStandardPx(30));
    [cell addSubview:statusLabel];
    [statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(cell).offset(-15);
        make.centerY.equalTo(cell);
    }];
    if (indexPath.row >=1)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_user_next"]];
        [cell addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(cell).offset(-15);
            make.centerY.equalTo(cell);
            make.size.mas_equalTo(CGSizeMake(10, 15));
        }];
    }
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = kBackgroundColor;
    [cell addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(cell);
        make.height.mas_equalTo(0.5);
    }];
    return cell;
}

@end
