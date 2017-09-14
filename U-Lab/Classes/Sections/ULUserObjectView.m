//
//  ULUserObjectView.m
//  U-Lab
//
//  Created by 周维康 on 17/5/29.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULUserObjectView.h"
#import "ULSegmentView.h"
#import "ULUserObjectViewModel.h"
#import "ULUserObjectModel.h"
#import "ULLabViewModel.h"
#import <SDWebImage/UIImageView+WebCache.h>


@interface ULUserObjectView() <UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource,ULSegmentViewDelegate>

@property (nonatomic, strong) ULSegmentView *segmentView;  /**< 顶部选择栏 */
@property (nonatomic, strong) UITableView *oneTableView;  /**< 仪器列表 */
@property (nonatomic, strong) UIImageView *bottomView;  /**< 底部花篮 */
@property (nonatomic, strong) UITableView *twoTableView;  /**< 试剂列表 */
@property (nonatomic, strong) UITableView *threeTableView;  /**< 耗材列表 */
@property (nonatomic, strong) UITableView *fourTableView;  /**< 动物列表 */
@property (nonatomic, strong) UITableView *fiveTableView;  /**< 其他列表 */
@property (nonatomic, strong) ULUserObjectViewModel *viewModel;  /**< VM */

@end

@implementation ULUserObjectView
{
    NSMutableArray *_oneArray;
    NSMutableArray *_twoArray;
    NSMutableArray *_threeArray;
    NSMutableArray *_fourArray;
    NSMutableArray *_fiveArray;
    NSInteger _onePage;
    NSInteger _twoPage;
    NSInteger _threePage;
    NSInteger _fourPage;
    NSInteger _fivePage;
}

- (void)ul_bindViewModel
{
    _oneArray = [NSMutableArray array];
    _twoArray = [NSMutableArray array];
    _threeArray = [NSMutableArray array];
    _fourArray = [NSMutableArray array];
    _fiveArray = [NSMutableArray array];
    _onePage = _twoPage = _threePage = _fourPage = _fivePage = 1;
    self.viewModel = [[ULUserObjectViewModel alloc] init];
    [ULProgressHUD showWithMsg:@"物品获取中" inView:self withBlock:^{
        [self.viewModel.objectCommand execute:@{@"type" : @4, @"page": @(_onePage), @"size":@10 , @"labId" : @([ULUserMgr sharedMgr].laboratoryId)}];
    }];
    [self.viewModel.objectCommand execute:@{@"type" : @2, @"page": @(_twoPage), @"size":@10, @"labId" : @([ULUserMgr sharedMgr].laboratoryId)}];
    [self.viewModel.objectCommand execute:@{@"type" : @3, @"page": @(_threePage), @"size":@10, @"labId" : @([ULUserMgr sharedMgr].laboratoryId)}];
    [self.viewModel.objectCommand execute:@{@"type" : @4, @"page": @(_fourPage), @"size":@10, @"labId" : @([ULUserMgr sharedMgr].laboratoryId)}];
    [self.viewModel.objectCommand execute:@{@"type" : @5, @"page": @(_fivePage), @"size":@10, @"labId" : @([ULUserMgr sharedMgr].laboratoryId)}];
    @weakify(self)
    [self.viewModel.objectSubject subscribeNext:^(id x) {
        @strongify(self)
        NSArray *result = x[@"response"];
        if (result.count == 0)
        {
            [ULProgressHUD hide];
            [self endRefresh];
            [self endRefreshWithNomoreData];
            return;
        }
        switch([x[@"type"] integerValue])
        {
            case 1:{[_threeArray addObjectsFromArray:x[@"response"]]; [self.threeTableView reloadData];}break;
            case 2:{[_twoArray addObjectsFromArray:x[@"response"]]; [self.twoTableView reloadData];}break;
            case 3:{[_fourArray addObjectsFromArray:x[@"response"]]; [self.fourTableView reloadData];}break;
            case 4:{[_oneArray addObjectsFromArray:x[@"response"]]; [self.oneTableView reloadData];}break;
            case 5:{[_fiveArray addObjectsFromArray:x[@"response"]]; [self.fiveTableView reloadData];}break;
            default: nil;
        }
        [ULProgressHUD hide];
        [self endRefresh];
    }];
    [self.viewModel.objectCommand.executionSignals subscribeError:^(NSError *error) {
        [ULProgressHUD hide];
        [ULProgressHUD showWithMsg:@"请求失败" inView:self];
    }];
    [self.viewModel.objectCommand.errors subscribeNext:^(id x) {
        [ULProgressHUD hide];
    }];
}

