//
//  ULLendApplyView.m
//  U-Lab
//
//  Created by 周维康 on 17/5/28.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULLendApplyView.h"
#import "ULUserOrderModel.h"
#import "ULUserOrderViewModel.h"
@interface ULLendApplyView()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIView *headerView;  /**< 顶部视图 */
@property (nonatomic, strong) UITableView *detailTableView;  /**< 详情列表 */
@property (nonatomic, strong) UILabel *statusLabel;  /**< 状态 */
@property (nonatomic, strong) UIButton *agreeButton;  /**< <#comment#> */
@property (nonatomic, strong) UIButton *rejectButton;  /**< <#comment#> */
@property (nonatomic, strong) ULUserOrderModel *model;  /**< <#comment#> */
@property (nonatomic, strong) UIImageView *bottomView;  /**< <#comment#> */
@property (nonatomic, strong) ULUserOrderViewModel *viewModel;  /**< <#comment#> */
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) UIButton *commonButton;
@end

@implementation ULLendApplyView
{
    NSArray *_nameArray;
    NSArray *_detailArray;
}

- (instancetype)initWithModel:(ULUserOrderModel *)model andType:(NSNumber *)type
{
    self.type = [type integerValue];
    self.model = model;
    self = [super init];
    return self;
}

- (void)ul_bindViewModel
{
    //    [self.viewModel.agreeCommand.executionSignals.flatten subscribeNext:^(id x) {
    //        self.rejectButton.hidden = YES;
    //        self.agreeButton.hidden = YES;
    //        self.statusLabel.hidden = NO;
    //        self.statusLabel.text = @"您已处理该订单";
    //    }];
}
- (void)ul_setupViews
{
    _nameArray = @[@"仪器名称：", @"仪器编号：", @"仪器类型：", @"联系方式：", @"使用数量："];
    NSString *itemType;
    switch (self.model.itemType) {
        case 1:
            itemType = @"耗材";
            break;
        case 2:
            itemType = @"试剂";
            break;
        case 3:
            itemType = @"动物";
            break;
        case 4:
            itemType = @"仪器";
            break;
        default:
            itemType = @"其它";
            break;
    }
    _detailArray = @[self.model.orderName?:@"", [NSString stringWithFormat:@"%@", @(self.model.itemId)], @"", self.model.senderName?:@"", self.model.orderQuantity?:@""];
    self.viewModel = [[ULUserOrderViewModel alloc] init];
    [self addSubview:self.headerView];
    [self addSubview:self.detailTableView];
    [self addSubview:self.statusLabel];
    [self addSubview:self.bottomView];
    [self addSubview:self.agreeButton];
    [self addSubview:self.rejectButton];
    [self updateConstraintsIfNeeded];
    [self setNeedsUpdateConstraints];
    self.agreeButton.hidden = YES;
    self.rejectButton.hidden = YES;
    self.statusLabel.hidden = YES;
    if (self.type == 1) {
        switch (self.model.orderStatus) {
            case 0:
                self.agreeButton.hidden = NO;
                self.rejectButton.hidden = NO;
                break;
            case 1:
                self.commonButton = [self addButtonWithType:@(3) andTitle:@"发货"];
                break;
            case 2:
                self.statusLabel.text = @"您已拒绝该申请";
                self.statusLabel.hidden = NO;
                break;
            case 3:
                self.statusLabel.text = @"您已发货";
                self.statusLabel.hidden = NO;
                break;
            case 4:
                self.statusLabel.text = @"订单已完成";
                self.statusLabel.hidden = NO;
                break;
            case 5:
                self.statusLabel.text = @"等待对方归还";
                self.statusLabel.hidden = NO;

                break;
            case 6:
                self.commonButton = [self addButtonWithType:@(7) andTitle:@"确认收货"];
                break;
            case 7:
                self.statusLabel.text = @"订单已完成";
                self.statusLabel.hidden = NO;
                break;
            default:
                break;
        }
    }else{
        self.statusLabel.text = @"等待对方发货";
        switch (self.model.orderStatus) {
            case 0:
                self.statusLabel.text = @"等待对方处理";
                self.statusLabel.hidden = NO;
                break;
            case 1:
                self.statusLabel.text = @"等待对方发货";
                self.statusLabel.hidden = NO;
                break;
            case 2:
                self.statusLabel.text = @"对方已拒绝";
                self.statusLabel.hidden = NO;
                break;
            case 3:
                if (self.model.itemType == 4) {
                    self.commonButton = [self addButtonWithType:@(5) andTitle:@"确认收货"];
                }else{
                    self.commonButton = [self addButtonWithType:@(4) andTitle:@"确认收货"];
                }
                
                break;
            case 4:
                self.statusLabel.text = @"订单已完成";
                self.statusLabel.hidden = NO;
                break;
            case 5:
                self.commonButton = [self addButtonWithType:@(6) andTitle:@"归还"];
                break;
            case 6:
                self.statusLabel.text = @"运送中";
                self.statusLabel.hidden = NO;
                break;
            case 7:
                self.statusLabel.text = @"订单已完成";
                self.statusLabel.hidden = NO;
                break;
            default:
                break;
        }
    }
}

