//
//  ULLabObjectDetailView.m
//  U-Lab
//
//  Created by 周维康 on 2017/6/9.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULLabObjectUseDetailView.h"
#import "ULUserObjectModel.h"

@interface ULLabObjectUseDetailView() <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *imageView;  /**< 图片 */
@property (nonatomic, strong) UITableView *tableView;  /**< 详情列表 */
@property (nonatomic, strong) UIButton *useButton;  /**< 使用按钮 */
@property (nonatomic, strong) UIImageView *bottomView;  /**< 底部花篮 */
@property (nonatomic, strong) UIScrollView *scrollView;  /**< 滑动背景板 */
@property (nonatomic, strong) ULUserObjectModel *objectModel;  /**< model */

@end

@implementation ULLabObjectUseDetailView
{
    NSArray *_detailArray;
    NSArray *_titleArray;
}

- (void)ul_setupViews
{
    NSString *share = self.objectModel.isShared ? @"共享" : @"未共享";
    _titleArray = @[@"编号：", @"管理员：", @"联系方式：", @"位置：", @"名称：", @"数量：", @"单位：", @"规格：", @"单价金额：", @"厂家：", @"经销商：", @"售后电话：", @"共享状态："];
    _detailArray = @[@(self.objectModel.labId), self.objectModel.ownerName, self.objectModel.contactNumber, self.objectModel.objectLocation, self.objectModel.objectName, @(self.objectModel.objectQuantity), self.objectModel.measureUnit, self.objectModel.specification, @(self.objectModel.price), self.objectModel.factory, self.objectModel.dealer, self.objectModel.servicePhone, share];
    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.tableView];
    [self.scrollView addSubview:self.imageView];
    [self.scrollView addSubview:self.useButton];
    [self addSubview:self.bottomView];
}

- (void)updateConstraints
{
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self).offset(64+18);
        make.height.mas_equalTo(screenHeight-64-33-18);
    }];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.scrollView);
        make.height.mas_offset(88);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.imageView.mas_bottom);
        make.height.mas_equalTo(_titleArray.count*45);
    }];
    [self.useButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableView.mas_bottom).offset(54);
        make.centerX.equalTo(self);
        make.left.equalTo(self).offset(15);
        make.height.mas_equalTo(45);
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(33);
    }];
    [super updateConstraints];
}
- (UIView *)imageView
{
    if (!_imageView)
    {
        _imageView = [[UIView alloc] init];
        _imageView.backgroundColor = kCommonWhiteColor;
        UILabel *label = [[UILabel alloc] init];
        label.text = @"图片：";
        label.font = kFont(kStandardPx(30));
        label.textColor = KTextGrayColor;
        [_imageView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_imageView).offset(15);
            make.centerY.equalTo(_imageView);
        }];
        UIImageView *picImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@",self.objectModel.imageURL]]]]];
        [_imageView addSubview:picImageView];
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_imageView.mas_right).offset(-15);
            make.centerY.equalTo(_imageView);
            make.size.mas_equalTo(CGSizeMake(50, 50));
        }];
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = kBackgroundColor;
        [_imageView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(_imageView);
            make.height.mas_equalTo(0.5);
        }];
    }
    return _imageView;
}

- (UIScrollView *)scrollView
{
    if (!_scrollView)
    {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.contentSize = CGSizeMake(screenWidth, _titleArray.count*45+88+164);
    }
    return _scrollView;
}

- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] init];
        _tableView.rowHeight = 45;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ULLabObjectDetailTableViewCellIdentifier"];
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

- (UIButton *)useButton
{
    if (!_useButton)
    {
        _useButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _useButton.backgroundColor = KButtonBlueColor;
        [_useButton setTitle:@"登记使用" forState:UIControlStateNormal];
        [_useButton setTitleColor:kCommonWhiteColor forState:UIControlStateNormal];
        
    }
    return _useButton;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _detailArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"ULLabObjectDetailTableViewCellIdentifier"];
    for (UIView *subview in cell.subviews)
    {
        [subview removeFromSuperview];
    }
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = _titleArray[indexPath.row];
    nameLabel.textColor = kTextBlackColor;
    nameLabel.font = kFont(kStandardPx(28));
    [cell addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell).offset(15);
        make.centerY.equalTo(cell);
    }];
    UILabel *detailLabel = [[UILabel alloc] init];
    NSString *detailString = _detailArray[indexPath.row];
    detailLabel.textColor = kTextBlackColor;
    detailLabel.text = detailString;
    detailLabel.font = kFont(kStandardPx(28));
    [cell addSubview:detailLabel];
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(cell).offset(-15);
        make.centerY.equalTo(cell);
    }]; UIView *line = [[UIView alloc] init];
    line.backgroundColor = kBackgroundColor;
    [cell addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.and.left.and.right.equalTo(cell);
        make.height.mas_equalTo(0.5);
    }];
    return cell;
}
@end
