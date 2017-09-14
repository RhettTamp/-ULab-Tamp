////
////  ULBuyApplyViewController.m
////  ULab
////
////  Created by 谭培 on 2017/7/24.
////  Copyright © 2017年 周维康. All rights reserved.
////
//
#import "ULBuyApplyViewController.h"
#import "ULUserObjectModel.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ULBuyApplyViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) ULUserObjectModel *model;
@property (nonatomic, strong) UITableView *detailTableView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIImageView *bottomView;
@property (nonatomic, strong) UIButton *refuseButton;
@property (nonatomic, strong) UIButton *agreeButton;
@property (nonatomic, strong) UILabel *stateLabel;
@property (nonatomic, strong) UITextField *priceText;
@property (nonatomic, strong) UIButton *commitButton;
@property (nonatomic, strong) UIButton *cancelButton;

@end

@implementation ULBuyApplyViewController
{
    NSArray *_nameArray;
    NSArray *_detailArray;
}
- (instancetype)initWithModel:(ULUserObjectModel *)model{
    self.model = model;
    if (self = [super init]) {
        
    }
    return self;
}

- (void)ul_addSubviews
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    _nameArray = @[@"类别:", @"名称:", @"型号:", @"厂家:",@"数量"];
    NSString *objectType = @"";
    switch (self.model.objectType) {
        case 1:
            objectType = @"耗材";
            break;
        case 2:
            objectType = @"试剂";
            break;
        case 3:
            objectType = @"动物";
            break;
        case 4:
            objectType = @"仪器";
            break;
        default:
            objectType = @"其他";
            break;
    }
    _detailArray = @[objectType, self.model.objectName?:@"", self.model.specification?:@"", self.model.factory?:@"",[NSString stringWithFormat:@"%@",@(self.model.objectQuantity)]?:@""];
    self.view.backgroundColor = kBackgroundColor;
    [self.view addSubview:self.detailTableView];
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.bottomView];
    [self.view addSubview:self.agreeButton];
    [self.view addSubview:self.refuseButton];
    
    [self.view updateConstraintsIfNeeded];
    [self.view setNeedsUpdateConstraints];
    
}

- (void)ul_layoutNavigation
{
    self.title = @"用户详情";
}

- (void)updateViewConstraints
{
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(64+15);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(88);
    }];
    [self.detailTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom).offset(15);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-33);
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(33);
    }];
    [self.agreeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-80);
        make.size.mas_equalTo(CGSizeMake(80, 40));
        make.centerX.equalTo(self.view).offset(-50);
    }];
    
    [self.refuseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-80);
        make.size.mas_equalTo(CGSizeMake(80, 40));
        make.centerX.equalTo(self.view).offset(50);
    }];
    [super updateViewConstraints];
}

- (UITextField *)priceText{
    if (!_priceText) {
        _priceText = [[UITextField alloc]init];
        _priceText.placeholder = @"设置订单价格";
        _priceText.textAlignment = NSTextAlignmentCenter;
    }
    return _priceText;
}

- (UIButton *)refuseButton{
    if (!_refuseButton) {
        _refuseButton = [UIButton new];
        [_refuseButton setTitle:@"拒绝" forState:UIControlStateNormal];
        [_refuseButton setTitleColor:kCommonWhiteColor forState:UIControlStateNormal];
        _refuseButton.backgroundColor = kCommonRedColor;
        _refuseButton.layer.cornerRadius = 4;
        [[_refuseButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            ULBaseRequest *request = [[ULBaseRequest alloc]init];
            request.isJson = NO;
            [request postDataWithParameter:@{@"buyOrderId":@(self.model.objectId),
                                             @"status":@0} session:YES progress:nil success:^(ULBaseRequest *request, NSDictionary *responseObject) {
                                                 _refuseButton.hidden = YES;
                                                 _agreeButton.hidden = YES;
                                                 [self.view addSubview:self.stateLabel];
                                                 self.stateLabel.text = @"已拒绝";
                                                 [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                                                     make.centerX.equalTo(self.view);
                                                     make.bottom.equalTo(self.view).offset(-80);
                                                 }];
                                             } failure:^(ULBaseRequest *request, NSError *error) {
                                                 [ULProgressHUD showWithMsg:@"请求失败"];
                                             } withPath:@"ulab_item/item/buyOrders"];
        }];
    }
    return _refuseButton;
}