- (UIButton *)addButtonWithType:(NSNumber *)type andTitle:(NSString *)title{
    UIButton *button = [[UIButton alloc]init];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.textColor = [UIColor whiteColor];
    button.backgroundColor = kCommonBlueColor;
    button.layer.cornerRadius = 4;
    [self addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(40);
        make.right.mas_offset(-40);
        make.top.equalTo(self.detailTableView.mas_bottom).offset(30);
        make.height.mas_equalTo(40);
    }];
    [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        ULBaseRequest *request = [[ULBaseRequest alloc]init];
        request.isJson = NO;
        [request postDataWithParameter:@{
                                         @"itemOrderId" : @(self.model.orderId),
                                         @"status" : type
                                         } session:YES progress:nil success:^(ULBaseRequest *request, NSDictionary *responseObject) {
                                             [ULProgressHUD hide];
                                             if (self.type == 1) {
                                                 switch ([type integerValue]) {
                                                     case 0:
                                                         self.agreeButton.hidden = NO;
                                                         self.rejectButton.hidden = NO;
                                                         break;
                                                     case 1:
                                                         self.commonButton = [self addButtonWithType:@(3) andTitle:@"发货"];
                                                         break;
                                                     case 2:
                                                         self.statusLabel.text = @"您已拒绝该申请";
                                                         break;
                                                     case 3:
                                                         self.statusLabel.text = @"您已发货";
                                                         self.statusLabel.hidden = NO;
                                                         button.hidden = YES;
                                                         break;
                                                     case 4:
                                                         self.statusLabel.text = @"订单已完成";
                                                         self.statusLabel.hidden = NO;
                                                         button.hidden = YES;
                                                         break;
                                                     case 5:
                                                         self.statusLabel.text = @"等待对方归还";
                                                         self.statusLabel.hidden = NO;
                                                         button.hidden = YES;
                                                         break;
                                                     case 6:
                                                         self.commonButton = [self addButtonWithType:@(7) andTitle:@"确认收货"];
                                                         break;
                                                     case 7:
                                                         self.statusLabel.text = @"订单已完成";
                                                         self.statusLabel.hidden = NO;
                                                         button.hidden = YES;
                                                         break;
                                                     default:
                                                         break;
                                                         
                                                 }
                                             }else{
                                                 switch ([type integerValue]) {
                                                     case 0:
                                                         self.statusLabel.text = @"等待对方处理";
                                                         self.statusLabel.hidden = NO;
                                                         button.hidden = YES;
                                                         break;
                                                     case 1:
                                                         self.statusLabel.text = @"等待对方发货";
                                                         self.statusLabel.hidden = NO;
                                                         button.hidden = YES;
                                                         break;
                                                     case 2:
                                                         self.statusLabel.text = @"对方已拒绝";
                                                         self.statusLabel.hidden = NO;
                                                         button.hidden = YES;
                                                         break;
                                                     case 3:
                                                         self.commonButton = [self addButtonWithType:@(4) andTitle:@"确认收货"];
                                                         break;
                                                     case 4:
                                                         self.statusLabel.text = @"订单已完成";
                                                         self.statusLabel.hidden = NO;
                                                         button.hidden = YES;
                                                         break;
                                                     case 5:
                                                         self.commonButton = [self addButtonWithType:@(6) andTitle:@"归还"];
                                                         break;
                                                     case 6:
                                                         self.statusLabel.text = @"已归还";
                                                         self.statusLabel.hidden = NO;
                                                         button.hidden = YES;
                                                         break;
                                                     case 7:
                                                         self.statusLabel.text = @"订单已完成";
                                                         self.statusLabel.hidden = NO;
                                                         button.hidden = YES;
                                                         break;
                                                     default:
                                                         break;
                                                 }
                                                 
                                             }
                                             
                                         } failure:^(ULBaseRequest *request, NSError *error) {
                                             [ULProgressHUD hide];
                                             [ULProgressHUD showWithMsg:@"请求失败"];
                                         } withPath:@"ulab_item/item/itemOrder/status"];
        
    }];
    
    return button;
}


