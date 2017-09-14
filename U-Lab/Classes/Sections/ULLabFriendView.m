//
//  ULLabFriendView.m
//  U-Lab
//
//  Created by 周维康 on 2017/6/8.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULLabFriendView.h"
#import "ULLabModel.h"
#import "ULLabViewModel.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ULLabFriendView() <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIScrollView *scrollView;  /**< 滑动背景板 */
@property (nonatomic, strong) UITableView *addTableView;  /**< 列表 */
@property (nonatomic, strong) UITableView *friendTableView;  /**< 成员列表 */
@property (nonatomic, strong) UIButton *addButton;  /**< 加入申请 */
@property (nonatomic, strong) UIButton *friendButton;  /**< 人员列表 */
@property (nonatomic, strong) UIImageView *bottomView;  /**< 底部花篮 */
@property (nonatomic, strong) ULLabViewModel *viewModel;  /**< vm */

@end

@implementation ULLabFriendView
{
    NSArray *_friendArray;
    NSArray *_addArray;
}

- (void)updataViews{
    [self.viewModel.friendCommand execute:[NSNumber numberWithInteger:[ULUserMgr sharedMgr].laboratoryId]];
    //    [self.viewModel.addFriendCommand execute:nil];
    @weakify(self)
    [self.viewModel.friendSubject subscribeNext:^(id x) {
        @strongify(self)
        _friendArray = x;
        [ULUserMgr sharedMgr].firendLabArray = x;
        _scrollView.contentSize = CGSizeMake(screenWidth, (_addArray.count+_friendArray.count)*88+screenHeight-132);
        [self.friendTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self.friendButton.mas_bottom);
            make.height.mas_equalTo(_friendArray.count*88);
        }];
        [self.friendTableView reloadData];
    }];
    //    [self.viewModel.friendCommand.executionSignals.flatten subscribeError:^(NSError *error) {
    //        [ULProgressHUD showWithMsg:@"请求失败" inView:self];
    //    }];
    
    [self.viewModel.applyFriendCommand execute:nil];
    [self.viewModel.applyFriendSubject subscribeNext:^(id x) {
        @strongify(self)
        _addArray = x;
        _scrollView.contentSize = CGSizeMake(screenWidth, (_addArray.count+_friendArray.count)*88+screenHeight-132);
        [self.addTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self.addButton.mas_bottom);
            make.height.mas_equalTo(_addArray.count*88);
        }];
        [self.addTableView reloadData];
    }];
}

- (void)ul_setupViews
{
    self.nextSubject = [RACSubject subject];
    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.addTableView];
    [self.scrollView addSubview:self.addButton];
    [self.scrollView addSubview:self.friendButton];
    [self.scrollView addSubview:self.friendTableView];
    [self addSubview:self.bottomView];
    [self updateConstraintsIfNeeded];
    [self setNeedsUpdateConstraints];
}

- (void)ul_bindViewModel
{
    
}

- (void)updateConstraints
{
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self).offset(64);
        make.bottom.equalTo(self).offset(-33);
    }];
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
    [self.friendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.addTableView.mas_bottom);
        make.height.mas_equalTo(45);
    }];
    
    [self.friendTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.friendButton.mas_bottom);
        make.height.mas_equalTo(_friendArray.count*88);
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
        _addTableView.backgroundColor = kCommonWhiteColor;
        _addTableView.scrollEnabled = NO;
        _addArray = [NSArray array];
        [_addTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ULLabFriendAddTableViewCellIdentifier"];
    }
    return _addTableView;
}

- (UITableView *)friendTableView
{
    if (!_friendTableView)
    {
        _friendTableView = [[UITableView alloc] init];
        _friendTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _friendTableView.delegate = self;
        _friendTableView.dataSource = self;
        _friendTableView.rowHeight = 88;
        //        _friendTableView.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0);
        _friendTableView.backgroundColor = kCommonWhiteColor;
        _friendTableView.scrollEnabled = NO;
        _friendArray = [NSArray array];
        [_friendTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ULLabFriendFriendTableViewCellIdentifier"];
    }
    return _friendTableView;
}

- (UIScrollView *)scrollView
{
    if (!_scrollView)
    {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.contentSize = CGSizeMake(screenWidth, (_addArray.count+_friendArray.count)*88+screenHeight-132);
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0);
    }
    return _scrollView;
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
        label.text = @"友好实验室申请";
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
                self.scrollView.contentSize = CGSizeMake(screenWidth, (_friendArray.count)*88+screenHeight-132);
            } else {
                imageView.image = [UIImage imageNamed:@"ulab_tableview_show"];
                [self.addTableView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(_addArray.count*88);
                }];
                self.scrollView.contentSize = CGSizeMake(screenWidth, (_addArray.count+_friendArray.count)*88+screenHeight-132
                                                         );
            }
        }];
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

