//
//  ULLabObjectUseDetailView.m
//  U-Lab
//
//  Created by 周维康 on 2017/6/9.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULLabObjectShareDetailView.h"
#import "ULUserObjectModel.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ULLabObjectShareDetailView() <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *imageView;  /**< 图片 */
@property (nonatomic, strong) UITableView *tableView;  /**< 详情列表 */
@property (nonatomic, strong) UIImageView *bottomView;  /**< 底部花篮 */
@property (nonatomic, strong) UIScrollView *scrollView;  /**< 滑动背景板 */
@property (nonatomic, strong) ULUserObjectModel *objectModel;  /**< model */

@end

@implementation ULLabObjectShareDetailView
{
    NSMutableArray *_detailArray;
    NSMutableArray *_titleArray;
}

- (instancetype)initWithModel:(ULUserObjectModel *)model
{
    self.objectModel = model;
    self = [super init];
    return self;
}
- (void)ul_setupViews
{
    NSString *share = self.objectModel.isShared ? @"共享" : @"未共享";
    _titleArray = [@[@"编号：",@"名称：", @"规格：", @"数量：", @"单位：",  @"位置：",@"厂家：", @"管理员：", @"联系方式：", @"单价金额：",  @"经销商：", @"售后电话：", @"共享状态："] mutableCopy];
    self.subject = [RACSubject subject];
    _detailArray = [@[[NSString stringWithFormat:@"%@",@(self.objectModel.labId)], self.objectModel.objectName?:@"",  self.objectModel.specification?:@"",  [NSString stringWithFormat:@"%@",@(self.objectModel.objectQuantity)?:@0],  self.objectModel.measureUnit?:@"", self.objectModel.objectLocation?self.objectModel.objectLocation:@"", self.objectModel.factory?:@"", [NSString stringWithFormat:@"%@", self.objectModel.ownerName?self.objectModel.ownerName:@""], self.objectModel.contactNumber?self.objectModel.contactNumber:@"", [NSString stringWithFormat:@"%@", @(self.objectModel.price)],  self.objectModel.dealer?:@"", self.objectModel.servicePhone?:@"", share] mutableCopy];
    if (self.objectModel.objectType == 3) {
        [_titleArray removeObjectAtIndex:2];
        [_detailArray removeObjectAtIndex:2];
    }
    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.tableView];
    [self.scrollView addSubview:self.imageView];
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
        make.height.mas_equalTo(_titleArray.count*45+120);
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
        }];UIImageView *picImageView;
        if (![self.objectModel.imageURL  isEqual: @""]){
            picImageView = [[UIImageView alloc] init];
            [picImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_objectModel.imageURL]] placeholderImage:[UIImage imageNamed:@"ulab_object_default"]];
        }
        else
            picImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ulab_object_default"]];
        [_imageView addSubview:picImageView];
        [picImageView mas_makeConstraints:^(MASConstraintMaker *make) {
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
        _scrollView.contentSize = CGSizeMake(screenWidth, _titleArray.count*45+88+120);
        _scrollView.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0);
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
        UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 120)];
        UILabel *bzLabel = [[UILabel alloc]init];
        bzLabel.text = @"备注:";
        bzLabel.textColor = kTextBlackColor;
        bzLabel.font = kFont(kStandardPx(30));
        [footerView addSubview:bzLabel];
        [bzLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(footerView).offset(15);
            make.top.equalTo(footerView).offset(10);
        }];
        UILabel *label = [[UILabel alloc]init];
        label.font = kFont(kStandardPx(30));
        label.textColor = kTextBlackColor;
        label.numberOfLines = 0;
        label.text = self.objectModel.objectDescription?:@"";
        [footerView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(bzLabel.mas_bottom).offset(20);
            make.left.equalTo(bzLabel);
        }];
        _tableView.tableFooterView = footerView;
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

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 120)];
//    UILabel *bzLabel = [[UILabel alloc]init];
//    bzLabel.text = @"备注";
//    [footerView addSubview:bzLabel];
//    [bzLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(footerView).offset(15);
//        make.top.equalTo(footerView).offset(8);
//    }];
//    UILabel *label = [[UILabel alloc]init];
//    label.text = self.objectModel.objectDescription?:@"";
//    [footerView addSubview:label];
//    [label mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(bzLabel.mas_bottom).offset(5);
//        make.left.equalTo(bzLabel);
//    }];
//    return footerView;
//}

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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
    }];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == _titleArray.count-1)
    {
        [self.subject sendNext:nil];
    }
}
@end
