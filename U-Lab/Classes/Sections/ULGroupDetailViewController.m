//
//  ULGroupDetailViewController.m
//  ULab
//
//  Created by 周维康 on 2017/6/21.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULGroupDetailViewController.h"
#import "ULGroupUsersViewController.h"

@interface ULGroupDetailViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;  /**< 列表 */
@property (nonatomic, strong) UIImageView *bottomView;  /**< 底部花篮 */
@property (nonatomic, strong) UIView *detailView;  /**< <#comment#> */
@property (nonatomic, strong) NSString *gid;  /**< gid */
@property (nonatomic, strong) UILabel *descLabel;  /**< <#comment#> */
@property (nonatomic, strong) JMSGGroup *group;  /**< <#comment#> */

@end

@implementation ULGroupDetailViewController
{
    NSArray *_nameArray;
    NSArray *_detailArray;
}

- (instancetype)initWithGroupId:(NSString *)gid
{
    self.gid = gid;
    self = [super init];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    @weakify(self)
    [JMSGGroup groupInfoWithGroupId:self.gid completionHandler:^(id resultObject, NSError *error) {
        if (!error) {
            @strongify(self)
            JMSGGroup *group = (JMSGGroup *)resultObject;
            self.group = group;
            _detailArray = @[group.name, group.owner, [NSString stringWithFormat:@"%@", @(group.memberArray.count)]];
            [self.tableView reloadData];
            self.descLabel.text = group.desc;
        }
    }];
}

- (void)ul_layoutNavigation
{
    self.title = @"群信息";
}
- (void)ul_addSubviews
{
    _nameArray = @[@"群名称", @"群主", @"群成员"];
    self.view.backgroundColor = kBackgroundColor;
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomView];
    [self.view addSubview:self.detailView];
    [self.view updateConstraintsIfNeeded];
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(84);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(45*3);
    }];
    [self.detailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.tableView.mas_bottom).offset(18);
        make.height.mas_equalTo(90);
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(33);
    }];
    [super updateViewConstraints];
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
        _tableView.scrollEnabled = NO;
        _tableView.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0);
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ULGroupDetailTableViewCellIdentifier"];
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

- (UIView *)detailView
{
    if (!_detailView)
    {
        _detailView = [[UIView alloc] init];
        _detailView.backgroundColor = kCommonWhiteColor;
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.font = kFont(kStandardPx(28));
        nameLabel.textColor = kTextBlackColor;
        nameLabel.text = @"群信息";
        [_detailView addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_detailView).offset(15);
            make.top.equalTo(_detailView).offset(15);
        }];
        
        self.descLabel = [[UILabel alloc] init];
        self.descLabel.font = kFont(kStandardPx(28));
        self.descLabel.textColor = kTextBlackColor;
        self.descLabel.text = @"";
        [_detailView addSubview:self.descLabel];
        [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_detailView).offset(15);
            make.top.equalTo(nameLabel.mas_bottom).offset(10);
        }];

    }
    return _detailView;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _nameArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"ULGroupDetailTableViewCellIdentifier"];
    for (UIView *subview in cell.subviews)
    {
        [subview removeFromSuperview];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.font = kFont(kStandardPx(28));
    nameLabel.textColor = kTextBlackColor;
    nameLabel.text = _nameArray[indexPath.row];
    [cell addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell).offset(15);
        make.centerY.equalTo(cell);
    }];
    
    UILabel *detailLabel = [[UILabel alloc] init];
    detailLabel.textColor = KTextGrayColor;
    detailLabel.font = kFont(kStandardPx(24));
    detailLabel.text = _detailArray[indexPath.row];
    [cell addSubview:detailLabel];
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2)
    {
        ULGroupUsersViewController *usersVC = [[ULGroupUsersViewController alloc] initWithGroup:self.group];
        [self.navigationController pushViewController:usersVC animated:YES];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