- (UIButton *)friendButton
{
    if (!_friendButton)
    {
        _friendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _friendButton.backgroundColor = kCommonWhiteColor;
        UILabel *label = [[UILabel alloc] init];
        label.font = kFont(kStandardPx(32));
        label.textColor = kTextBlackColor;
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ulab_tableview_show"]];
        [_friendButton addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_friendButton).offset(15);
            make.centerY.equalTo(_friendButton);
            make.size.mas_equalTo(CGSizeMake(11, 11));
        }];
        label.text = @"友好实验室";
        [_friendButton addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imageView.mas_right).offset(5);
            make.centerY.equalTo(_friendButton);
        }];
        @weakify(self)
        [[_friendButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self)
            _friendButton.selected = !_friendButton.selected;
            if (_friendButton.isSelected)
            {
                imageView.image = [UIImage imageNamed:@"ulab_tableview_hide"];
                [self.friendTableView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(0);
                }];
                self.scrollView.contentSize = CGSizeMake(screenWidth, (_addArray.count)*88+screenHeight-132);
            } else {
                imageView.image = [UIImage imageNamed:@"ulab_tableview_show"];
                [self.friendTableView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(_friendArray.count*88);
                }];
                self.scrollView.contentSize = CGSizeMake(screenWidth, (_addArray.count+_friendArray.count)*88+screenHeight-132);
            }
        }];
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = kBackgroundColor;
        [_friendButton addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(_friendButton);
            make.height.mas_equalTo(0.5);
        }];
    }
    return _friendButton;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.addTableView)
    {
        return _addArray.count;
    } else {
        return _friendArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    ULLabModel *model;
    
    if (tableView == self.addTableView)
    {
        cell = [self.addTableView dequeueReusableCellWithIdentifier:@"ULLabFriendAddTableViewCellIdentifier"];
        model = _addArray[indexPath.row];
    } else {
        cell = [self.friendTableView dequeueReusableCellWithIdentifier:@"ULLabFriendFriendTableViewCellIdentifier"];
        model = _friendArray[indexPath.row];
    }
    
    for (UIView *subview in cell.subviews)
    {
        [subview removeFromSuperview];
    }
    UIImageView *headerImageView = [[UIImageView alloc] init];
    [headerImageView sd_setImageWithURL:[NSURL URLWithString:model.labImage] placeholderImage:[UIImage imageNamed:@"ulab_lab_default"]];
    headerImageView.layer.cornerRadius = 25.5;
    headerImageView.layer.masksToBounds = YES;
    [cell addSubview:headerImageView];
    [headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell);
        make.left.equalTo(cell).offset(15);
        make.size.mas_equalTo(CGSizeMake(51, 51));
    }];
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = model.labName;
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
        detailLabel.text = @"请求成为友好实验室";
        UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        if (model.applyStatus == -1) {
            [addButton setTitle:@"同意" forState:UIControlStateNormal];
            addButton.backgroundColor = KButtonBlueColor;
            [addButton setTitleColor:kCommonWhiteColor forState:UIControlStateNormal];
            [[addButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                ULBaseRequest *request = [[ULBaseRequest alloc]init];
                request.isJson = NO;
                [request postDataWithParameter:@{@"applyId":@(model.labID),@"status":@1}
                                       session:YES progress:nil success:^(ULBaseRequest *request, NSDictionary *responseObject) {
                                           [addButton setTitle:@"已同意" forState:UIControlStateNormal];
                                           addButton.backgroundColor = kCommonGrayColor;
                                           [addButton setTitleColor:kCommonWhiteColor forState:UIControlStateNormal];
                                           addButton.enabled = NO;
                                           
                                       } failure:^(ULBaseRequest *request, NSError *error) {
                                           [ULProgressHUD showWithMsg:@"请求失败"];
                                       } withPath:@"ulab_lab/lab/friendlyApply/status"];
            }];
        }else if (model.applyStatus == 0){
            [addButton setTitle:@"已拒绝" forState:UIControlStateNormal];
            addButton.backgroundColor = kCommonGrayColor;
            [addButton setTitleColor:kCommonWhiteColor forState:UIControlStateNormal];
            addButton.enabled = NO;
        }else{
            [addButton setTitle:@"已同意" forState:UIControlStateNormal];
            addButton.backgroundColor = kCommonGrayColor;
            [addButton setTitleColor:kCommonWhiteColor forState:UIControlStateNormal];
            addButton.enabled = NO;
        }
        
        addButton.layer.masksToBounds = YES;
        addButton.layer.cornerRadius = 5;
        [cell addSubview:addButton];
        [addButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(cell).offset(-15);
            make.centerY.equalTo(cell);
            make.size.mas_equalTo(CGSizeMake(75, 30));
        }];
    } else {
        detailLabel.text = [NSString stringWithFormat:@"研究方向:%@", model.labResearch];
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == self.addTableView)
    {
        [self.nextSubject sendNext:@{
                                     @"isAgree" : @(0),
                                     @"model" : _addArray[indexPath.row]
                                     }];
    } else {
        [self.nextSubject sendNext:@{
                                     @"isAgree" : @(1),
                                     @"model" : _friendArray[indexPath.row]
                                     }];
    }
}
@end