- (void)updateConstraints
{
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self).offset(64+18);
        make.height.mas_equalTo(100);
    }];
    [self.detailTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.headerView.mas_bottom).offset(4);
        make.height.mas_equalTo(45*_nameArray.count);
    }];
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.detailTableView.mas_bottom).offset(30);
    }];
    [self.agreeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self).offset(-60);
        make.top.equalTo(self.detailTableView.mas_bottom).offset(30);
        make.size.mas_equalTo(CGSizeMake(90, 40));
    }];
    [self.rejectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self).offset(60);
        make.size.top.equalTo(self.agreeButton);
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

- (UIButton *)agreeButton
{
    if (!_agreeButton)
    {
        _agreeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _agreeButton.backgroundColor = KButtonBlueColor;
        [_agreeButton setTitle:@"同意" forState:UIControlStateNormal];
        [_agreeButton setTitleColor:kCommonWhiteColor forState:UIControlStateNormal];
        _agreeButton.layer.cornerRadius = 5;
        _agreeButton.layer.masksToBounds = YES;
        [[_agreeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            ULBaseRequest *request = [[ULBaseRequest alloc]init];
            request.isJson = NO;
            [request postDataWithParameter:@{
                                             @"itemOrderId" : @(self.model.orderId),
                                             @"status" : @1
                                             } session:YES progress:nil success:^(ULBaseRequest *request, NSDictionary *responseObject) {
                                                 [ULProgressHUD hide];
                                                 self.agreeButton.hidden = YES;
                                                 self.rejectButton.hidden = YES;
                                                 self.commonButton = [self addButtonWithType:@(3) andTitle:@"发货"];
                                             } failure:^(ULBaseRequest *request, NSError *error) {
                                                 [ULProgressHUD hide];
                                                 [ULProgressHUD showWithMsg:@"请求失败"];
                                             } withPath:@"ulab_item/item/itemOrder/status"];
        }];
        
        
    }     return _agreeButton;
}

