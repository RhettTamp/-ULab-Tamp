//
//  ULLabView.m
//  U-Lab
//
//  Created by 周维康 on 17/5/23.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULLabView.h"

@interface ULLabView()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *whiteView;  /**< 白色背景板呢 */
@property (nonatomic, strong) UIImageView *headerImageView;  /**< 头像 */
@property (nonatomic, strong) UITableView *mainTableView;  /**< 主视图 */
@property (nonatomic, strong) UILabel *nameLabel;  /**< 名字 */
@property (nonatomic, strong) UILabel *piLabel;  /**< PI */
@property (nonatomic, strong) UILabel *degreeLabel;  /**< 积分 */
@property (nonatomic, strong) UIView *friendNewsView;

@end

@implementation ULLabView
{
    NSArray *_imageArray;
    NSArray *_nameArray;
}

- (void)updateLabView
{
    if ([[ULUserMgr sharedMgr].role isEqual:@0])
    {
        _imageArray = @[@"lab_labMsg", @"lab_peopleMsg", @"lab_object", @"lab_friendLab"];
        _nameArray = @[@"实验室信息", @"人员信息", @"物品信息", @"友好实验室"];
        
    } else {
        _imageArray = @[@"lab_labMsg", @"lab_peopleMsg", @"lab_object", @"lab_friendLab", @"lab_finance"];
        _nameArray = @[@"实验室信息", @"人员信息", @"物品信息", @"友好实验室", @"财务管理"];
    }
    if ([ULUserMgr sharedMgr].labImage)
    {
        self.headerImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[ULUserMgr sharedMgr].labImage]]]];
        
    } else {
        self.headerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ulab_lab_default"]];
    }
    self.nameLabel.text = [ULUserMgr sharedMgr].laboratoryName;
    self.piLabel.text = [NSString stringWithFormat:@"P I:%@", [ULUserMgr sharedMgr].labPiName];
    self.degreeLabel.text = [NSString stringWithFormat:@"积分:%lu", [ULUserMgr sharedMgr].score];
    [self.mainTableView reloadData];
}

- (void)ul_setupViews
{
    if ([[ULUserMgr sharedMgr].role isEqual:@0])
    {
        _imageArray = @[@"lab_labMsg", @"lab_peopleMsg", @"lab_object", @"lab_friendLab"];
        _nameArray = @[@"实验室信息", @"人员信息", @"物品信息", @"友好实验室"];
        
    } else {
        _imageArray = @[@"lab_labMsg", @"lab_peopleMsg", @"lab_object", @"lab_friendLab", @"lab_finance"];
        _nameArray = @[@"实验室信息", @"人员信息", @"物品信息", @"友好实验室", @"财务管理"];
    }
    self.backgroundColor = kBackgroundColor;
    [self addSubview:self.whiteView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.headerImageView];
    [self addSubview:self.piLabel];
    [self addSubview:self.degreeLabel];
    [self addSubview:self.mainTableView];
    [self updateConstraintsIfNeeded];
    [self setNeedsUpdateConstraints];
}

- (void)updateConstraints
{
    [self.whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(100);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(120);
    }];
    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(16);
        make.top.equalTo(self.whiteView).offset(41);
        make.size.mas_equalTo(CGSizeMake(65, 65));
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerImageView.mas_right).offset(17);
        make.top.equalTo(self.whiteView).offset(40);
    }];
    [self.piLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(16);
    }];
    [self.degreeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.piLabel.mas_right).offset(45);
        make.top.equalTo(self.piLabel);
    }];
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.whiteView.mas_bottom).offset(24);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(45*_imageArray.count);
    }];
    [super updateConstraints];
}

- (UIImageView *)headerImageView
{
    if (!_headerImageView)
    {
        if ([ULUserMgr sharedMgr].labImage)
        {
            _headerImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[ULUserMgr sharedMgr].labImage]]]];

        } else {
            _headerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ulab_lab_default"]];
        }
                _headerImageView.layer.cornerRadius = 65/2;
        _headerImageView.layer.masksToBounds = YES;
    }
    return _headerImageView;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel)
    {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = [ULUserMgr sharedMgr].laboratoryName;
        _nameLabel.font = kFont(kStandardPx(34));
    }
    return _nameLabel;
}

- (UILabel *)piLabel
{
    if (!_piLabel)
    {
        _piLabel = [[UILabel alloc] init];
        _piLabel.text = [NSString stringWithFormat:@"P I:%@", [ULUserMgr sharedMgr].labPiName];
        _piLabel.textColor = KTextGrayColor;
        _piLabel.font = kFont(kStandardPx(26));
    }
    return _piLabel;
}

- (UILabel *)degreeLabel
{
    if (!_degreeLabel)
    {
        _degreeLabel = [[UILabel alloc] init];
        _degreeLabel.textColor = KTextGrayColor;
        _degreeLabel.text = [NSString stringWithFormat:@"积分:%lu", [ULUserMgr sharedMgr].score];
        _degreeLabel.font = kFont(kStandardPx(26));
    }
    return _degreeLabel;
}

- (UITableView *)mainTableView
{
    if (!_mainTableView)
    {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.rowHeight = 45.5;
        _mainTableView.scrollEnabled = NO;
        [_mainTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ULLabMainTableViewCellIdentifier"];
    }
    return _mainTableView;
}

- (void)setIsShowNewsView:(BOOL)isShowNewsView{
    _isShowNewsView = isShowNewsView;
    self.friendNewsView.hidden = !isShowNewsView;
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

- (RACSubject *)nextControllerSubject
{
    if (!_nextControllerSubject)
    {
        _nextControllerSubject = [RACSubject subject];
    }
    return _nextControllerSubject;
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _imageArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.mainTableView dequeueReusableCellWithIdentifier:@"ULLabMainTableViewCellIdentifier"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:_imageArray[indexPath.row]]];
    [cell addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell);
        make.left.equalTo(cell).offset(16);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    UILabel *label = [[UILabel alloc] init];
    label.text = _nameArray[indexPath.row];
    label.font = kFont(kStandardPx(30));
    label.textColor = KTextGrayColor;
    [cell addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView.mas_right).offset(15);
        make.centerY.equalTo(cell);
    }];
    if (indexPath.row == 3) {
        UIView *redView = [[UIView alloc]init];
        redView.backgroundColor = [UIColor redColor];
        redView.layer.cornerRadius = 5;
        [cell addSubview:redView];
        [redView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(label.mas_right).offset(8);
            make.top.mas_offset(8);
            make.size.mas_equalTo(10);
        }];
        redView.hidden = YES;
        self.friendNewsView = redView;
    }
    UIImageView *next = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_user_next"]];
    [cell addSubview:next];
    [next mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(cell).offset(-20);
        make.centerY.equalTo(cell);
        make.size.mas_equalTo(CGSizeMake(10, 15));
    }];
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = kBackgroundColor;
    [cell addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(cell);
        make.height.mas_equalTo(0.5);
    }];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.nextControllerSubject sendNext:[NSNumber numberWithInteger:indexPath.row]];
}
@end