- (void)ul_setupViews
{
    self.nextSubject = [RACSubject subject];
    [self addSubview:self.segmentView];
    [self addSubview:self.bottomView];
    [self updateConstraintsIfNeeded];
    [self setNeedsUpdateConstraints];
}

- (void)updateConstraints
{
    [self.segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(64);
        make.bottom.equalTo(self).offset(-33);
        make.left.right.equalTo(self);
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(33);
    }];
    [super updateConstraints];
}


- (void)segView:(ULSegmentView *)segmentView didSelectedIndex:(NSUInteger)index{
    switch (index) {
        case 0:
            [_oneArray removeAllObjects];
            [self.viewModel.objectCommand execute:@{@"type" : @(4), @"page": @(1), @"size":@10, @"labId" : @([ULUserMgr sharedMgr].laboratoryId)}];
            break;
        case 1:
            [_twoArray removeAllObjects];
            [self.viewModel.objectCommand execute:@{@"type" : @(2), @"page": @(1), @"size":@10, @"labId" : @([ULUserMgr sharedMgr].laboratoryId)}];
            break;
        case 2:
            [_threeArray removeAllObjects];
            [self.viewModel.objectCommand execute:@{@"type" : @(1), @"page": @(1), @"size":@10, @"labId" : @([ULUserMgr sharedMgr].laboratoryId)}];
            break;
        case 3:
            [_fourArray removeAllObjects];
            [self.viewModel.objectCommand execute:@{@"type" : @(3), @"page": @(1), @"size":@10, @"labId" : @([ULUserMgr sharedMgr].laboratoryId)}];
            break;
        case 4:
            [_fiveArray removeAllObjects];
            [self.viewModel.objectCommand execute:@{@"type" : @(5), @"page": @(1), @"size":@10, @"labId" : @([ULUserMgr sharedMgr].laboratoryId)}];
            break;
        default:
            break;
    }
    
}

- (ULSegmentView *)segmentView
{
    if (!_segmentView)
    {
        _segmentView = [[ULSegmentView alloc] initWithItems:@[@"仪器", @"试剂", @"耗材", @"动物", @"其他"] viewArray:@[self.oneTableView, self.twoTableView, self.threeTableView, self.fourTableView, self.fiveTableView]];
        _segmentView.delegate = self;
    }
    return _segmentView;
}

- (UITableView *)oneTableView
{
    if (!_oneTableView)
    {
        _oneTableView = [[UITableView alloc] init];
        [_oneTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ULUserObjectOneTableViewCellIdentifier"];
        _oneTableView.backgroundColor = kBackgroundColor;
        _oneTableView.delegate = self;
        _oneTableView.dataSource = self;
        _oneTableView.rowHeight = 88;
        _oneTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _oneTableView.mj_footer.automaticallyHidden = YES;
        @weakify(self)
        _oneTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            @strongify(self)
            [_oneArray removeAllObjects];
            _onePage = 1;
            [self.viewModel.objectCommand execute:@{@"type" : @4, @"page": @(_onePage), @"size":@10}];
        }];
        _oneTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            _onePage++;
            [self.viewModel.objectCommand execute:@{@"type" : @4, @"page": @(_onePage), @"size":@10}];
        }];
    }
    return _oneTableView;
}

- (UITableView *)twoTableView
{
    if (!_twoTableView)
    {
        _twoTableView = [[UITableView alloc] init];
        [_twoTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ULUserObjectTwoTableViewCellIdentifier"];
        _twoTableView.backgroundColor = kBackgroundColor;
        _twoTableView.delegate = self;
        _twoTableView.dataSource = self;
        _twoTableView.rowHeight = 88;
        _twoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _twoTableView.mj_footer.automaticallyHidden = YES;
        @weakify(self)
        _twoTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            @strongify(self)
            [_twoArray removeAllObjects];
            _twoPage = 1;
            [self.viewModel.objectCommand execute:@{@"type" : @2, @"page": @(_twoPage), @"size":@10}];
        }];
        _twoTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            _twoPage++;
            [self.viewModel.objectCommand execute:@{@"type" : @2, @"page": @(_twoPage), @"size":@10}];
        }];
        
    }
    return _twoTableView;
}