- (UIButton *)rejectButton
{
    if (!_rejectButton)
    {
        _rejectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _rejectButton.backgroundColor = kCommonRedColor;
        [_rejectButton setTitle:@"拒绝" forState:UIControlStateNormal];
        [_rejectButton setTitleColor:kCommonWhiteColor forState:UIControlStateNormal];
        _rejectButton.layer.cornerRadius = 5;
        _rejectButton.layer.masksToBounds = YES;
        [[_rejectButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            ULBaseRequest *request = [[ULBaseRequest alloc]init];
            request.isJson = NO;
            [request postDataWithParameter:@{
                                             @"itemOrderId" : @(self.model.orderId),
                                             @"status" : @2
                                             } session:YES progress:nil success:^(ULBaseRequest *request, NSDictionary *responseObject) {
                                                 [ULProgressHUD hide];
                                                 self.agreeButton.hidden = YES;
                                                 self.rejectButton.hidden = YES;
                                                 self.statusLabel.hidden = NO;
                                                 self.statusLabel.text = @"已拒绝";
                                             } failure:^(ULBaseRequest *request, NSError *error) {
                                                 [ULProgressHUD hide];
                                                 [ULProgressHUD showWithMsg:@"请求失败"];
                                             } withPath:@"ulab_item/item/itemOrder/status"];
        }];
    }
    return _rejectButton;
}
- (UIView *)headerView
{
    if (!_headerView)
    {
        _headerView = [[UIView alloc] init];
        _headerView.backgroundColor = kCommonWhiteColor;
        UIImageView *headerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ulab_object_default"]];
        headerImageView.layer.cornerRadius = 25.5;
        headerImageView.layer.masksToBounds = YES;
        [_headerView addSubview:headerImageView];
        [headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_headerView);
            make.left.equalTo(_headerView).offset(15);
            make.size.mas_equalTo(CGSizeMake(51,51));
        }];
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.text = @"";
        nameLabel.font = kFont(kStandardPx(34));
        [_headerView addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(headerImageView.mas_right).offset(17);
            make.top.equalTo(_headerView).offset(21.5);
        }];
        UILabel *placeLabel = [[UILabel alloc] init];
        placeLabel.text = @"重庆市第三人民医院生物研究中心";
        placeLabel.font = kFont(kStandardPx(28));
        placeLabel.textColor = KTextGrayColor;
        [_headerView addSubview:placeLabel];
        [placeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(nameLabel);
            make.top.equalTo(nameLabel.mas_bottom).offset(12);
        }];
    }
    return _headerView;
}

- (UITableView *)detailTableView
{
    if (!_detailTableView)
    {
        _detailTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _detailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _detailTableView.delegate = self;
        _detailTableView.dataSource = self;
        _detailTableView.backgroundColor = kCommonWhiteColor;
        _detailTableView.rowHeight = 45;
        [_detailTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ULLendApplyTableViewCellIdentifier"];
        
    }
    return _detailTableView;
}

- (UILabel *)statusLabel
{
    if (!_statusLabel)
    {
        _statusLabel = [[UILabel alloc] init];
        _statusLabel.font = kFont(kStandardPx(30));
        _statusLabel.textColor = KTextGrayColor;
        _statusLabel.text = @"您已同意该申请";
    }
    return _statusLabel;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.detailTableView dequeueReusableCellWithIdentifier:@"ULLendApplyTableViewCellIdentifier"];
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = _nameArray[indexPath.row];
    nameLabel.font = kFont(kStandardPx(30));
    nameLabel.textColor = KTextGrayColor;
    [cell addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell).offset(15);
        make.centerY.equalTo(cell);
    }];
    UILabel *detailLabel = [[UILabel alloc] init];
    detailLabel.textColor = [UIColor colorWithRGBHex:0x333333];
    detailLabel.text = _detailArray[indexPath.row];
    detailLabel.font = kFont(kStandardPx(30));
    detailLabel.textAlignment = NSTextAlignmentCenter;
    [cell addSubview:detailLabel];
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLabel.mas_right);
        make.centerY.equalTo(nameLabel);
        make.right.equalTo(cell).offset(-15);
    }];
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = kBackgroundColor;
    [cell addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.and.left.and.right.equalTo(cell);
        make.height.mas_equalTo(0.5);
    }];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _nameArray.count;
}

@end
