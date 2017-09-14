//
//  ULMessageFriendSearchResultView.m
//  ULab
//
//  Created by 周维康 on 2017/6/10.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULMessageFriendSearchResultView.h"
#import "ULMessageFriendViewModel.h"
#import "ULMessageGroupDetailViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ULMessageFriendSearchResultView() <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, copy) NSString *searchString;  /**< 搜索字 */
@property (nonatomic, strong) UILabel *searchLabel;  /**< 搜索标签 */
@property (nonatomic, strong) UITableView *tableView;  /**< 列表 */
@property (nonatomic, strong) UIImageView *bottomView;  /**< 底部花篮 */
@property (nonatomic, strong) ULMessageFriendViewModel *viewModel;  /**< vm */

@end
@implementation ULMessageFriendSearchResultView
{
    NSArray *_friendArray;
}

- (instancetype)initWithKey:(NSString *)key labArray:(NSArray *)array
{
    self.searchString = key;
    _friendArray = array;
    self = [super init];
    return self;
}

- (void)ul_bindViewModel
{

}
- (void)ul_setupViews
{
    self.nextSubject = [RACSubject subject];
    self.viewModel = [[ULMessageFriendViewModel alloc] init];
    [self addSubview:self.searchLabel];
    [self addSubview:self.tableView];
    [self addSubview:self.bottomView];
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

- (void)updateConstraints
{
    [self.searchLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.top.equalTo(self).offset(70);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self).offset(84);
        make.bottom.equalTo(self).offset(-33);
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self);
        make.height.mas_equalTo(33);
    }];
    [super updateConstraints];
}

- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = kBackgroundColor;
        _tableView.rowHeight = 88;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ULMessageFriendSearchTableViewCellIdentifier"];
    }
    return _tableView;
}

- (UILabel *)searchLabel
{
    if (!_searchLabel)
    {
        _searchLabel = [[UILabel alloc] init];
        _searchLabel.font = kFont(kStandardPx(20));
        _searchLabel.textColor = KTextGrayColor;
        _searchLabel.text = [NSString stringWithFormat:@"”%@“的搜索结果", self.searchString];
    }
    return _searchLabel;
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
    if (_friendArray.count != 0)
    {
        NSArray* array = _friendArray[1];
        return array.count;
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"ULMessageFriendSearchTableViewCellIdentifier"];
    for (UIView *subView in cell.subviews)
    {
        [subView removeFromSuperview];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIImageView *imageView;
    if ([_friendArray[0]  isEqual: @0])
    {
        JMSGUser *model = _friendArray[1][indexPath.row];
        imageView = [[UIImageView alloc] init];
        [imageView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"ulab_user_default"]];
    } else {
        imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithColor:kCommonGrayColor]];
    }

    imageView.layer.masksToBounds = YES;
    imageView.layer.cornerRadius = 25.5;
    [cell addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(51, 51));
        make.left.equalTo(cell).offset(15);
        make.centerY.equalTo(cell);
    }];
    UILabel *nameLabel = [[UILabel alloc] init];
    if ([_friendArray[0]  isEqual: @0])
    {
        JMSGUser *model = _friendArray[1][indexPath.row];
        nameLabel.text = model.nickname;
    } else {
        JMSGGroup *model = _friendArray[1][indexPath.row];
        nameLabel.text = model.name;
    }
    nameLabel.textColor = [UIColor blackColor];
    nameLabel.font = kFont(kStandardPx(34));
    [cell addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView.mas_right).offset(17);
        make.top.equalTo(cell).offset(21);
        make.centerY.equalTo(cell);
    }];
    
//    UILabel *detailLabel = [[UILabel alloc] init];
//    if ([_friendArray[0]  isEqual: @0])
//    {
//        JMSGUser *model = _friendArray[1][indexPath.row];
//        detailLabel.text = model.username;
//    } else {
//        JMSGGroup *model = _friendArray[1][indexPath.row];
//        detailLabel.text = model.desc;
//    }
//    detailLabel.textColor = [UIColor blackColor];
//    detailLabel.font = kFont(kStandardPx(32));
//    [cell addSubview:detailLabel];
//    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(imageView.mas_right).offset(17);
//        make.bottom.equalTo(cell).offset(-20);
//    }];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundColor:KButtonBlueColor];
    button.layer.cornerRadius = 5;
    button.layer.masksToBounds = YES;
    [button setTitle:@"添加" forState:UIControlStateNormal];
    if ([_friendArray[0]  isEqual: @0])
    {
        JMSGUser *model = _friendArray[1][indexPath.row];
        @weakify(self)
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self)
            [ULProgressHUD showWithMsg:@"添加中" inView:self withBlock:^{
                [self.viewModel.addFriendCommand execute:[NSString stringWithFormat:@"%@", model.username]];
            }];
            
        }];
        [button setTitleColor:kCommonWhiteColor forState:UIControlStateNormal];
        [cell addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell);
            make.right.equalTo(cell).offset(-15);
            make.size.mas_equalTo(CGSizeMake(75, 30));
        }];

    } else {
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_friendArray[0] isEqual:@1])
    {
        JMSGGroup *model = _friendArray[1][indexPath.row];
        [self.nextSubject sendNext:model];
        
    }
}
@end