- (UITableView *)fourTableView
{
    if (!_fourTableView)
    {
        _fourTableView = [[UITableView alloc] init];
        [_fourTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ULUserObjectFourTableViewCellIdentifier"];
        _fourTableView.backgroundColor = kBackgroundColor;
        _fourTableView.delegate = self;
        _fourTableView.dataSource = self;
        _fourTableView.rowHeight = 88;
        _fourTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _fourTableView.mj_footer.automaticallyHidden = YES;
        @weakify(self)
        _fourTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            @strongify(self)
            [_fourArray removeAllObjects];
            _fourPage = 1;
            [self.viewModel.objectCommand execute:@{@"type" : @3, @"page": @(_fourPage), @"size":@10}];
        }];
        _fourTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            _fourPage++;
            [self.viewModel.objectCommand execute:@{@"type" : @3, @"page": @(_fourPage), @"size":@10}];
        }];
        
    }
    return _fourTableView;
}

- (UITableView *)threeTableView
{
    if (!_threeTableView)
    {
        _threeTableView = [[UITableView alloc] init];
        [_threeTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ULUserObjectThreeTableViewCellIdentifier"];
        _threeTableView.backgroundColor = kBackgroundColor;
        _threeTableView.delegate = self;
        _threeTableView.dataSource = self;
        _threeTableView.rowHeight = 88;
        _threeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _threeTableView.mj_footer.automaticallyHidden = YES;
        @weakify(self)
        _threeTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            @strongify(self)
            [_threeArray removeAllObjects];
            _threePage = 1;
            [self.viewModel.objectCommand execute:@{@"type" : @1, @"page": @(_threePage), @"size":@10}];
        }];
        _threeTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            _threePage++;
            [self.viewModel.objectCommand execute:@{@"type" : @1, @"page": @(_threePage), @"size":@10}];
        }];
        
    }
    return _threeTableView;
}

- (UITableView *)fiveTableView
{
    if (!_fiveTableView)
    {
        _fiveTableView = [[UITableView alloc] init];
        [_fiveTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ULUserObjectFiveTableViewCellIdentifier"];
        _fiveTableView.backgroundColor = kBackgroundColor;
        _fiveTableView.delegate = self;
        _fiveTableView.dataSource = self;
        _fiveTableView.rowHeight = 88;
        _fiveTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        @weakify(self)
        _fiveTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            @strongify(self)
            [_fiveArray removeAllObjects];
            _fivePage = 1;
            [self.viewModel.objectCommand execute:@{@"type" : @5, @"page": @(_fivePage), @"size":@10}];
        }];
        _fiveTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            _fivePage++;
            [self.viewModel.objectCommand execute:@{@"type" : @5, @"page": @(_fivePage), @"size":@10}];
        }];
        
    }
    return _fiveTableView;
}
- (UIImageView *)bottomView
{
    if (!_bottomView)
    {
        _bottomView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"register_bottom"]];
    }
    return _bottomView;
}

- (ULUserObjectViewModel *)viewModel
{
    if (!_viewModel)
    {
        _viewModel = [[ULUserObjectViewModel alloc] init];
    }
    return _viewModel;
}
#pragma mark - UITableViewDataSource&&Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.oneTableView)
    {
        return _oneArray.count;
    } else if (tableView == self.twoTableView) {
        return _twoArray.count;
    } else if (tableView == self.threeTableView) {
        return _threeArray.count;
    } else if (tableView == self.fourTableView){
        return _fourArray.count;
    } else {
        return _fiveArray.count;
    }
}

- (void)endRefresh
{
    [self.oneTableView.mj_footer endRefreshing];
    [self.oneTableView.mj_header endRefreshing];
    [self.twoTableView.mj_header endRefreshing];
    [self.twoTableView.mj_footer endRefreshing];
    [self.threeTableView.mj_footer endRefreshing];
    [self.threeTableView.mj_header endRefreshing];
    [self.fourTableView.mj_header endRefreshing];
    [self.fourTableView.mj_footer endRefreshing];
    [self.fiveTableView.mj_header endRefreshing];
    [self.fiveTableView.mj_footer endRefreshing];
}

