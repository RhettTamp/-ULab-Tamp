//
//  ULUserJobView.m
//  U-Lab
//
//  Created by 周维康 on 2017/6/7.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULUserJobView.h"
#import "ULUserJobModel.h"
#import "ULUserJobViewModel.h"

@interface ULUserJobView() <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;  /**< 列表 */
@property (nonatomic, strong) UIImageView *bottomView;  /**< 底部花篮 */
@property (nonatomic, strong) ULUserJobViewModel *viewModel;  /**< vm */
@property (nonatomic, strong) UILabel *otherLabel;  /**< taren */
@property (nonatomic, strong) UIButton *otherButton;  /**< 查看他人 */

@end

@implementation ULUserJobView
{
    NSMutableArray *_jobArray;
}

- (void)ul_setupViews
{
    _jobArray = [NSMutableArray array];
    self.nextSubject = [RACSubject subject];
    self.backgroundColor = kBackgroundColor;
    [self addSubview:self.tableView];
    [self addSubview:self.bottomView];
    [self updateConstraintsIfNeeded];
    [self setNeedsUpdateConstraints];
}

- (void)updateConstraints
{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(84);
        make.left.right.equalTo(self);
        make.bottom.equalTo(self).offset(-33);
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(33);
    }];
    [super updateConstraints];
}

- (void)ul_bindViewModel
{
    [ULProgressHUD showWithMsg:@"数据获取中" inView:self withBlock:^{
        [self.viewModel.jobCommand execute:nil];
    }];
    @weakify(self)
    [self.viewModel.jobSubject subscribeNext:^(id x) {
        @strongify(self)
        [ULProgressHUD hide];
        [_jobArray removeAllObjects];
        [_jobArray addObjectsFromArray:x];
        if ([[ULUserMgr sharedMgr].role integerValue] != 0)
        {
            [_jobArray addObject:@"其他成员工作"];
            [_jobArray addObject:@"查看其他成员工作"];
        }
        [self.tableView reloadData];
    }];
    [self.updateViewSubject subscribeNext:^(id x) {
        [self.viewModel.jobCommand execute:nil];
    }];
    [self.updateViewSubject subscribeError:^(NSError *error) {
        [ULProgressHUD hide];
        [ULProgressHUD showWithMsg:@"请求失败" inView:self];
    }];
}

- (ULUserJobViewModel *)viewModel
{
    if (!_viewModel)
    {
        _viewModel = [[ULUserJobViewModel alloc] init];
    }
    return _viewModel;
}

- (RACSubject *)updateViewSubject
{
    if (!_updateViewSubject)
    {
        _updateViewSubject = [RACSubject subject];
    }
    return _updateViewSubject;
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
        _tableView.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0);
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ULUserJobTableViewCellIdentifier"];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        return _jobArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"ULUserJobTableViewCellIdentifier"];
    for (UIView *subview in cell.subviews)
    {
        [subview removeFromSuperview];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.font = kFont(kStandardPx(28));
    nameLabel.textColor = kTextBlackColor;
    [cell addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell).offset(15);
        make.centerY.equalTo(cell);
    }];
    
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.textColor = KTextGrayColor;
    timeLabel.font = kFont(kStandardPx(24));
    [cell addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(cell).offset(-15);
        make.centerY.equalTo(cell);
    }];
    if ([[ULUserMgr sharedMgr].role integerValue] != 0 && (indexPath.row ==_jobArray.count-2||indexPath.row == _jobArray.count-1))
    {
        nameLabel.text = _jobArray[indexPath.row];
        if (indexPath.row==_jobArray.count-1)
        {
            cell.backgroundColor = kCommonWhiteColor;
            nameLabel.textColor = kTextBlackColor;
            UIImageView *next = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_user_next"]];
            [cell addSubview:next];
            [next mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(cell).offset(-20);
                make.centerY.equalTo(cell);
                make.size.mas_equalTo(CGSizeMake(10, 15));
            }];
        } else {
            nameLabel.textColor = kCommonGrayColor;
            cell.backgroundColor = kBackgroundColor;
        }
    } else {
        ULUserJobModel *model = _jobArray[indexPath.row];
        nameLabel.text = model.jobTitle;
        timeLabel.text = model.jobTime;
        cell.backgroundColor = kCommonWhiteColor;
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
    if ([[ULUserMgr sharedMgr].role integerValue] != 0) {
        if (indexPath.row == _jobArray.count-1){
            [self.nextSubject sendNext:nil];
        } else if (indexPath.row != _jobArray.count-2) {
            [self.nextSubject sendNext:_jobArray[indexPath.row]];
        }
    }else{
        [self.nextSubject sendNext:_jobArray[indexPath.row]];
    }
}
@end
