//
//  ULLabBusinessDetailViewController.m
//  ULab
//
//  Created by 周维康 on 2017/6/15.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULLabBusinessDetailViewController.h"
#import "ULLabBusinessViewModel.h"
@interface ULLabBusinessDetailViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSNumber *type;  /**< dic */
@property (nonatomic, strong) UITableView *tableView;  /**< tableView */
@property (nonatomic, strong) UILabel *dateLabel;  /**< label */
@property (nonatomic, strong) UIImageView *bottomView;  /**< 底部花篮 */
@property (nonatomic, strong) ULLabBusinessViewModel *viewModel;  /**< vm */
@end

@implementation ULLabBusinessDetailViewController
{
    NSArray *_detailArray;
    NSDate *_date;
}

- (instancetype)initWithType:(NSNumber *)type andDate:(NSDate *)date
{
    self.type = type;
    _date = date;
    if (self = [super init])
    {
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = kBackgroundColor;
    // Do any additional setup after loading the view.
    self.viewModel = [[ULLabBusinessViewModel alloc] init];
    if ([self.type integerValue] != 0) {
        [self.viewModel.detailCommand execute:@{
                                                @"type":self.type, //物品类型
                                                @"labId":@([ULUserMgr sharedMgr].laboratoryId), //实验室id
                                                @"year":@(_date.year), //年
                                                @"month":@(_date.month)
                                                }];
        @weakify(self)
        [self.viewModel.detailSubject subscribeNext:^(id x) {
            @strongify(self)
            _detailArray = x;
            [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(45*_detailArray.count);
            }];
            [self.tableView reloadData];
        }];
    }else{
        [self.viewModel.detailCommand execute:@{
                                                @"labId":@([ULUserMgr sharedMgr].laboratoryId), //实验室id
                                                @"year":@(_date.year), //年
                                                @"month":@(_date.month)
                                                }];
        @weakify(self)
        [self.viewModel.detailSubject subscribeNext:^(id x) {
            @strongify(self)
            _detailArray = x;
            [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(45*_detailArray.count);
            }];
            [self.tableView reloadData];
        }];

    }
    
    
}

- (void)ul_layoutNavigation
{
    self.title = @"财务管理";
}
- (void)ul_addSubviews
{
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.dateLabel];
    [self.view addSubview:self.bottomView];
    [self.view setNeedsUpdateConstraints];
    [self.view updateConstraintsIfNeeded];
}

- (void)updateViewConstraints
{
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(64+10);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.dateLabel.mas_bottom).offset(8);
        make.height.mas_equalTo(screenHeight-64-10-33);
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(33);
    }];
    [super updateViewConstraints];
}

- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] init];
        _tableView.rowHeight = 45;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = kCommonWhiteColor;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ULLabBusinessDetailTableViewCellIdentifier"];
    }
    return _tableView;
}
- (UILabel *)dateLabel
{
    if (!_dateLabel)
    {
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.text = [NSString stringWithFormat:@"%@-%@", @([NSDate date].year), @([NSDate date].month)];
        _dateLabel.textColor = KTextGrayColor;
        _dateLabel.font = kFont(kStandardPx(28));
    }
    return _dateLabel;
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
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"ULLabBusinessDetailTableViewCellIdentifier"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    for (UIView *subview in cell.subviews)
    {
        [subview removeFromSuperview];
    }
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = _detailArray[indexPath.row][@"itemName"];
    nameLabel.textColor = kTextBlackColor;
    nameLabel.font = kFont(kStandardPx(30));
    [cell addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell).offset(15);
        make.centerY.equalTo(cell);
    }];
    UILabel *moneyLabel = [[UILabel alloc] init];
    moneyLabel.text = [NSString stringWithFormat:@"%@元",_detailArray[indexPath.row][@"amount"]];
    moneyLabel.textColor = kTextBlackColor;
    moneyLabel.font = kFont(kStandardPx(30));
    [cell addSubview:moneyLabel];
    [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(cell).offset(-15);
        make.centerY.equalTo(cell);
    }];
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = kBackgroundColor;
    [cell addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(cell);
        make.height.mas_equalTo(0.5);
    }];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