- (UIButton *)agreeButton{
    if (!_agreeButton) {
        _agreeButton = [UIButton new];
        [_agreeButton setTitle:@"同意" forState:UIControlStateNormal];
        [_agreeButton setTitleColor:kCommonWhiteColor forState:UIControlStateNormal];
        _agreeButton.backgroundColor = kCommonBlueColor;
        _agreeButton.layer.cornerRadius = 4;
        [[_agreeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            ULBaseRequest *request = [[ULBaseRequest alloc]init];
            request.isJson = NO;
            [request postDataWithParameter:@{@"buyOrderId":@(self.model.objectId),
                                             @"status":@1} session:YES progress:nil success:^(ULBaseRequest *request, NSDictionary *responseObject) {
                                                 _refuseButton.hidden = YES;
                                                 _agreeButton.hidden = YES;
                                                 if (!_commitButton) {
                                                     [self.view addSubview:self.commitButton];
                                                 }else{
                                                     self.commitButton.hidden = NO;
                                                 }
                                                 
                                                 if (!_priceText) {
                                                     [self.view addSubview:self.priceText];
                                                 }else{
                                                     self.priceText.hidden = NO;
                                                 }
                                                 if (!_cancelButton) {
                                                     [self.view addSubview:self.cancelButton];
                                                 }else{
                                                     self.cancelButton.hidden = NO;
                                                 }
                                                 
                                                 
                                                                                                  [self.commitButton mas_makeConstraints:^(MASConstraintMaker *make) {
                                                     make.bottom.equalTo(self.view.mas_bottom).offset(-60);
                                                     make.size.mas_equalTo(CGSizeMake(80, 40));
                                                     make.centerX.equalTo(self.view).offset(-50);
                                                 }];
                                                 
                                                 [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
                                                     make.bottom.equalTo(self.view.mas_bottom).offset(-60);
                                                     make.size.mas_equalTo(CGSizeMake(80, 40));
                                                     make.centerX.equalTo(self.view).offset(50);
                                                 }];
                                                 [self.priceText mas_makeConstraints:^(MASConstraintMaker *make) {
                                                     make.bottom.equalTo(self.commitButton.mas_top).offset(-10);
                                                     make.centerX.equalTo(self.view);
                                                 }];

                                                 
                                             } failure:^(ULBaseRequest *request, NSError *error) {
                                                 [ULProgressHUD showWithMsg:@"请求失败"];
                                             } withPath:@"ulab_item/item/buyOrders"];
        }];
    }
    return _agreeButton;
}

- (UIButton *)cancelButton{
    if (!_cancelButton) {
        _cancelButton = [UIButton new];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:kCommonWhiteColor forState:UIControlStateNormal];
        _cancelButton.backgroundColor = kCommonRedColor;
        _cancelButton.layer.cornerRadius = 4;
        [[_cancelButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            self.commitButton.hidden = YES;
            self.cancelButton.hidden = YES;
            self.agreeButton.hidden = NO;
            self.refuseButton.hidden = NO;
            self.priceText.hidden = YES;
        }];
    }
    return _cancelButton;
}