- (void)endRefreshWithNomoreData
{
    [self.oneTableView.mj_footer endRefreshingWithNoMoreData];
    [self.twoTableView.mj_footer endRefreshingWithNoMoreData];
    [self.threeTableView.mj_footer endRefreshingWithNoMoreData];
    [self.fourTableView.mj_footer endRefreshingWithNoMoreData];
    [self.fiveTableView.mj_footer endRefreshingWithNoMoreData];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    ULUserObjectModel *model;
    if (tableView == self.oneTableView)
    {
        cell = [self.oneTableView dequeueReusableCellWithIdentifier:@"ULUserObjectOneTableViewCellIdentifier"];
        model = _oneArray[indexPath.row];
    } else if (tableView == self.twoTableView) {
        cell = [self.twoTableView dequeueReusableCellWithIdentifier:@"ULUserObjectTwoTableViewCellIdentifier"];
        model = _twoArray[indexPath.row];
    } else if (tableView == self.threeTableView) {
        cell = [self.threeTableView dequeueReusableCellWithIdentifier:@"ULUserObjectThreeTableViewCellIdentifier"];
        model = _threeArray[indexPath.row];
    } else if (tableView == self.fourTableView){
        cell = [self.fourTableView dequeueReusableCellWithIdentifier:@"ULUserObjectFourTableViewCellIdentifier"];
        model = _fourArray[indexPath.row];
    } else {
        cell = [self.fiveTableView dequeueReusableCellWithIdentifier:@"ULUserObjectFiveTableViewCellIdentifier"];
        model = _fiveArray[indexPath.row];
    }
    for (UIView *subView in cell.subviews)
    {
        [subView removeFromSuperview];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIImageView *imageView;
    if (model.imageURL){
        imageView = [[UIImageView alloc] init];
        [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.imageURL]] placeholderImage:[UIImage imageNamed:@"ulab_object_default"]];
    }
    else
        imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ulab_object_default"]];
    
    [cell addSubview:imageView];
    imageView.layer.masksToBounds = YES;
    imageView.layer.cornerRadius = 25.5;
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(51, 51));
        make.left.equalTo(cell).offset(15);
        make.centerY.equalTo(cell);
    }];
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = model.objectName;
    nameLabel.textColor = [UIColor blackColor];
    nameLabel.font = kFont(kStandardPx(34));
    nameLabel.adjustsFontSizeToFitWidth = YES;
    [cell addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView.mas_right).offset(17);
        make.top.equalTo(cell).offset(21);
        make.right.equalTo(cell).offset(-48);
    }];
    UILabel *numLabel = [[UILabel alloc] init];
    NSString *numString = [NSString stringWithFormat:@"数量：%li%@", model.objectQuantity, model.measureUnit];
    numLabel.textColor = KTextGrayColor;
    numLabel.text = numString;
    numLabel.font = kFont(kStandardPx(28));
    [cell addSubview:numLabel];
    [numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLabel);
        make.top.equalTo(nameLabel.mas_bottom).offset(13);
    }];
    UILabel *statusLabel = [[UILabel alloc] init];
    statusLabel.font = kFont(kStandardPx(30));
    if ([model.isUsing boolValue])
    {
        statusLabel.text = @"使用中";
        statusLabel.textColor = [UIColor colorWithRGBHex:0x5786EF];
    } else {
        statusLabel.text = @"未使用";
        statusLabel.textColor = KTextGrayColor;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ULUserObjectModel *model;
    if (tableView == self.oneTableView)
    {
        model = _oneArray[indexPath.row];
    } else if (tableView == self.twoTableView) {
        model = _twoArray[indexPath.row];
    } else if (tableView == self.threeTableView) {
        model = _threeArray[indexPath.row];
    } else if (tableView == self.fourTableView){
        model = _fourArray[indexPath.row];
    } else {
        model = _fiveArray[indexPath.row];
    }
    [self.nextSubject sendNext:model];
}
@end
