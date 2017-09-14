//
//  ULMessageFriendView.m
//  U-Lab
//
//  Created by 周维康 on 2017/6/8.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULMessageFriendView.h"
#import "ULMessageFriendModel.h"
#import "ULMessageFriendViewModel.h"

@interface ULMessageFriendView() <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIScrollView *scrollView;  /**< 滑动背景板 */
@property (nonatomic, strong) UITableView *addTableView;  /**< 借用列表 */
@property (nonatomic, strong) UITableView *groupTableView;  /**< 入库 */
@property (nonatomic, strong) UITableView *friendTableView;  /**< 购买 */
@property (nonatomic, strong) UIButton *addButton;  /**< lend */
@property (nonatomic, strong) UIButton *groupButton;  /**< in */
@property (nonatomic, strong) UIButton *friendButton;  /**< buy */
@property (nonatomic, strong) NSMutableArray *conversationArray;  /**< 会话列表 */
@property (nonatomic, strong) ULMessageFriendViewModel *viewModel;  /**< VM */

@end

@implementation ULMessageFriendView
{
//    NSArray *_addArray;
//    NSArray *[ULUserMgr sharedMgr].groupArray;
//    NSArray *[ULUserMgr sharedMgr].friendArray;
}

- (void)updateFriendList
{
//    _addArray = [ULUserMgr sharedMgr].addFriendArray;
    [self.addTableView reloadData];
    [self.viewModel.friendListCommand execute:nil];
    @weakify(self)
    [JMSGGroup myGroupArray:^(id resultObject, NSError *error) {
        @strongify(self)
        if (!error) {
            [ULUserMgr sharedMgr].groupArray = resultObject;
            [self.groupTableView reloadData];
        }
    }];
}
- (void)ul_setupViews
{
    self.chatSubject = [RACSubject subject];
    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.addTableView];
    [self.scrollView addSubview:self.addButton];
    [self.scrollView addSubview:self.groupButton];
    [self.scrollView addSubview:self.groupTableView];
    [self.scrollView addSubview:self.friendButton];
    [self.scrollView addSubview:self.friendTableView];
    [self updateConstraintsIfNeeded];
    [self setNeedsUpdateConstraints];
}

- (void)ul_bindViewModel
{
    @weakify(self)
    [self.viewModel.friendListCommand.executionSignals.flatten subscribeNext:^(id x){
        @strongify(self)
        [ULUserMgr sharedMgr].friendArray = x;
        [self.friendTableView reloadData];
    }];
    
}

- (void)updateConstraints
{
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self);
        make.bottom.equalTo(self);
    }];
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.mas_equalTo(45);
        make.top.equalTo(self.scrollView);
    }];
    [self.addTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.addButton.mas_bottom);
        make.height.mas_equalTo([ULUserMgr sharedMgr].addFriendArray.count*88);
    }];
    [self.groupButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.addTableView.mas_bottom);
        make.height.mas_equalTo(45);
    }];
    
    [self.groupTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.groupButton.mas_bottom);
        make.height.mas_equalTo([ULUserMgr sharedMgr].groupArray.count*88);
    }];
    [self.friendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.groupTableView.mas_bottom);
        make.height.mas_equalTo(45);
    }];
    [self.friendTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.friendButton.mas_bottom);
        make.height.mas_equalTo([ULUserMgr sharedMgr].friendArray.count*88);
    }];
    [super updateConstraints];
}

- (ULMessageFriendViewModel *)viewModel
{
    if (!_viewModel)
    {
        _viewModel = [[ULMessageFriendViewModel alloc] init];
    }
    return _viewModel;
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
        _addTableView.scrollEnabled = NO;
        _addTableView.backgroundColor = kCommonWhiteColor;
        [_addTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ULMessageFriendFriendTableViewCellIdentifier"];
//        [_addTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ULMessageFriendAddTableViewCellIdentifier"];
    }
    return _addTableView;
}

