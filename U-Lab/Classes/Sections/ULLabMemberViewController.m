//
//  ULLabMemberViewController.m
//  U-Lab
//
//  Created by 周维康 on 2017/6/8.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULLabMemberViewController.h"
#import "ULLabMemberView.h"
#import "ULLabMemberChangeViewController.h"
#import "ULMessageUserDetailViewController.h"
#import "ULLabViewModel.h"
#import "ULLabMemberModel.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ULLabMemberViewController () <UITableViewDataSource, UITableViewDelegate>


@property (nonatomic, strong) UIScrollView *scrollView;  /**< 滑动背景板 */
@property (nonatomic, strong) UITableView *addTableView;  /**< 列表 */
@property (nonatomic, strong) UITableView *memberTableView;  /**< 成员列表 */
@property (nonatomic, strong) UIButton *addButton;  /**< 加入申请 */
@property (nonatomic, strong) UIButton *memberButton;  /**< 人员列表 */
@property (nonatomic, strong) UIImageView *bottomView;  /**< 底部花篮 */
@property (nonatomic, strong) ULLabViewModel *viewModel;  /**< vm */
@end

@implementation ULLabMemberViewController
{
    NSArray *_addArray;
    NSArray *_memberArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)ul_addSubviews
{

    _memberArray = [NSArray array];
    _addArray = [NSArray array];
    [self.viewModel.memberCommand execute:[NSNumber numberWithInteger:[ULUserMgr sharedMgr].laboratoryId]];
    if (![[ULUserMgr sharedMgr].role isEqual:@0])
    [self.viewModel.addMemberCommand execute:nil];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.addButton];
    [self.scrollView addSubview:self.addTableView];
    [self.scrollView addSubview:self.memberButton];
    [self.scrollView addSubview:self.memberTableView];
    [self.view addSubview:self.bottomView];
    [self.view updateConstraintsIfNeeded];
    [self.view setNeedsUpdateConstraints];

}

- (void)ul_layoutNavigation
{
    self.title = @"人员信息";
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addButton.frame = CGRectMake(0, 0, 40, 17);
    [addButton setTitle:@"管理" forState:UIControlStateNormal];
    
    //    addButton.titleLabel.font = kFont(kStandardPx(28));
    @weakify(self)
    [[addButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        [[UIApplication sharedApplication].keyWindow endEditing:YES];
        ULLabMemberChangeViewController *vc = [[ULLabMemberChangeViewController alloc] initWithMemberArray:_memberArray];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:addButton];
    if ([[ULUserMgr sharedMgr].role integerValue] == 0) {
        addButton.hidden = YES;
    }
    self.navigationItem.rightBarButtonItem = buttonItem;
}


- (void)ul_bindViewModel
{
    if ([[ULUserMgr sharedMgr].role integerValue] == 0)
    {
        self.scrollView.contentSize = CGSizeMake(screenWidth, (_memberArray.count)*88+45);
        @weakify(self)
        [self.viewModel.memberSubject subscribeNext:^(id x) {
            @strongify(self)
            _memberArray = x;
            [self.memberTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self.view);
                make.top.equalTo(self.memberButton.mas_bottom);
                make.height.mas_equalTo(_memberArray.count*88);
            }];
            [self.memberTableView reloadData];
            
            
        }];
        
    } else {
        @weakify(self)
        [self.viewModel.memberSubject subscribeNext:^(id x) {
            @strongify(self)
            _memberArray = x;
            [self.memberTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self.view);
                make.top.equalTo(self.memberButton.mas_bottom);
                make.height.mas_equalTo(_memberArray.count*88);
            }];
            [self.memberTableView reloadData];
            
            
        }];
        [self.viewModel.addMemberSubject subscribeNext:^(id x) {
            @strongify(self)
            _addArray = x;
            [self.addTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self.view);
                make.top.equalTo(self.addButton.mas_bottom);
                make.height.mas_equalTo(_addArray.count*88);
            }];
            self.scrollView.contentSize = CGSizeMake(screenWidth, (_addArray.count+_memberArray.count)*88+90);
            [self.addTableView reloadData];
        }];
//        self.scrollView.contentSize = CGSizeMake(screenWidth, (_memberArray.count+_addArray.count)*88+90);
    }
    
    //    [self.viewModel.memberCommand.executionSignals.flatten subscribeError:^(NSError *error) {
    //        [ULProgressHUD showWithMsg:@"请求失败" inView:self];
    //    }];
    
}

- (void)updateViewConstraints
{
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(64);
        make.bottom.equalTo(self.view).offset(-33);
    }];
    if ([[ULUserMgr sharedMgr].role integerValue] == 2||
        [[ULUserMgr sharedMgr].role integerValue] == 1)
    {
        [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.height.mas_equalTo(45);
            make.top.equalTo(self.scrollView);
        }];
        [self.addTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.top.equalTo(self.addButton.mas_bottom);
            make.height.mas_equalTo(_addArray.count*88);
        }];
    } else if ([[ULUserMgr sharedMgr].role integerValue] == 0) {
        for (UIView *view in [self.addButton subviews]) {
            [view removeFromSuperview];
        }
        [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.height.mas_equalTo(0);
            make.top.equalTo(self.scrollView);
        }];
        [self.addTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.top.equalTo(self.addButton.mas_bottom);
            make.height.mas_equalTo(0);
        }];
    }
    [self.memberButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.addTableView.mas_bottom);
        make.height.mas_equalTo(45);
    }];
    
    [self.memberTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.memberButton.mas_bottom);
        make.height.mas_equalTo(_memberArray.count*88);
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(33);
    }];

    [super updateViewConstraints];
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
        [_addTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ULLabMemberAddTableViewCellIdentifier"];
    }
    return _addTableView;
}

