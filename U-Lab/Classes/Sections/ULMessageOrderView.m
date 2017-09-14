//
//  ULMessageOrderView.m
//  U-Lab
//
//  Created by 周维康 on 2017/6/8.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULMessageOrderView.h"
#import "ULUserObjectModel.h"
#import "ULMessageOrderViewModel.h"
#import "ULUserOrderModel.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ULMessageOrderView() <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIScrollView *scrollView;  /**< 滑动背景板 */
@property (nonatomic, strong) UITableView *lendTableView;  /**< 借用列表 */
@property (nonatomic, strong) UITableView *inTableView;  /**< 入库 */
@property (nonatomic, strong) UITableView *buyTableView;  /**< 购买 */
@property (nonatomic, strong) UIButton *lendButton;  /**< lend */
@property (nonatomic, strong) UIButton *inButton;  /**< in */
@property (nonatomic, strong) UIButton *buyButton;  /**< buy */
@property (nonatomic, strong) ULMessageOrderViewModel *viewModel;  /**< Vm */
@property (nonatomic, strong) UIView *lendRedView;
@property (nonatomic, strong) UIView *buyRedView;

@end

@implementation ULMessageOrderView
{
    NSArray *_lendArray;
    NSArray *_inArray;
    NSArray *_buyArray2;
    NSArray *_buyArray1;
    NSMutableArray *_buyArray;
    BOOL _isHaveNew;
}

- (void)updateOrderList
{
    if ([[ULUserMgr sharedMgr].role isEqual:@0])
    {
        [self.lendTableView reloadData];
        self.buyTableView.hidden = YES;
        self.buyButton.hidden = YES;
        self.viewModel = [[ULMessageOrderViewModel alloc]init];
        @weakify(self)
        [self.viewModel.getLendCommand execute:@{@"type":@(1),@"page":@(1),@"size":@(10)}];
        [self.viewModel.lendSubject subscribeNext:^(id x) {
            @strongify(self)
            self.lendRedView.hidden = YES;
            _lendArray = x[@"response"];
            for (int i = 0; i < _lendArray.count; i++) {
                ULUserOrderModel *model = _lendArray[i];
                if (model.status == 0) {
                    _lendRedView.hidden = NO;
                }
            }
            if (self.lendButton.isSelected) {
                [self.lendTableView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(_buyArray.count*88);
                }];
            }
            _scrollView.contentSize = CGSizeMake(screenWidth, (_lendArray.count+_inArray.count+_buyArray.count)*88+45*3+20);
            [self.lendTableView reloadData];
        }];
        [self.viewModel.inCommand execute:@{@"type":@(-1),@"page":@(1),@"size":@(20)}];
        [self.viewModel.inSubject subscribeNext:^(id x) {
            @strongify(self)
            _inArray = x;
            if (self.inButton.isSelected) {
                [self.inTableView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(_buyArray.count*88);
                }];
            }
            _scrollView.contentSize = CGSizeMake(screenWidth, (_lendArray.count+_inArray.count+_buyArray.count)*88+45*3+20);
            [self.inTableView reloadData];
        }];
    } else {
        self.viewModel = [[ULMessageOrderViewModel alloc]init];
        @weakify(self)
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self.viewModel.getCommand execute:@{
                                                 @"labId" : @([ULUserMgr sharedMgr].laboratoryId) ,
                                                 @"status" : @(-1)
                                                 }];
        });
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self.viewModel.getCommand execute:@{
                                                 @"labId" : @([ULUserMgr sharedMgr].laboratoryId) ,
                                                 @"status" : @(1)
                                                 }];
        });
        [self.viewModel.objectSubject subscribeNext:^(id x) {
            @strongify(self)
            self.buyRedView.hidden = YES;
            if ([x[@"status"] integerValue] == -1) {
                _buyArray1 = x[@"response"];
            }else{
                _buyArray2 = x[@"response"];
            }
            _buyArray = [NSMutableArray array];
            [_buyArray removeAllObjects];
            if (_buyArray1&&_buyArray1.count>0) {
                [_buyArray addObjectsFromArray:_buyArray1];
            }
            if (_buyArray2&&_buyArray2.count>0) {
                [_buyArray addObjectsFromArray:_buyArray2];
            }
            if (_buyArray.count > 0) {
                self.buyRedView.hidden = NO;
            }
            _scrollView.contentSize = CGSizeMake(screenWidth, (_lendArray.count+_inArray.count+_buyArray.count)*88+45*3+20);
            if (self.buyButton.isSelected) {
                [self.buyTableView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(_buyArray.count*88);
                }];
            }
            [self.buyTableView reloadData];
            }];
        
        
        [self.viewModel.getLendCommand execute:@{@"type":@(1),@"page":@(1),@"size":@(20)}];
        [self.viewModel.lendSubject subscribeNext:^(id x) {
            @strongify(self)
            self.lendRedView.hidden = YES;
            _lendArray = x[@"response"];
            for (int i = 0; i < _lendArray.count; i++) {
                ULUserOrderModel *model = _lendArray[i];
                if (model.status == 0) {
                    _lendRedView.hidden = NO;
                }
            }
            _scrollView.contentSize = CGSizeMake(screenWidth, (_lendArray.count+_inArray.count+_buyArray.count)*88+45*3+20);
            if (self.lendButton.isSelected) {
                [self.lendTableView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(_lendArray.count*88);
                }];
            }
            [self.lendTableView reloadData];
        }];
        
        [self.viewModel.inCommand execute:@{@"type":@(-1),@"page":@(1),@"size":@(20)}];
        [self.viewModel.inSubject subscribeNext:^(id x) {
            @strongify(self)
            _inArray = x;
            _scrollView.contentSize = CGSizeMake(screenWidth, (_lendArray.count+_inArray.count+_buyArray.count)*88+45*3+20);
            if (self.inButton.isSelected) {
                [self.inTableView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(_inArray.count*88);
                }];
                [self.buyButton layoutIfNeeded];
            }

            [self.inTableView reloadData];
        }];
    }
    
}

