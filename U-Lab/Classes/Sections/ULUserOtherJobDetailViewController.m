//
//  ULUserOtherJobDetailViewController.m
//  ULab
//
//  Created by 谭培 on 2017/7/28.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULUserOtherJobDetailViewController.h"
#import "ULUserJobModel.h"
#import "ULUserJobViewModel.h"
#import "ULUserJobChangeViewController.h"

@interface ULUserOtherJobDetailViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;  /**< 列表 */
@property (nonatomic, strong) UIImageView *bottomView;  /**< 底部花篮 */
@property (nonatomic, strong) ULUserJobViewModel *viewModel;  /**< VM */

@end

@implementation ULUserOtherJobDetailViewController

{
    NSArray *_jobArray;
    NSInteger _userId;
    NSString *_userName;
}

- (instancetype)initWithUserId:(NSInteger)userId andUserName:(NSString *)userName
{
    _userId = userId;
    _userName = userName;
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [NSString stringWithFormat:@"%@的工作详情",_userName];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
}

- (void)ul_addSubviews{
    
    self.view.backgroundColor = kBackgroundColor;
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(84);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-33);
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(33);
    }];
    
}

- (void)ul_bindViewModel{
    self.viewModel = [[ULUserJobViewModel alloc]init];
    if (_userId) {
        [self.viewModel.otherJobCommand execute:@{@"otherId":@(_userId)}];
        [self.viewModel.otherJobSubject subscribeNext:^(id x) {
            _jobArray = x;
            [self.tableView reloadData];
        }];
    }
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
    ULUserJobModel *model = _jobArray[indexPath.row];
    nameLabel.text = model.jobTitle;
    timeLabel.text = model.jobTime;
    cell.backgroundColor = kCommonWhiteColor;
    
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
    ULUserJobChangeViewController *vc = [[ULUserJobChangeViewController alloc]initWithJob:_jobArray[indexPath.row] andType:0];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
