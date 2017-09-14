//
//  ULUserOrderView.m
//  U-Lab
//
//  Created by 周维康 on 2017/6/2.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULUserOrderView.h"
#import "ULMyOrderTableViewCell.h"
#import "ULSegmentView.h"
#import "ULUserOrderViewModel.h"
#import "ULUserOrderModel.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ULUserOrderView() <UITableViewDelegate, UITableViewDataSource,ULSegmentViewDelegate>
@property (nonatomic, strong) ULSegmentView *segmentView;  /**< *顶部导航 */
@property (nonatomic, strong) UITableView *lendTableView;  /**< 借出 */
@property (nonatomic, strong) UITableView *borrowTableView;  /**< 借入 */
@property (nonatomic, strong) UIImageView *bottomView;  /**< 底部花篮 */
@property (nonatomic, strong) ULUserOrderViewModel *viewModel;  /**< VM */

@end
@implementation ULUserOrderView
{
    NSMutableArray *_lendArray;
    NSMutableArray *_borrowArray;
    NSInteger _lendPage;
    NSInteger _borrowPage;
}

- (ULSegmentView *)segmentView
{
    if (!_segmentView)
    {
        _segmentView = [[ULSegmentView alloc] initWithItems:@[@"借入", @"借出"] viewArray:@[self.borrowTableView, self.lendTableView]];
        _segmentView.delegate = self;
    }
    return _segmentView;
}

- (void)ul_setupViews
{
    _lendArray = [NSMutableArray array];
    _borrowArray = [NSMutableArray array];
    _lendPage = _borrowPage = 1;
    self.nextSubject = [RACSubject subject];
    [self addSubview:self.segmentView];
    [self addSubview:self.bottomView];
    [self updateConstraintsIfNeeded];
    [self setNeedsUpdateConstraints];
}

- (void)ul_bindViewModel
{
    self.viewModel = [[ULUserOrderViewModel alloc] init];
    [self.viewModel.orderCommand execute:@{
                                           @"type" : @0,
                                           @"page" : @(_borrowPage),
                                           @"size" : @10
                                           }];
    [self.viewModel.orderCommand execute:@{
                                           @"page" : @(_lendPage),
                                           @"type" : @1,
                                           @"size" : @10
                                           }];
    @weakify(self)
    [self.viewModel.orderSubject subscribeNext:^(id x) {
        @strongify(self)
        NSArray *result = x[@"response"];
        if (result.count == 0)
        {
            [ULProgressHUD hide];
            [self endRefresh];
            [self endRefreshWithNomoreData];
            return;
        }
        if ([x[@"type"] integerValue]==0)
        {
            [_borrowArray addObjectsFromArray:x[@"response"]];
            [self.borrowTableView reloadData];
        } else if ([x[@"type"] integerValue] == 1) {
            [_lendArray addObjectsFromArray:x[@"response"]];
            [self.lendTableView reloadData];
        }
        [self endRefresh];
    }];
    [self.viewModel.orderSubject subscribeError:^(NSError *error) {
        [ULProgressHUD showWithMsg:@"请求失败" inView:self];
    }];
}
- (void)updateConstraints
{
    [self.segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self).offset(64);
        make.bottom.equalTo(self).offset(-33);
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.top.equalTo(self.segmentView.mas_bottom);
    }];
    [super updateConstraints];
}

- (UITableView *)lendTableView
{
    if (!_lendTableView)
    {
        _lendTableView = [[UITableView alloc] init];
        _lendTableView.delegate = self;
        _lendTableView.dataSource = self;
        _lendTableView.rowHeight = 88;
        _lendTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _lendTableView.backgroundColor = kBackgroundColor;
        [_lendTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ULUserOrderLendTableViewCellIdentifier"];
        _lendTableView.mj_footer.automaticallyHidden = YES;
        @weakify(self)
        _lendTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            @strongify(self)
            [_lendArray removeAllObjects];
            _lendPage = 1;
            [self.viewModel.orderCommand execute:@{@"type" : @1, @"page": @(_lendPage), @"size":@10}];
        }];
        _lendTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            _lendPage++;
            [self.viewModel.orderCommand execute:@{@"type" : @1, @"page": @(_lendPage), @"size":@10}];
        }];
        
    }
    return _lendTableView;
}
- (UITableView *)borrowTableView
{
    if (!_borrowTableView)
    {
        _borrowTableView = [[UITableView alloc] init];
        _borrowTableView.delegate = self;
        _borrowTableView.dataSource = self;
        _borrowTableView.rowHeight = 88;
        _borrowTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _borrowTableView.backgroundColor = kBackgroundColor;
        [_borrowTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ULUserOrderBorrowTableViewCellIdentifier"];
        _borrowTableView.mj_footer.automaticallyHidden = YES;
        @weakify(self)
        _borrowTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            @strongify(self)
            [_borrowArray removeAllObjects];
            _borrowPage = 1;
            [self.viewModel.orderCommand execute:@{@"type" : @0, @"page": @(_borrowPage), @"size":@10}];
        }];
        _borrowTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            _borrowPage++;
            [self.viewModel.orderCommand execute:@{@"type" : @0, @"page": @(_borrowPage), @"size":@10}];
        }];
        
    }
    return _borrowTableView;
}