- (void)ul_setupViews
{
    _isHaveNew = NO;
    //    self.viewModel = [[ULMessageOrderViewModel alloc] init];
    self.nextSubject = [RACSubject subject];
    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.lendTableView];
    [self.scrollView addSubview:self.lendButton];
    [self.scrollView addSubview:self.inButton];
    [self.scrollView addSubview:self.inTableView];
    [self.scrollView addSubview:self.buyButton];
    [self.scrollView addSubview:self.buyTableView];
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
        make.top.equalTo(self);
        make.bottom.equalTo(self);
    }];
    [self.lendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.mas_equalTo(45);
        make.top.equalTo(self.scrollView);
    }];
    [self.lendTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.lendButton.mas_bottom);
        make.height.mas_equalTo(_lendArray.count*88);
    }];
    [self.inButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.lendTableView.mas_bottom);
        make.height.mas_equalTo(45);
    }];
    
    [self.inTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.inButton.mas_bottom);
        make.height.mas_equalTo(_inArray.count*88);
    }];
    [self.buyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.inTableView.mas_bottom);
        make.height.mas_equalTo(45);
    }];
    [self.buyTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.buyButton.mas_bottom);
        make.height.mas_equalTo(_buyArray.count*88);
    }];
    [super updateConstraints];
}