- (UIButton *)commitButton{
    if (!_commitButton) {
        _commitButton = [UIButton new];
        [_commitButton setTitle:@"完成" forState:UIControlStateNormal];
        [_commitButton setTitleColor:kCommonWhiteColor forState:UIControlStateNormal];
        _commitButton.backgroundColor = kCommonBlueColor;
        _commitButton.layer.cornerRadius = 4;
        [[_commitButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            if ([[ULUserMgr sharedMgr].labMoney integerValue] < [self.priceText.text integerValue]) {
                [ULProgressHUD showWithMsg:@"购买失败，余额不足"];
                return ;
            }
            ULBaseRequest *request = [[ULBaseRequest alloc]init];
            request.isJson = NO;
            if (!self.priceText.text || [self.priceText.text isEqualToString:@""]) {
                [ULProgressHUD showWithMsg:@"请设置价格"];
            }else{
                [request postDataWithParameter:@{@"buyOrderId":@(self.model.objectId),
                                                 @"amount":@([self.priceText.text integerValue])} session:YES progress:nil success:^(ULBaseRequest *request, NSDictionary *responseObject) {
                                                     [ULProgressHUD showWithMsg:@"设置成功"];
                                                     [ULUserMgr sharedMgr].labMoney = @([[ULUserMgr sharedMgr].labMoney integerValue] - [self.priceText.text integerValue]);
                                                     [self.navigationController popViewControllerAnimated:YES];
                                                     
                                                 } failure:^(ULBaseRequest *request, NSError *error) {
                                                     [ULProgressHUD showWithMsg:@"请求失败"];
                                                 } withPath:@"ulab_item/item/buyOrder/amount"];
            }
            
        }];
    }
    return _commitButton;
}


- (UILabel *)stateLabel{
    if (!_stateLabel) {
        _stateLabel = [[UILabel alloc]init];
        _stateLabel.textColor = kCommonGrayColor;
    }
    return _stateLabel;
}

- (UITableView *)detailTableView
{
    if (!_detailTableView)
    {
        _detailTableView = [[UITableView alloc] init];
        _detailTableView.delegate = self;
        _detailTableView.dataSource = self;
        _detailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _detailTableView.backgroundColor = kBackgroundColor;
        _detailTableView.scrollEnabled = NO;
        [_detailTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ULMessageUserDetailTableViewCellIdentifier"];
    }
    return _detailTableView;
}

- (UIView *)headerView
{
    if (!_headerView)
    {
        _headerView = [[UIView alloc] init];
        _headerView.backgroundColor = kCommonWhiteColor;
        UIImageView *headerImageView;
        headerImageView = [[UIImageView alloc] init];
        [headerImageView sd_setImageWithURL:[NSURL URLWithString:_model.imageURL] placeholderImage:[UIImage imageNamed:@"ulab_user_default"]];
        headerImageView.layer.cornerRadius = 25.5;
        headerImageView.layer.masksToBounds = YES;
        [_headerView addSubview:headerImageView];
        [headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_headerView);
            make.left.equalTo(_headerView).offset(15);
            make.size.mas_equalTo(CGSizeMake(51, 51));
        }];
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.text = self.model.userName;
        
        nameLabel.textColor = [UIColor blackColor];
        nameLabel.font = kFont(kStandardPx(34));
        [_headerView addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(headerImageView.mas_right).offset(17);
            make.top.equalTo(_headerView).offset(21);
        }];
        UILabel *detailLabel = [[UILabel alloc] init];
        detailLabel.text = self.model.userLabName;
        detailLabel.textColor = KTextGrayColor;
        detailLabel.font = kFont(kStandardPx(28));
        [_headerView addSubview:detailLabel];
        [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(nameLabel);
            make.top.equalTo(nameLabel.mas_bottom).offset(13);
        }];
    }
    return _headerView;
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
    return _detailArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [self.detailTableView dequeueReusableCellWithIdentifier:@"ULMessageUserDetailTableViewCellIdentifier"];
    UILabel *nameLabel = [[UILabel alloc] init];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    nameLabel.font = kFont(kStandardPx(30));
    nameLabel.text = _nameArray[indexPath.row];
    nameLabel.textColor = KTextGrayColor;
    [cell addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell).offset(15);
        make.centerY.equalTo(cell);
    }];
    UILabel *detailLabel = [[UILabel alloc] init];
    detailLabel.textColor = KTextGrayColor;
    detailLabel.text = _detailArray[indexPath.row];
    detailLabel.font = kFont(kStandardPx(30));
    [cell addSubview:detailLabel];
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(cell).offset(-15);
        make.centerY.equalTo(cell);
    }];
    return cell;
}
@end