- (UITableView *)groupTableView
{
    if (!_groupTableView)
    {
        _groupTableView = [[UITableView alloc] init];
        _groupTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _groupTableView.delegate = self;
        _groupTableView.dataSource = self;
        _groupTableView.rowHeight = 88;
        _groupTableView.backgroundColor = kCommonWhiteColor;
        _groupTableView.scrollEnabled = NO;
        [_groupTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ULMessageFriendGroupTableViewCellIdentifier"];
    }
    return _groupTableView;
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
        _friendTableView.scrollEnabled = NO;
        _friendTableView.backgroundColor = kCommonWhiteColor;
        [_friendTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ULMessageFriendFriendTableViewCellIdentifier"];
    }
    return _friendTableView;
}

- (UIScrollView *)scrollView
{
    if (!_scrollView)
    {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.contentSize = CGSizeMake(screenWidth, ([ULUserMgr sharedMgr].addFriendArray.count+[ULUserMgr sharedMgr].friendArray.count+[ULUserMgr sharedMgr].groupArray.count)*88+screenHeight-132);
        _scrollView.showsHorizontalScrollIndicator = NO;
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
        label.text = @"好友申请";
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
                self.scrollView.contentSize = CGSizeMake(screenWidth, ([ULUserMgr sharedMgr].groupArray.count+[ULUserMgr sharedMgr].friendArray.count)*88+screenHeight-132);
            } else {
                imageView.image = [UIImage imageNamed:@"ulab_tableview_show"];
                [self.addTableView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo([ULUserMgr sharedMgr].addFriendArray.count*88);
                }];
                self.scrollView.contentSize = CGSizeMake(screenWidth, ([ULUserMgr sharedMgr].groupArray.count+[ULUserMgr sharedMgr].friendArray.count+[ULUserMgr sharedMgr].addFriendArray.count)*88+screenHeight-132);
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

- (UIButton *)groupButton
{
    if (!_groupButton)
    {
        _groupButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _groupButton.backgroundColor = kCommonWhiteColor;
        UILabel *label = [[UILabel alloc] init];
        label.font = kFont(kStandardPx(32));
        label.textColor = kTextBlackColor;
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ulab_tableview_show"]];
        [_groupButton addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_groupButton).offset(15);
            make.centerY.equalTo(_groupButton);
            make.size.mas_equalTo(CGSizeMake(11, 11));
        }];
        label.text = @"群组列表";
        [_groupButton addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imageView.mas_right).offset(5);
            make.centerY.equalTo(_groupButton);
        }];
        @weakify(self)
        [[_groupButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self)
            _groupButton.selected = !_groupButton.selected;
            if (_groupButton.isSelected)
            {
                imageView.image = [UIImage imageNamed:@"ulab_tableview_hide"];
                [self.groupTableView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(0);
                }];
                self.scrollView.contentSize = CGSizeMake(screenWidth, ([ULUserMgr sharedMgr].addFriendArray.count+[ULUserMgr sharedMgr].friendArray.count)*88+screenHeight-132);
            } else {
                imageView.image = [UIImage imageNamed:@"ulab_tableview_show"];
                [self.groupTableView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo([ULUserMgr sharedMgr].groupArray.count*88);
                }];
                self.scrollView.contentSize = CGSizeMake(screenWidth, ([ULUserMgr sharedMgr].addFriendArray.count+[ULUserMgr sharedMgr].groupArray.count+[ULUserMgr sharedMgr].friendArray.count)*88+screenHeight-132
                                                         );
            }
        }];
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = kBackgroundColor;
        [_groupButton addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(_groupButton);
            make.height.mas_equalTo(0.5);
        }];
    }
    return _groupButton;
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
        label.text = @"好友列表";
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
                self.scrollView.contentSize = CGSizeMake(screenWidth, ([ULUserMgr sharedMgr].addFriendArray.count+[ULUserMgr sharedMgr].groupArray.count)*88+screenHeight-132);
            } else {
                imageView.image = [UIImage imageNamed:@"ulab_tableview_show"];
                [self.friendTableView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo([ULUserMgr sharedMgr].friendArray.count*88);
                }];
                self.scrollView.contentSize = CGSizeMake(screenWidth, ([ULUserMgr sharedMgr].groupArray.count+[ULUserMgr sharedMgr].friendArray.count+[ULUserMgr sharedMgr].addFriendArray.count)*88+screenHeight-132);
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
        return [ULUserMgr sharedMgr].addFriendArray.count;
    } else if (tableView == self.groupTableView) {
        return [ULUserMgr sharedMgr].groupArray.count;
    } else {
        return [ULUserMgr sharedMgr].friendArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    JMSGUser *model;
    NSString *gid;
    if (tableView == self.addTableView)
    {
        cell = [self.addTableView dequeueReusableCellWithIdentifier:@"ULMessageFriendAddTableViewCellIdentifier"];
        model = [ULUserMgr sharedMgr].addFriendArray[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    } else if (tableView == self.groupTableView) {
        cell = [self.groupTableView dequeueReusableCellWithIdentifier:@"ULMessageFriendGroupTableViewCellIdentifier"];
        gid = [NSString stringWithFormat:@"%@",[ULUserMgr sharedMgr].groupArray[indexPath.row]];
    } else {
        cell = [self.friendTableView dequeueReusableCellWithIdentifier:@"ULMessageFriendFriendTableViewCellIdentifier"];
        model = [ULUserMgr sharedMgr].friendArray[indexPath.row];
    }
//    if (!cell)
//    {
        UIImageView *headerImageView = [[UIImageView alloc] init];
        if (tableView == self.groupTableView)
        {
            headerImageView.image = [UIImage imageNamed:@"ulab_user_default"];
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ULMessageFriendGroupTableViewCellIdentifier"];
        } else if (tableView == self.addTableView) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ULMessageFriendAddTableViewCellIdentifier"];
            if (model.avatar)
            {
                headerImageView.image = [UIImage imageNamed:model.avatar];
            } else {
                headerImageView.image = [UIImage imageNamed:@"ulab_user_default"];
            }
        } else {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ULMessageFriendFriendTableViewCellIdentifier"];
            if (model.avatar)
            {
                headerImageView.image = [UIImage imageNamed:model.avatar];
            } else {
                headerImageView.image = [UIImage imageNamed:@"ulab_user_default"];
            }
        }
    headerImageView.layer.cornerRadius = 25.5;
    headerImageView.layer.masksToBounds = YES;
    [cell addSubview:headerImageView];
    [headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell);
        make.left.equalTo(cell).offset(15);
        make.size.mas_equalTo(CGSizeMake(51, 51));
    }];
    UILabel *nameLabel = [[UILabel alloc] init];
    if (tableView == self.groupTableView)
    {
        [JMSGGroup groupInfoWithGroupId:gid completionHandler:^(id resultObject, NSError *error) {
            if (!error) {
                JMSGGroup *group = (JMSGGroup *)resultObject;
                nameLabel.text = group.name;
            }
        }];
    } else {
        nameLabel.text = model.nickname;
    }
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
        detailLabel.text = @"请求成为你的好友";
        UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [addButton setTitle:@"同意" forState:UIControlStateNormal];
        addButton.backgroundColor = KButtonBlueColor;
        [addButton setTitleColor:kCommonWhiteColor forState:UIControlStateNormal];
        addButton.layer.masksToBounds = YES;
        addButton.layer.cornerRadius = 5;
        @weakify(self)
        [[addButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self)
            [self.viewModel.acceptCommand execute:[NSString stringWithFormat:@"%@", model.username]];
            [[ULUserMgr sharedMgr].addFriendArray removeObject:model];
            [ULUserMgr sharedMgr].addFriendArray = [ULUserMgr sharedMgr].addFriendArray;
            [self.addTableView reloadData];
        }];
        [cell addSubview:addButton];
        [addButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(cell).offset(-15);
            make.centerY.equalTo(cell);
            make.size.mas_equalTo(CGSizeMake(75, 30));
        }];
    } else if (tableView == self.groupTableView) {
        detailLabel.text = @"";
    } else {
        detailLabel.text = @"";
    }
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = kBackgroundColor;
    [cell addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(cell);
        make.height.mas_equalTo(0.5);
    }];
//    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (tableView == self.friendTableView)
    {
        [self.chatSubject sendNext:@{@"type": @0,
                                     @"next" : [ULUserMgr sharedMgr].friendArray[indexPath.row]
                                     }];
    } else if (tableView == self.groupTableView) {
        [self.chatSubject sendNext:@{@"type": @1,
                                     @"next" : [ULUserMgr sharedMgr].groupArray[indexPath.row]
                    
                                     }];
    }
}
@end