- (UITableView *)lendTableView
{
    if (!_lendTableView)
    {
        _lendTableView = [[UITableView alloc] init];
        _lendTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _lendTableView.delegate = self;
        _lendTableView.dataSource = self;
        _lendTableView.rowHeight = 88;
        _lendTableView.backgroundColor = kCommonWhiteColor;
        _lendTableView.scrollEnabled = NO;
        [_lendTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ULMessageOrderLendTableViewCellIdentifier"];
    }
    return _lendTableView;
}

- (UITableView *)inTableView
{
    if (!_inTableView)
    {
        _inTableView = [[UITableView alloc] init];
        _inTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _inTableView.delegate = self;
        _inTableView.dataSource = self;
        _inTableView.rowHeight = 88;
        _inTableView.backgroundColor = kCommonWhiteColor;
        _inTableView.scrollEnabled = NO;
        [_inTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ULMessageOrderInTableViewCellIdentifier"];
    }
    return _inTableView;
}

- (UITableView *)buyTableView
{
    if (!_buyTableView)
    {
        _buyTableView = [[UITableView alloc] init];
        _buyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _buyTableView.delegate = self;
        _buyTableView.dataSource = self;
        _buyTableView.rowHeight = 88;
        _buyTableView.scrollEnabled = NO;
        _buyTableView.backgroundColor = kCommonWhiteColor;
        [_buyTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ULMessageOrderBuyTableViewCellIdentifier"];
    }
    return _buyTableView;
}

- (UIScrollView *)scrollView
{
    if (!_scrollView)
    {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.contentSize = CGSizeMake(screenWidth, (_lendArray.count+_inArray.count+_buyArray.count)*88+screenHeight-132);
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

- (UIButton *)lendButton
{
    if (!_lendButton)
    {
        _lendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _lendButton.backgroundColor = kCommonWhiteColor;
        UILabel *label = [[UILabel alloc] init];
        label.font = kFont(kStandardPx(32));
        label.textColor = kTextBlackColor;
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ulab_tableview_hide"]];
        [_lendButton addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_lendButton).offset(15);
            make.centerY.equalTo(_lendButton);
            make.size.mas_equalTo(CGSizeMake(11, 11));
        }];
        label.text = @"借用申请";
        [_lendButton addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imageView.mas_right).offset(5);
            make.centerY.equalTo(_lendButton);
        }];
        UIView *redView = [[UIView alloc]init];
        redView.backgroundColor = [UIColor redColor];
        redView.layer.masksToBounds = NO;
        redView.layer.cornerRadius = 5;
        [_lendButton addSubview:redView];
        [redView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(label.mas_right).offset(8);
            make.top.mas_offset(8);
            make.size.mas_equalTo(CGSizeMake(10, 10));
        }];
        redView.hidden = YES;
        self.lendRedView = redView;
        @weakify(self)
        [[_lendButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self)
            _lendButton.selected = !_lendButton.selected;
            if (_lendButton.isSelected)
            {
                imageView.image = [UIImage imageNamed:@"ulab_tableview_show"];
                [self.lendTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.equalTo(self);
                    make.top.equalTo(self.lendButton.mas_bottom);
                    make.height.mas_equalTo(_lendArray.count*88);
                }];
                self.scrollView.contentSize = CGSizeMake(screenWidth, (_lendArray.count+_inArray.count+_buyArray.count)*88+screenHeight-132);
                [self.lendTableView reloadData];
            } else {
                imageView.image = [UIImage imageNamed:@"ulab_tableview_hide"];
                [self.lendTableView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(0);
                }];
                self.scrollView.contentSize = CGSizeMake(screenWidth, (_inArray.count+_buyArray.count)*88+screenHeight-132);
            }
        }];
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = kBackgroundColor;
        [_lendButton addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(_lendButton);
            make.height.mas_equalTo(0.5);
        }];
    }
    return _lendButton;
}

