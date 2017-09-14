//
//  ULLabSearchResultView.m
//  U-Lab
//
//  Created by 周维康 on 2017/6/3.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULLabSearchResultView.h"
#import "ULLabModel.h"
#import "ULSearchLabViewModel.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ULLabSearchResultView() <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, copy) NSString *searchString;  /**< 搜索字 */
@property (nonatomic, strong) UILabel *searchLabel;  /**< 搜索标签 */
@property (nonatomic, strong) UITableView *tableView;  /**< 列表 */
@property (nonatomic, strong) UIImageView *bottomView;  /**< 底部花篮 */
@property (nonatomic, strong) ULSearchLabViewModel *viewModel;  /**< VM */
@property (nonatomic, assign) NSInteger type;

@end
@implementation ULLabSearchResultView
{
    NSArray *_labArray;
}

- (instancetype)initWithKey:(NSString *)key labArray:(NSArray *)array andType:(NSInteger)type
{
    self.searchString = key;
    _labArray = array;
    self.type = type;
    self = [super init];
    return self;
}
- (void)ul_setupViews
{
    self.viewModel = [[ULSearchLabViewModel alloc] init];
    self.nextObject = [[RACSubject alloc]init];
    [self addSubview:self.searchLabel];
    [self addSubview:self.tableView];
    [self addSubview:self.bottomView];
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

- (void)ul_bindViewModel{
    [self.viewModel.addSubject subscribeNext:^(id x) {
        
    }];
}

- (void)updateConstraints
{
    [self.searchLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.top.equalTo(self).offset(70);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self).offset(88);
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
        _tableView.rowHeight = 120;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ULLabSearchResultTableViewCellIdentifier"];
    }
    return _tableView;
}

- (UILabel *)searchLabel
{
    if (!_searchLabel)
    {
        _searchLabel = [[UILabel alloc] init];
        _searchLabel.font = kFont(kStandardPx(25));
        _searchLabel.textColor = KTextGrayColor;
        _searchLabel.text = [NSString stringWithFormat:@"🔍 “%@” 的搜索结果", self.searchString];
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
    return _labArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"ULLabSearchResultTableViewCellIdentifier"];
    for (UIView *subView in cell.subviews)
    {
        [subView removeFromSuperview];
    }
    ULLabModel *model = _labArray[indexPath.row];
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView sd_setImageWithURL:[NSURL URLWithString:model.labImage] placeholderImage:[UIImage imageNamed:@"ulab_lab_default"]];
    imageView.layer.masksToBounds = YES;
    imageView.layer.cornerRadius = 25.5;
    [cell addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(51, 51));
        make.left.equalTo(cell).offset(15);
        make.centerY.equalTo(cell);
    }];
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = model.labName;
    nameLabel.textColor = [UIColor blackColor];
    nameLabel.font = kFont(kStandardPx(34));
    nameLabel.adjustsFontSizeToFitWidth = YES;
    [cell addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView.mas_right).offset(17);
        make.top.equalTo(cell).offset(21);
        make.right.equalTo(cell).offset(-100);
    }];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundColor:KButtonBlueColor];
    button.layer.cornerRadius = 5;
    button.layer.masksToBounds = YES;
    [button setTitle:@"申请" forState:UIControlStateNormal];
    [button setTitleColor:kCommonWhiteColor forState:UIControlStateNormal];
    [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @weakify(self)
        if (self.type == 0) {
            [ULProgressHUD showWithMsg:@"申请中" inView:self withBlock:^{
                @strongify(self)
                [self.viewModel.addCommand execute:@{
                                                     @"labId" : @(model.labID)
                                                     }];
                [button setTitle:@"已申请" forState:UIControlStateNormal];
                button.backgroundColor = kCommonGrayColor;
                button.enabled = NO;
            }];
        }else{
            [ULProgressHUD showWithMsg:@"申请中" inView:self withBlock:^{
                @strongify(self)
                [self.viewModel.addFriendCommand execute:@{
                                                     @"destLabId" : @(model.labID)
                                                     }];
                [button setTitle:@"已申请" forState:UIControlStateNormal];
                button.backgroundColor = kCommonGrayColor;
                button.enabled = NO;
            }];
        }
        
    }];
    [cell addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell);
        make.right.equalTo(cell).offset(-15);
        make.size.mas_equalTo(CGSizeMake(75, 30));
    }];
    
    UILabel *detailLabel = [[UILabel alloc] init];
    NSString *detailString = [NSString stringWithFormat:@"研究方向：%@", model.labResearch?:@"未填写"];
    detailLabel.textColor = KTextGrayColor;
    detailLabel.text = detailString;
    detailLabel.font = kFont(kStandardPx(28));
    detailLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [cell addSubview:detailLabel];
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLabel);
        make.top.equalTo(nameLabel.mas_bottom).offset(13);
        make.right.equalTo(button.mas_left).offset(-10);
    }];
    
    UILabel *siteLable = [[UILabel alloc]init];
    siteLable.textColor = kCommonBlueColor;
    siteLable.text = model.labLocation;
    siteLable.font = kFont(kStandardPx(25));
    siteLable.numberOfLines = 0;
    [cell addSubview:siteLable];
    [siteLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(detailLabel).offset(15);
        make.top.equalTo(detailLabel.mas_bottom).offset(10);
        make.width.mas_lessThanOrEqualTo(150.0*screenWidth/375);
    }];
    UIImageView *siteImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"site"]];
    [cell addSubview:siteImage];
    [siteImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(detailLabel);
        make.centerY.equalTo(siteLable);
        make.width.mas_equalTo(8);
        make.height.mas_equalTo(10);
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.nextObject sendNext:_labArray[indexPath.row]];
}
@end
