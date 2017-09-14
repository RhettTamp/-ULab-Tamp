//
//  ULUserLabDetailView.m
//  ULab
//
//  Created by 周维康 on 2017/6/12.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULUserLabDetailView.h"
#import "ULUserLabModel.h"

@interface ULUserLabDetailView() <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;  /**< tb */
@property (nonatomic, strong) UIImageView *bottomView;  /**< imageview */
@property (nonatomic, strong) ULUserLabModel *model;  /**< model */

@end

@implementation ULUserLabDetailView
{
    NSArray *_leftArray;
    NSArray *_rightArray;
}

- (instancetype)initWithLabModel:(ULUserLabModel *)labModel
{
    self.model = labModel;
    if (self = [super init])
    {
        
    }
    return self;
}

- (void)uploadWithModel:(ULUserLabModel *)model{
    self.model = model;
    _rightArray = @[self.model.labName?self.model.labName:@"", self.model.labTime?self.model.labTime:@"", self.model.labMain?self.model.labMain:@"", self.model.labIntro?self.model.labIntro:@"", self.model.labDifficult?self.model.labDifficult:@""];
    [self.tableView reloadData];
}

- (void)ul_setupViews
{
    _leftArray = @[@"实验名称：", @"实验时间：", @"研究要点：", @"研究内容：", @"实验难点："];
    _rightArray = @[self.model.labName?self.model.labName:@"", self.model.labTime?self.model.labTime:@"", self.model.labMain?self.model.labMain:@"", self.model.labIntro?self.model.labIntro:@"", self.model.labDifficult?self.model.labDifficult:@""];
    self.backgroundColor = kBackgroundColor;
    [self addSubview:self.tableView];
    [self addSubview:self.bottomView];
    [self updateFocusIfNeeded];
    [self setNeedsUpdateConstraints];
}

//
//- (void)ul_bindViewModel
//{
//    self.viewModel = [[ULUserLabViewModel alloc] init];
//    @weakify(self)
//    [ULProgressHUD showWithMsg:@"获取数据中" withBlock:^{
//        @strongify(self)
//        [self.viewModel.getCommand execute:nil];
//    }];
//
//    [self.viewModel.getSubject subscribeNext:^(id x) {
//        @strongify(self)
//        _projectArray = x;
//        [self.tableView reloadData];
//        [ULProgressHUD hide];
//    }];
//
//    [self.viewModel.getSubject subscribeError:^(NSError *error) {
//        [ULProgressHUD hide];
//        [ULProgressHUD showWithMsg:@"请求失败"];
//    }];
//}
- (void)updateConstraints
{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(64+18);
        make.left.right.equalTo(self);
        make.bottom.equalTo(self).offset(-33);
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

- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = kBackgroundColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 45;
        _tableView.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0);
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ULUserLabDetailTableViewCellIdentifier"];
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _leftArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"ULUserLabDetailTableViewCellIdentifier"];
    for (UIView *subView in cell.subviews)
    {
        [subView removeFromSuperview];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = kCommonWhiteColor;
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.font = kFont(kStandardPx(34));
    nameLabel.textColor = kTextBlackColor;
    nameLabel.text = _leftArray[indexPath.row];
    [cell addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell);
        make.left.equalTo(cell).offset(15);
    }];
    UILabel *introLabel = [[UILabel alloc] init];
    introLabel.font = kFont(kStandardPx(26));
    introLabel.textColor = KTextGrayColor;
    introLabel.text = _rightArray[indexPath.row];
    [cell addSubview:introLabel];
    [introLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(cell).offset(-15);
        make.centerY.equalTo(cell);
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

@end