- (UIButton *)inButton
{
    if (!_inButton)
    {
        _inButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _inButton.backgroundColor = kCommonWhiteColor;
        UILabel *label = [[UILabel alloc] init];
        label.font = kFont(kStandardPx(32));
        label.textColor = kTextBlackColor;
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ulab_tableview_hide"]];
        [_inButton addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_inButton).offset(15);
            make.centerY.equalTo(_inButton);
            make.size.mas_equalTo(CGSizeMake(11, 11));
        }];
        label.text = @"入库通知";
        [_inButton addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imageView.mas_right).offset(5);
            make.centerY.equalTo(_inButton);
        }];
        @weakify(self)
        [[_inButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self)
            _inButton.selected = !_inButton.selected;
            if (_inButton.isSelected)
            {
                imageView.image = [UIImage imageNamed:@"ulab_tableview_show"];
                [self.inTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.equalTo(self);
                    make.top.equalTo(self.inButton.mas_bottom);
                    make.height.mas_equalTo(_inArray.count*88);
                }];
                self.scrollView.contentSize = CGSizeMake(screenWidth, (_lendArray.count+_inArray.count+_buyArray.count)*88+screenHeight-132);
                [self.inTableView reloadData];
            } else {
                imageView.image = [UIImage imageNamed:@"ulab_tableview_hide"];
                [self.inTableView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(0);
                }];
                self.scrollView.contentSize = CGSizeMake(screenWidth, (_lendArray.count+_buyArray.count)*88+screenHeight-132);
            }
        }];
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = kBackgroundColor;
        [_inButton addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(_inButton);
            make.height.mas_equalTo(0.5);
        }];
    }
    return _inButton;
}

