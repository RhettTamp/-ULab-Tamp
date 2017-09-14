//
//  ULUserLabView.m
//  U-Lab
//
//  Created by 周维康 on 17/5/30.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULUserLabView.h"
#import "ULUserProjectModel.h"
#import "ULUserLabModel.h"

@interface ULUserLabView() <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;  /**< 展示列表 */
@property (nonatomic, strong) UIImageView *bottomView;  /**< 底部花篮 */

@end
@implementation ULUserLabView
{
    NSMutableArray *_projectArray;
}

- (void)updateLabView
{
    [self.viewModel.getCommand execute:nil];
}
- (void)ul_setupViews
{
    _projectArray = [NSMutableArray array];
    self.nextSubject = [RACSubject subject];
    self.backgroundColor = kBackgroundColor;
    [self addSubview:self.tableView];
    [self addSubview:self.bottomView];
    [self updateFocusIfNeeded];
    [self setNeedsUpdateConstraints];
}

- (void)ul_bindViewModel
{
    self.viewModel = [[ULUserLabViewModel alloc] init];
    @weakify(self)
    [ULProgressHUD showWithMsg:@"获取数据中" inView:self withBlock:^{
        @strongify(self)
        [self.viewModel.getCommand execute:nil];
    }];
    
    [self.viewModel.getSubject subscribeNext:^(id x) {
        @strongify(self)
        _projectArray = [x mutableCopy];
        [self.tableView reloadData];
        [ULProgressHUD hide];
    }];
    [self.viewModel.getSubject subscribeError:^(NSError *error) {
        [ULProgressHUD hide];
        [ULProgressHUD showWithMsg:@"请求失败" inView:self];
    }];
}
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
        _tableView.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0);
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ULUserLabTableViewCellIdentifier"];
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _projectArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ULUserProjectModel *projectModel = _projectArray[indexPath.row];
    return (projectModel.labArray.count*45+65+4);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"ULUserLabTableViewCellIdentifier"];
    for (UIView *subView in cell.subviews)
    {
        [subView removeFromSuperview];
    }
    ULUserProjectModel *projectModel = _projectArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = kCommonWhiteColor;
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteButton setBackgroundImage:[UIImage imageNamed:@"user_project_delete"] forState:UIControlStateNormal];
    [[deleteButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [ULProgressHUD showWithMsg:@"删除中" inView:self withBlock:^{
            [self.viewModel.deleteCommand execute:@{
                @"projectId" : projectModel.projectId
            }];
            [_projectArray removeObject:projectModel];
            [self.tableView reloadData];
        }];
    }];
    [cell addSubview:deleteButton];
    [deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(cell).offset(-17);
        make.top.equalTo(cell).offset(13.5);
        make.size.mas_equalTo(CGSizeMake(15, 17.5));
    }];
    UIButton *editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [editButton setBackgroundImage:[UIImage imageNamed:@"user_project_edit"] forState:UIControlStateNormal];
    [[editButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self.nextSubject sendNext:@{
                                     @"projectId" : projectModel.projectId,
                                     @"labArray" : projectModel.labArray
                                     }];
    }];
    [cell addSubview:editButton];
    [editButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(deleteButton.mas_left).offset(-20);
        make.top.equalTo(cell).offset(14);
        make.size.mas_equalTo(CGSizeMake(18, 16));
    }];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.font = [UIFont systemFontOfSize:kStandardPx(34) weight:2];
    nameLabel.textColor = kTextBlackColor;
    nameLabel.text = projectModel.projectName;
    [cell addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cell).offset(14);
        make.left.equalTo(cell).offset(15);
    }];
    UILabel *introLabel = [[UILabel alloc] init];
    introLabel.font = kFont(kStandardPx(26));
    introLabel.textColor = KTextGrayColor;
    introLabel.text = projectModel.projectIntro;
    [cell addSubview:introLabel];
    [introLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLabel);
        make.right.equalTo(editButton.mas_left).offset(-30);
        make.top.equalTo(nameLabel.mas_bottom).offset(7);
    }];
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = kBackgroundColor;
    [cell addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(cell);
        make.top.equalTo(cell).offset(64.5);
        make.height.mas_equalTo(0.5);
    }];
    [projectModel.labArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ULUserLabModel *labModel = obj;
        UIView *whiteView = [[UIView alloc] init];
        whiteView.backgroundColor = kCommonWhiteColor;
        [cell addSubview:whiteView];
        [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(cell);
            make.top.equalTo(cell).offset(idx*45+65);
            make.height.mas_equalTo(45);
        }];
        [self setView:whiteView Name:labModel.labName intro:labModel.labIntro];
    }];
    UIView *grayLine = [[UIView alloc] init];
    grayLine.backgroundColor = kBackgroundColor;
    [cell addSubview:grayLine];
    [grayLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(cell);
        make.height.mas_equalTo(4);
    }];
    return cell;
    
}

- (void)setView:(UIView *)view Name:(NSString *)labName intro:(NSString *)labIntro
{
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = labName;
    nameLabel.textColor = kTextBlackColor;
    nameLabel.font = kFont(kStandardPx(30));
    [view addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).offset(15);
        make.centerY.equalTo(view);
    }];
    UILabel *introLabel = [[UILabel alloc] init];
    introLabel.text = labIntro;
    introLabel.textColor = kTextBlackColor;
    introLabel.font = kFont(kStandardPx(30));
    [view addSubview:introLabel];
    [introLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view).offset(-15);
        make.centerY.equalTo(view);
    }];
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = kBackgroundColor;
    [view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(view);
        make.height.mas_equalTo(0.5);
    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