- (UIScrollView *)scrollView
{
    if (!_scrollView)
    {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.contentSize = CGSizeMake(screenWidth, (_addArray.count+_memberArray.count)*88+90);
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0);
    }
    return _scrollView;
}

- (UITableView *)memberTableView
{
    if (!_memberTableView)
    {
        _memberTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _memberTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _memberTableView.delegate = self;
        _memberTableView.dataSource = self;
        _memberTableView.rowHeight = 88;
        _memberTableView.scrollEnabled = NO;
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
        [self.addTableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(_addArray.count*88);
        }];
        self.scrollView.contentSize = CGSizeMake(screenWidth, (_addArray.count+_memberArray.count)*88+90);
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
                _scrollView.contentSize = CGSizeMake(screenWidth, (_memberArray.count)*88+90);
            } else {
                imageView.image = [UIImage imageNamed:@"ulab_tableview_show"];
                [self.addTableView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(_addArray.count*88);
                }];
                self.scrollView.contentSize = CGSizeMake(screenWidth, (_addArray.count+_memberArray.count)*88+90);
            }
        }];
        if ([[ULUserMgr sharedMgr].role  isEqual: @0])
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
                _scrollView.contentSize = CGSizeMake(screenWidth, (_addArray.count)*88+90);
            } else {
                imageView.image = [UIImage imageNamed:@"ulab_tableview_show"];
                [self.memberTableView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(_memberArray.count*88);
                }];
                _scrollView.contentSize = CGSizeMake(screenWidth, (_addArray.count+_memberArray.count)*88+90);
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.addTableView)
    {
        return _addArray.count;
    } else {
        return _memberArray.count;
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    for (UIView *subview in cell.subviews)
    {
        [subview removeFromSuperview];
    }
    UIImageView *headerImageView = [[UIImageView alloc] init];
    [headerImageView sd_setImageWithURL:[NSURL URLWithString:model.headImage] placeholderImage:[UIImage imageNamed:@"ulab_user_default"]];
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
        if ([model.menberStatus integerValue] == 1) {
            [addButton setTitle:@"已同意" forState:UIControlStateNormal];
            addButton.backgroundColor = kCommonGrayColor;
            addButton.enabled = NO;
        }else if([model.menberStatus integerValue] == 0){
            [addButton setTitle:@"同意" forState:UIControlStateNormal];
            addButton.backgroundColor = KButtonBlueColor;
            [addButton setTitleColor:kCommonWhiteColor forState:UIControlStateNormal];
        }else{
            [addButton setTitle:@"已拒绝" forState:UIControlStateNormal];
            addButton.backgroundColor = kCommonGrayColor;
            addButton.enabled = NO;
        }
        addButton.layer.masksToBounds = YES;
        addButton.layer.cornerRadius = 5;
        @weakify(self)
        [[addButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self)
            [self.viewModel.agreeCommand execute:@{
                                                   @"labApplyId":model.applyId, //申请id
                                                   @"status":@1 //0:拒绝，1:同意
                                                   }];
            addButton.selected = !addButton.selected;
            if (addButton.isSelected) {
                [addButton setTitle:@"已同意" forState:UIControlStateNormal];
                addButton.backgroundColor = kCommonGrayColor;
                addButton.enabled = NO;
                
            }
        }];
        
        [cell addSubview:addButton];
        [addButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(cell).offset(-15);
            make.centerY.equalTo(cell);
            make.size.mas_equalTo(CGSizeMake(75, 30));
        }];
    } else {
        detailLabel.text = [NSString stringWithFormat:@"研究方向:%@", model.research&&![model.research isEqualToString:@""]?model.research:@"未填写"];
        UILabel *identityLabel = [[UILabel alloc]init];
        NSString *identity;
        if ([model.role integerValue] == 1) {
            identity = @"管理员";
        }else if ([model.role integerValue] == 2){
            identity = @"PI";
        }else{
            identity = @"普通用户";
        }
        identityLabel.text =identity;
        identityLabel.textColor = KTextGrayColor;
        [cell addSubview:identityLabel];
        [identityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(cell).offset(-15);
            make.centerY.equalTo(cell);
//            make.size.mas_equalTo(CGSizeMake(75, 30));
        }];
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
    if (tableView == self.memberTableView)
    {
        ULMessageUserDetailViewController *vc = [[ULMessageUserDetailViewController alloc] initWithModel:_memberArray[indexPath.row] andType:0];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        ULMessageUserDetailViewController *vc = [[ULMessageUserDetailViewController alloc] initWithModel:_addArray[indexPath.row]andType:1];
        [self.navigationController pushViewController:vc animated:YES];
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