- (UIButton *)buyButton
{
    if (!_buyButton)
    {
        _buyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _buyButton.backgroundColor = kCommonWhiteColor;
        UILabel *label = [[UILabel alloc] init];
        label.font = kFont(kStandardPx(32));
        label.textColor = kTextBlackColor;
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ulab_tableview_hide"]];
        [_buyButton addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_buyButton).offset(15);
            make.centerY.equalTo(_buyButton);
            make.size.mas_equalTo(CGSizeMake(11, 11));
        }];
        label.text = @"购买申请";
        [_buyButton addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imageView.mas_right).offset(5);
            make.centerY.equalTo(_buyButton);
        }];
        UIView *redView = [[UIView alloc]init];
        redView.backgroundColor = [UIColor redColor];
        redView.layer.masksToBounds = NO;
        redView.layer.cornerRadius = 5;
        [_buyButton addSubview:redView];
        [redView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(label.mas_right).offset(8);
            make.top.mas_offset(8);
            make.size.mas_equalTo(CGSizeMake(10, 10));
        }];
        redView.hidden = YES;
        self.buyRedView = redView;
        @weakify(self)
        [[_buyButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self)
            _buyButton.selected = !_buyButton.selected;
            if (_buyButton.isSelected)
            {
                imageView.image = [UIImage imageNamed:@"ulab_tableview_show"];
                [self.buyTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(_buyArray.count*88);
                    make.left.right.equalTo(self);
                    make.top.equalTo(_buyButton.mas_bottom);
                }];
                self.scrollView.contentSize = CGSizeMake(screenWidth, (_lendArray.count+_inArray.count+_buyArray.count)*88+screenHeight-132);
                [self.buyTableView reloadData];
                
            } else {
                imageView.image = [UIImage imageNamed:@"ulab_tableview_hide"];
                [self.buyTableView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(0);
                }];
                self.scrollView.contentSize = CGSizeMake(screenWidth, (_inArray.count+_lendArray.count)*88+screenHeight-132);
            }
        }];
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = kBackgroundColor;
        [_buyButton addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(_buyButton);
            make.height.mas_equalTo(0.5);
        }];
    }
    return _buyButton;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.lendTableView)
    {
        return _lendArray.count;
    } else if (tableView == self.inTableView) {
        return _inArray.count;
    } else {
        return _buyArray.count;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == self.lendTableView)
    {
        [self.nextSubject sendNext:@{@"type":@0,@"response":_lendArray[indexPath.row]}];
    } else if (tableView == self.inTableView) {
        [self.nextSubject sendNext:@{@"type":@1,@"response":_inArray[indexPath.row]}];
    } else {
        [self.nextSubject sendNext:@{@"type":@2,@"response":_buyArray[indexPath.row]}];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (tableView == self.lendTableView)
    {
        cell = [self.lendTableView dequeueReusableCellWithIdentifier:@"ULMessageOrderLendTableViewCellIdentifier"];
        ULUserOrderModel *model = _lendArray[indexPath.row];
        for (UIView *subview in cell.subviews)
        {
            [subview removeFromSuperview];
        }
        UIImageView *headerImageView = [[UIImageView alloc] init];
        [headerImageView sd_setImageWithURL:[NSURL URLWithString:model.imageURL] placeholderImage:[UIImage imageNamed:@"ulab_user_default"]];
        headerImageView.layer.cornerRadius = 25.5;
        headerImageView.layer.masksToBounds = YES;
        [cell addSubview:headerImageView];
        [headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell);
            make.left.equalTo(cell).offset(15);
            make.size.mas_equalTo(CGSizeMake(51, 51));
        }];
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.text = model.senderName;
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
        detailLabel.text = model.orderTime;
        [cell addSubview:detailLabel];
        [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(nameLabel);
            make.top.equalTo(nameLabel.mas_bottom).offset(13);
        }];
        
        UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        addButton.layer.cornerRadius = 5;
        addButton.layer.masksToBounds = YES;
        [cell addSubview:addButton];
        [addButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(cell).offset(-15);
            make.centerY.equalTo(cell);
            make.size.mas_equalTo(CGSizeMake(75, 30));
        }];
        detailLabel.text = [NSString stringWithFormat:@"向您借用%@", model.orderName];
        addButton.userInteractionEnabled = NO;
        switch (model.status) {
            case 0:
            {
                [addButton setTitle:@"同意" forState:UIControlStateNormal];
                addButton.backgroundColor = KButtonBlueColor;
                addButton.userInteractionEnabled = YES;
                [addButton setTitleColor:kCommonWhiteColor forState:UIControlStateNormal];
                
                [[addButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
                    ULBaseRequest *request = [[ULBaseRequest alloc]init];
                    [request postDataWithParameter:@{
                                                     @"itemOrderId" : @(model.orderId),
                                                     @"status" : @1
                                                     } session:YES progress:nil success:^(ULBaseRequest *request, NSDictionary *responseObject) {
                                                         [addButton setTitle:@"待发货" forState:UIControlStateNormal];
                                                         [addButton setTitleColor:kCommonYellowColor forState:UIControlStateNormal];
                                                         addButton.userInteractionEnabled = NO;
                                                         addButton.backgroundColor = [UIColor clearColor];
                                                         
                                                     } failure:^(ULBaseRequest *request, NSError *error) {
                                                         [ULProgressHUD showWithMsg:@"请求失败"];
                                                     } withPath:@"ulab_item/item/itemOrder/status"];
                }];
            }
                break;
            case 1:
            {
                [addButton setTitle:@"待发货" forState:UIControlStateNormal];
                [addButton setTitleColor:kCommonYellowColor forState:UIControlStateNormal];
            }
                break;
            case 2:
            {
                [addButton setTitle:@"已拒绝" forState:UIControlStateNormal];
                [addButton setTitleColor:kCommonRedColor forState:UIControlStateNormal];
            }
                break;
            case 3:
                [addButton setTitle:@"已发货" forState:UIControlStateNormal];
                [addButton setTitleColor:kCommonGreenColor forState:UIControlStateNormal];
                break;
            case 4:
                [addButton setTitle:@"订单完成" forState:UIControlStateNormal];
                [addButton setTitleColor:kCommonGreenColor forState:UIControlStateNormal];
                break;
            case 5:
                [addButton setTitle:@"待归还" forState:UIControlStateNormal];
                [addButton setTitleColor:kCommonYellowColor forState:UIControlStateNormal];
                break;
            case 6:
                [addButton setTitle:@"运送中" forState:UIControlStateNormal];
                [addButton setTitleColor:kCommonGreenColor forState:UIControlStateNormal];
                break;
            case 7:
                [addButton setTitle:@"订单完成" forState:UIControlStateNormal];
                [addButton setTitleColor:kCommonBlueColor forState:UIControlStateNormal];
                break;
            default:
                [addButton setTitle:@"已同意" forState:UIControlStateNormal];
                break;
        }
        
    } else if (tableView == self.inTableView) {
        cell = [self.inTableView dequeueReusableCellWithIdentifier:@"ULMessageOrderInTableViewCellIdentifier"];
        ULUserObjectModel *model = _inArray[indexPath.row];
        for (UIView *subview in cell.subviews)
        {
            [subview removeFromSuperview];
        }
        UIImageView *headerImageView = [[UIImageView alloc] init];
        if ([model.imageURL isKindOfClass:[NSNull class]]) {
            model.imageURL = @"";
        }
        [headerImageView sd_setImageWithURL:[NSURL URLWithString:model.imageURL?:@""] placeholderImage:[UIImage imageNamed:@"ulab_object_default"]];
        headerImageView.layer.cornerRadius = 25.5;
        headerImageView.layer.masksToBounds = YES;
        [cell addSubview:headerImageView];
        [headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell);
            make.left.equalTo(cell).offset(15);
            make.size.mas_equalTo(CGSizeMake(51, 51));
        }];
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.text = [NSString stringWithFormat:@"%@已成功入库",model.objectName];
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
        NSString *text;
        switch (model.objectType) {
            case 1:
                text = @"耗材";
                break;
            case 2:
                text = @"试剂";
                break;
            case 3:
                text = @"动物";
                break;
            case 4:
                text = @"仪器";
                break;
                
            default:
                text = @"其它";
                break;
        }
        detailLabel.text = text;
        [cell addSubview:detailLabel];
        [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(nameLabel);
            make.top.equalTo(nameLabel.mas_bottom).offset(13);
        }];
    } else {
        ULUserObjectModel *model;
        cell = [self.buyTableView dequeueReusableCellWithIdentifier:@"ULMessageOrderBuyTableViewCellIdentifier"];
        model = _buyArray[indexPath.row];
        for (UIView *subview in cell.subviews)
        {
            [subview removeFromSuperview];
        }
        UIImageView *headerImageView = [[UIImageView alloc] init];
        if ([model.imageURL isKindOfClass:[NSNull class]]) {
            model.imageURL = @"";
        }
        [headerImageView sd_setImageWithURL:[NSURL URLWithString:model.imageURL?:@""] placeholderImage:[UIImage imageNamed:@"ulab_user_default"]];
        headerImageView.layer.cornerRadius = 25.5;
        headerImageView.layer.masksToBounds = YES;
        [cell addSubview:headerImageView];
        [headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell);
            make.left.equalTo(cell).offset(15);
            make.size.mas_equalTo(CGSizeMake(51, 51));
        }];
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.text = model.userName;
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
        detailLabel.text = model.objectName;
        [cell addSubview:detailLabel];
        [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(nameLabel);
            make.top.equalTo(nameLabel.mas_bottom).offset(13);
        }];
        
        UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [cell addSubview:addButton];
        [addButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(cell).offset(-15);
            make.centerY.equalTo(cell);
            make.size.mas_equalTo(CGSizeMake(75, 30));
        }];
        [addButton setTitle:@"待处理" forState:UIControlStateNormal];
        //            addButton.backgroundColor = KButtonBlueColor;
        [addButton setTitleColor:KTextGrayColor forState:UIControlStateNormal];
        addButton.userInteractionEnabled = NO;
        addButton.layer.masksToBounds = YES;
        addButton.layer.cornerRadius = 5;
        detailLabel.text = [NSString stringWithFormat:@"申请购买%@", model.objectName];
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
