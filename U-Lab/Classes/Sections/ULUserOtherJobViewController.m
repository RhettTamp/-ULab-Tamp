//
//  ULUserOtherJobViewController.m
//  ULab
//
//  Created by 周维康 on 2017/6/19.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULUserOtherJobViewController.h"
#import "ULUserJobViewModel.h"
#import "ULUserJobModel.h"
#import "ULLabMemberModel.h"
#import "ULUserJobChangeViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ULUserOtherJobDetailViewController.h"

@interface ULUserOtherJobViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *array;  /**< array */
@property (nonatomic, strong) UITableView *tableView;  /**< tableView */
@property (nonatomic, strong) UIImageView *bottomView;  /**< bottomView */
@property (nonatomic, strong) ULUserJobViewModel *viewModel;  /**< vm */
@end

@implementation ULUserOtherJobViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (instancetype)init
{
    self.viewModel = [[ULUserJobViewModel alloc] init];
    if (self = [super init])
    {
        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)ul_layoutNavigation
{
    self.title = @"他人工作";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];  
}

- (void)ul_addSubviews
{
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomView];
    [self.view setNeedsUpdateConstraints];
    [self.view updateConstraintsIfNeeded];
}

- (void)ul_bindViewModel
{
    [ULProgressHUD showWithMsg:@"获取中" inView:self.view withBlock:^{
//        @strongify(self)
    [self.viewModel.otherCommand execute:@{
                                               @"labId" : @([ULUserMgr sharedMgr].laboratoryId)
                                               }];
    }];
    @weakify(self)
    [self.viewModel.otherSubject subscribeNext:^(id x) {
        @strongify(self)
        self.array = x;
        [self.tableView reloadData];
    }];
    
}
- (void)updateViewConstraints
{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-33);
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        make.height.mas_equalTo(33);
    }];
    [super updateViewConstraints];
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
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ULUserOtherJobTableViewCellIdentifier"];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"ULUserOtherJobTableViewCellIdentifier"];
    for (UIView *subView in cell.subviews)
    {
        [subView removeFromSuperview];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    ULLabMemberModel *model = self.array[indexPath.row];
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView sd_setImageWithURL:[NSURL URLWithString:model.headImage] placeholderImage:[UIImage imageNamed:@"ulab_user_default"]];
    imageView.layer.masksToBounds = YES;
    imageView.layer.cornerRadius = 25.5;
    [cell addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell).offset(15);
        make.size.mas_equalTo(CGSizeMake(51, 51));
        make.centerY.equalTo(cell);
    }];
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = model.memberName;
    nameLabel.textColor = [UIColor blackColor];
    nameLabel.font = kFont(kStandardPx(34));
    [cell addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView.mas_right).offset(17);
        make.top.equalTo(cell).offset(21);
    }];
    UILabel *detailLabel = [[UILabel alloc] init];
    detailLabel.textColor = KTextGrayColor;
    detailLabel.font = kFont(kStandardPx(28));
    [cell addSubview:detailLabel];
    detailLabel.text = model.labName;
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLabel);
        make.top.equalTo(nameLabel.mas_bottom).offset(13);
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
    ULLabMemberModel *model = self.array[indexPath.row];
    ULUserOtherJobDetailViewController *vc = [[ULUserOtherJobDetailViewController alloc]initWithUserId:model.memberId andUserName:model.memberName];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
