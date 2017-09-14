//
//  ULLabMemberView.m
//  U-Lab
//
//  Created by 周维康 on 2017/6/8.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULLabMemberView.h"
#import "ULLabMemberModel.h"
#import "ULLabViewModel.h"

@interface ULLabMemberView() <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIScrollView *scrollView;  /**< 滑动背景板 */
@property (nonatomic, strong) UITableView *addTableView;  /**< 列表 */
@property (nonatomic, strong) UITableView *memberTableView;  /**< 成员列表 */
@property (nonatomic, strong) UIButton *addButton;  /**< 加入申请 */
@property (nonatomic, strong) UIButton *memberButton;  /**< 人员列表 */
@property (nonatomic, strong) UIImageView *bottomView;  /**< 底部花篮 */
@property (nonatomic, strong) ULLabViewModel *viewModel;  /**< vm */
@end

@implementation ULLabMemberView
{
    NSArray *_addArray;
}

- (void)ul_setupViews
{
    self.memberArray = [NSArray array];
    _addArray = [NSArray array];
    [self.viewModel.memberCommand execute:[NSNumber numberWithInteger:[ULUserMgr sharedMgr].laboratoryId]];
    [self.viewModel.addMemberCommand execute:nil];
    [self addSubview:self.scrollView];
    
    [self.scrollView addSubview:self.addTableView];
    [self.scrollView addSubview:self.addButton];
    
    [self.scrollView addSubview:self.memberButton];
    [self.scrollView addSubview:self.memberTableView];
    [self addSubview:self.bottomView];
    [self updateConstraintsIfNeeded];
    [self setNeedsUpdateConstraints];
}

- (void)ul_bindViewModel
{
    @weakify(self)
    [self.viewModel.memberSubject subscribeNext:^(id x) {
        @strongify(self)
        _memberArray = x;
        self.memberArray = x;
        [self performSelector:@selector(reload) onThread:[NSThread mainThread] withObject:nil waitUntilDone:YES];
        self.scrollView.contentSize = CGSizeMake(screenWidth, (_addArray.count+_memberArray.count)*88+screenHeight-132);
    }];
    //    [self.viewModel.memberCommand.executionSignals.flatten subscribeError:^(NSError *error) {
    //        [ULProgressHUD showWithMsg:@"请求失败" inView:self];
    //    }];
    [self.viewModel.addMemberSubject subscribeNext:^(id x) {
        @strongify(self)
        _addArray = x;
        [self.addTableView reloadData];
        self.scrollView.contentSize = CGSizeMake(screenWidth, (_addArray.count+_memberArray.count)*88+screenHeight-132);
    }];
}

- (void)reload
{
    [self.memberTableView reloadData];
}
- (void)updateConstraints
{
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self).offset(64);
        make.bottom.equalTo(self).offset(-33);
    }];
    if ([[ULUserMgr sharedMgr].role  isEqual: @2])
    {
        [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.height.mas_equalTo(45);
            make.top.equalTo(self.scrollView);
        }];
        [self.addTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self.addButton.mas_bottom);
            make.height.mas_equalTo(_addArray.count*88);
        }];
    } else if ([[ULUserMgr sharedMgr].role  isEqual: @0]) {
        [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.height.mas_equalTo(0);
            make.top.equalTo(self.scrollView);
        }];
        [self.addTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self.addButton.mas_bottom);
            make.height.mas_equalTo(0);
        }];
    }
    [self.memberButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.addTableView.mas_bottom);
        make.height.mas_equalTo(45);
    }];
    
    [self.memberTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.memberButton.mas_bottom);
        make.height.mas_equalTo(_memberArray.count*88);
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(33);
    }];
    [super updateConstraints];
}

- (ULLabViewModel *)viewModel
{
    if (!_viewModel)
    {
        _viewModel = [[ULLabViewModel alloc] init];
    }
    return _viewModel;
}
- (UIImageView *)bottomView
{
    if (!_bottomView)
    {
        _bottomView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"register_bottom"]];
    }
    return _bottomView;
}

- (UITableView *)addTableView
{
    if (!_addTableView)
    {
        _addTableView = [[UITableView alloc] init];
        _addTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _addTableView.delegate = self;
        _addTableView.dataSource = self;
        _addTableView.rowHeight = 88;
        _addTableView.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0);
        _addTableView.backgroundColor = kCommonWhiteColor;
        _addTableView.scrollEnabled = NO;
        [_addTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ULLabMemberAddTableViewCellIdentifier"];
    }
    return _addTableView;
}

- (UIScrollView *)scrollView
{
    if (!_scrollView)
    {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.contentSize = CGSizeMake(screenWidth, (_addArray.count+_memberArray.count)*88+screenHeight-132);
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0);
    }
    return _scrollView;
}

- (UITableView *)memberTableView
{
    if (!_memberTableView)
    {
        _memberTableView = [[UITableView alloc] init];
        _memberTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _memberTableView.delegate = self;
        _memberTableView.dataSource = self;
        _memberTableView.rowHeight = 88;
        _memberTableView.scrollEnabled = NO;
        _memberTableView.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0);
        _memberTableView.backgroundColor = kCommonWhiteColor;
        [_memberTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ULLabMemberMemberTableViewCellIdentifier"];
    }
    return _memberTableView;
}