- (void)segView:(ULSegmentView *)segmentView didSelectedIndex:(NSUInteger)index{
    [self.viewModel.orderCommand execute:@{
                                           @"type" : @(index),
                                           @"page" : @(_borrowPage),
                                           @"size" : @10
                                           }];
    @weakify(self)
    [self.viewModel.orderSubject subscribeNext:^(id x) {
        @strongify(self)
        NSArray *result = x[@"response"];
        if (result.count == 0)
        {
            [ULProgressHUD hide];
            [self endRefresh];
            [self endRefreshWithNomoreData];
            return;
        }
        if ([x[@"type"] integerValue]==0)
        {
            _borrowArray = x[@"response"];
            [self.borrowTableView reloadData];
        } else if ([x[@"type"] integerValue] == 1) {
            _lendArray = x[@"response"];
            [self.lendTableView reloadData];
        }
        [self endRefresh];
    }];}

- (void)endRefresh
{
    [self.borrowTableView.mj_footer endRefreshing];
    [self.borrowTableView.mj_header endRefreshing];
    [self.lendTableView.mj_header endRefreshing];
    [self.lendTableView.mj_footer endRefreshing];
}

- (void)endRefreshWithNomoreData
{
    [self.borrowTableView.mj_footer endRefreshingWithNoMoreData];
    [self.lendTableView.mj_footer endRefreshingWithNoMoreData];
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
    if (tableView == self.lendTableView)
    {
        return _lendArray.count;
    } else {
        return _borrowArray.count;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic;
    if (tableView == self.borrowTableView){
        dic = @{@"data":_borrowArray[indexPath.row],@"type":@0};
    }else{
        dic = @{@"data":_lendArray[indexPath.row],@"type":@1};
    }
    [self.nextSubject sendNext:dic];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    ULUserOrderModel *model = [[ULUserOrderModel alloc] init];
    if (tableView == self.lendTableView)
    {
        cell = [self.lendTableView dequeueReusableCellWithIdentifier:@"ULUserOrderLendTableViewCellIdentifier"];
        model = _lendArray[indexPath.row];
    } else {
        cell = [self.borrowTableView dequeueReusableCellWithIdentifier:@"ULUserOrderBorrowTableViewCellIdentifier"];
        model = _borrowArray[indexPath.row];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    for (UIView *subView in cell.subviews)
    {
        [subView removeFromSuperview];
    }
    UIImageView *imageView = [[UIImageView alloc]init];
    [imageView sd_setImageWithURL:[NSURL URLWithString:model.imageURL] placeholderImage:[UIImage imageNamed:@"ulab_user_default"]];
    imageView.layer.masksToBounds = YES;
    imageView.layer.cornerRadius = 25.5;
    [cell addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(51, 51));
        make.left.equalTo(cell).offset(15);
        make.centerY.equalTo(cell);
    }];
    UILabel *nameLabel = [[UILabel alloc] init];
    
    
    nameLabel.textColor = [UIColor blackColor];
    nameLabel.font = kFont(kStandardPx(34));
    [cell addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView.mas_right).offset(17);
        make.top.equalTo(cell).offset(21);
    }];
    UILabel *detailLabel = [[UILabel alloc] init];
    NSString *detailString;
    if (tableView == self.borrowTableView) {
        detailString = [NSString stringWithFormat:@"你向%@借用%@", model.receiverName,model.orderName];
        nameLabel.text = model.receiverName;
    }else{
        detailString = [NSString stringWithFormat:@"向你借用%@",model.orderName];
        nameLabel.text = model.senderName;
    }

    detailLabel.textColor = KTextGrayColor;
    detailLabel.text = detailString;
    detailLabel.font = kFont(kStandardPx(28));
    [cell addSubview:detailLabel];
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLabel);
        make.top.equalTo(nameLabel.mas_bottom).offset(13);
    }];
    UIButton *statusLabel = [UIButton buttonWithType:UIButtonTypeCustom];
    statusLabel.titleLabel.font = kFont(kStandardPx(30));
    statusLabel.userInteractionEnabled = NO;
    statusLabel.layer.cornerRadius = 5;
    statusLabel.layer.masksToBounds = YES;
    [statusLabel.titleLabel adjustsFontSizeToFitWidth];
    switch (model.orderStatus) {
        case 0:
        {if (tableView == self.lendTableView)
        {
            [statusLabel setTitle:@"待处理" forState:UIControlStateNormal];
            statusLabel.userInteractionEnabled = YES;
            [statusLabel setTitleColor:kCommonYellowColor forState:UIControlStateNormal];
            
        } else {
            [statusLabel setTitle:@"待处理" forState:UIControlStateNormal];
            statusLabel.userInteractionEnabled = YES;
            [statusLabel setTitleColor:kCommonYellowColor forState:UIControlStateNormal];
        }
        }
            break;
        case 1:
        {
            if (tableView == _lendTableView) {
                [statusLabel setTitle:@"待发货" forState:UIControlStateNormal];
                statusLabel.userInteractionEnabled = YES;
                [statusLabel setTitleColor:kCommonYellowColor forState:UIControlStateNormal];
            }else{
                [statusLabel setTitle:@"待发货" forState:UIControlStateNormal];
                statusLabel.userInteractionEnabled = NO;
                [statusLabel setTitleColor:kCommonYellowColor forState:UIControlStateNormal];
            }
        }
            break;
        case 2:
        {
            if (tableView == _lendTableView) {
                [statusLabel setTitle:@"已拒绝" forState:UIControlStateNormal];
                [statusLabel setTitleColor:kCommonRedColor forState:UIControlStateNormal];
                statusLabel.userInteractionEnabled = NO;
            }else{
                [statusLabel setTitle:@"已拒绝" forState:UIControlStateNormal];
                [statusLabel setTitleColor:kCommonRedColor forState:UIControlStateNormal];
                statusLabel.userInteractionEnabled = NO;
            }
            
        }
            break;
        case 3:
            if (tableView == self.lendTableView) {
                [statusLabel setTitle:@"已发货" forState:UIControlStateNormal];
                [statusLabel setTitleColor:kCommonGreenColor forState:UIControlStateNormal];
                statusLabel.userInteractionEnabled = NO;
            }else{
                [statusLabel setTitle:@"已发货" forState:UIControlStateNormal];
                statusLabel.userInteractionEnabled = YES;
                [statusLabel setTitleColor:kCommonGreenColor forState:UIControlStateNormal];
                
            }
            break;
        case 5:
        {
                [statusLabel setTitle:@"待归还" forState:UIControlStateNormal];
                statusLabel.userInteractionEnabled = NO;
                [statusLabel setTitleColor:kCommonYellowColor forState:UIControlStateNormal];
        }
            break;
        case 4:
            [statusLabel setTitle:@"订单完成" forState:UIControlStateNormal];
            statusLabel.userInteractionEnabled = NO;
            [statusLabel setTitleColor:kCommonBlueColor forState:UIControlStateNormal];
            break;
        case 6:
        {
                [statusLabel setTitle:@"运送中" forState:UIControlStateNormal];
                statusLabel.userInteractionEnabled = NO;
                [statusLabel setTitleColor:kCommonYellowColor forState:UIControlStateNormal];

        }
            break;
        case 7:
        {
            [statusLabel setTitle:@"订单完成" forState:UIControlStateNormal];
            [statusLabel setTitleColor:kCommonBlueColor forState:UIControlStateNormal];
            statusLabel.userInteractionEnabled = NO;
        }
            break;
        default:
            break;
    }
    [cell addSubview:statusLabel];
    [statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(cell).offset(-18);
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
@end