- (UIButton *)addButton
{
    if (!_addButton)
    {
        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _addButton.backgroundColor = kCommonWhiteColor;
        UILabel *label = [[UILabel alloc] init];
        label.font = kFont(kStandardPx(32));
        label.textColor = kTextBlackColor;
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ulab_tableview_show"]];
        [_addButton addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_addButton).offset(15);
            make.centerY.equalTo(_addButton);
            make.size.mas_equalTo(CGSizeMake(11, 11));
        }];
        label.text = @"加入申请";
        [_addButton addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imageView.mas_right).offset(5);
            make.centerY.equalTo(_addButton);
        }];
        @weakify(self)
        [[_addButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self)
            _addButton.selected = !_addButton.selected;
            if (_addButton.isSelected)
            {
                imageView.image = [UIImage imageNamed:@"ulab_tableview_hide"];
                [self.addTableView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(0);
                }];
                _scrollView.contentSize = CGSizeMake(screenWidth, (_memberArray.count)*88+screenHeight-132);
            } else {
                imageView.image = [UIImage imageNamed:@"ulab_tableview_show"];
                [self.addTableView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(_addArray.count*88);
                }];
                self.scrollView.contentSize = CGSizeMake(screenWidth, (_addArray.count+_memberArray.count)*88+screenHeight-132);
            }
        }];
        if ([ULUserMgr sharedMgr].role == @0)
        {
            _addButton.hidden = YES;
        }
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = kBackgroundColor;
        [_addButton addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(_addButton);
            make.height.mas_equalTo(0.5);
        }];
    }
    return _addButton;
}

- (UIButton *)memberButton
{
    if (!_memberButton)
    {
        _memberButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _memberButton.backgroundColor = kCommonWhiteColor;
        UILabel *label = [[UILabel alloc] init];
        label.font = kFont(kStandardPx(32));
        label.textColor = kTextBlackColor;
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ulab_tableview_show"]];
        [_memberButton addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_memberButton).offset(15);
            make.centerY.equalTo(_memberButton);
            make.size.mas_equalTo(CGSizeMake(11, 11));
        }];
        label.text = @"人员列表";
        [_memberButton addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imageView.mas_right).offset(5);
            make.centerY.equalTo(_memberButton);
        }];
        @weakify(self)
        [[_memberButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self)
            _memberButton.selected = !_memberButton.selected;
            if (_memberButton.isSelected)
            {
                imageView.image = [UIImage imageNamed:@"ulab_tableview_hide"];
                [self.memberTableView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(0);
                }];
                _scrollView.contentSize = CGSizeMake(screenWidth, (_addArray.count)*88+screenHeight-132);
            } else {
                imageView.image = [UIImage imageNamed:@"ulab_tableview_show"];
                [self.memberTableView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(_memberArray.count*88);
                }];
                _scrollView.contentSize = CGSizeMake(screenWidth, (_addArray.count+_memberArray.count)*88+screenHeight-132);
            }
        }];
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = kBackgroundColor;
        [_memberButton addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(_memberButton);
            make.height.mas_equalTo(0.5);
        }];
    }
    return _memberButton;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.addTableView)
    {
        return _addArray.count;
    } else {
        return self.memberArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    ULLabMemberModel *model;
    
    if (tableView == self.addTableView)
    {
        cell = [self.addTableView dequeueReusableCellWithIdentifier:@"ULLabMemberAddTableViewCellIdentifier"];
        model = _addArray[indexPath.row];
    } else {
        cell = [self.memberTableView dequeueReusableCellWithIdentifier:@"ULLabMemberMemberTableViewCellIdentifier"];
        model = _memberArray[indexPath.row];
    }
    
    for (UIView *subview in cell.subviews)
    {
        [subview removeFromSuperview];
    }
    UIImageView *headerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
    headerImageView.layer.cornerRadius = 25.5;
    headerImageView.layer.masksToBounds = YES;
    [cell addSubview:headerImageView];
    [headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell);
        make.left.equalTo(cell).offset(15);
        make.size.mas_equalTo(CGSizeMake(51, 51));
    }];
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = model.memberName;
    nameLabel.textColor = [UIColor blackColor];
    nameLabel.font = kFont(kStandardPx(34));
    [cell addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerImageView.mas_right).offset(17);
        make.top.equalTo(cell).offset(21);
    }];
    UILabel *detailLabel = [[UILabel alloc] init];
    detailLabel.textColor = KTextGrayColor;
    detailLabel.font = kFont(kStandardPx(28));
    [cell addSubview:detailLabel];
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLabel);
        make.top.equalTo(nameLabel.mas_bottom).offset(13);
    }];
    
    if (tableView == self.addTableView)
    {
        detailLabel.text = @"申请加入实验室";
        UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [addButton setTitle:@"同意" forState:UIControlStateNormal];
        addButton.backgroundColor = KButtonBlueColor;
        [addButton setTitleColor:kCommonWhiteColor forState:UIControlStateNormal];
        addButton.layer.masksToBounds = YES;
        addButton.layer.cornerRadius = 5;
        @weakify(self)
        [[addButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self)
            [self.viewModel.agreeCommand execute:@{
                                                   @"labApplyId":model.applyId, //申请id
                                                   @"status":@1 //0:拒绝，1:同意
                                                   }];
        }];
        [cell addSubview:addButton];
        [addButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(cell).offset(-15);
            make.centerY.equalTo(cell);
            make.size.mas_equalTo(CGSizeMake(75, 30));
        }];
    } else {
        detailLabel.text = [NSString stringWithFormat:@"研究方向:%@", model.research];
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
@end
