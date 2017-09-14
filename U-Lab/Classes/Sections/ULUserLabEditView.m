//
//  ULUserLabEditView.m
//  U-Lab
//
//  Created by 周维康 on 2017/6/6.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULUserLabEditView.h"
#import "ULUserLabModel.h"

@interface ULUserLabEditView() <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;  /**< 展示列表 */
@property (nonatomic, strong) UIImageView *bottomView;  /**< 底部花篮 */

@end
@implementation ULUserLabEditView
{
    NSArray *_labArray;
}

- (void)ul_setupViews
{
    _labArray = [NSArray array];
    self.cellSelectSubject = [RACSubject subject];
    self.backgroundColor = kBackgroundColor;
    [self addSubview:self.tableView];
    [self addSubview:self.bottomView];
    [self updateFocusIfNeeded];
    [self setNeedsUpdateConstraints];
}

- (void)updateViewWithArray:(NSArray *)array
{
    _labArray = array;
    [self.tableView reloadData];
}
- (instancetype)initWithLabArray:(NSArray *)labArray
{
    if (self = [super init])
    {
        _labArray = labArray;
    }
    return self;
}
//
//- (void)ul_bindViewModel
//{
//    self.viewModel = [[ULUserLabViewModel alloc] init];
//    @weakify(self)
//    [ULProgressHUD showWithMsg:@"获取数据中" withBlock:^{
//        @strongify(self)
//        [self.viewModel.getCommand execute:nil];
//    }];
//    
//    [self.viewModel.getSubject subscribeNext:^(id x) {
//        @strongify(self)
//        _projectArray = x;
//        [self.tableView reloadData];
//        [ULProgressHUD hide];
//    }];
//    
//    [self.viewModel.getSubject subscribeError:^(NSError *error) {
//        [ULProgressHUD hide];
//        [ULProgressHUD showWithMsg:@"请求失败"];
//    }];
//}
- (void)updateConstraints
{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(64+18);
        make.left.right.equalTo(self);
        make.bottom.equalTo(self).offset(-33);
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

- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = kBackgroundColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 45;
        _tableView.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0);
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ULUserProjectEditTableViewCellIdentifier"];
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _labArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.cellSelectSubject sendNext:_labArray[indexPath.row]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"ULUserProjectEditTableViewCellIdentifier"];
    for (UIView *subView in cell.subviews)
    {
        [subView removeFromSuperview];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    ULUserLabModel *model = _labArray[indexPath.row];
    cell.backgroundColor = kCommonWhiteColor;
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.font = [UIFont systemFontOfSize:kStandardPx(34) weight:1];
    nameLabel.textColor = kTextBlackColor;
    nameLabel.text = model.labName;
    [cell addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell);
        make.left.equalTo(cell).offset(15);
    }];
    UILabel *introLabel = [[UILabel alloc] init];
    introLabel.font = kFont(kStandardPx(26));
    introLabel.textColor = KTextGrayColor;
    introLabel.text = model.labTime;
    [cell addSubview:introLabel];
    [introLabel mas_makeConstraints:^(MASConstraintMaker *make) {
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
    return cell;
    
}

//- (void)setView:(UIView *)view Name:(NSString *)labName intro:(NSString *)labIntro
//{
//    UILabel *nameLabel = [[UILabel alloc] init];
//    nameLabel.text = labName;
//    nameLabel.textColor = kTextBlackColor;
//    nameLabel.font = kFont(kStandardPx(30));
//    [view addSubview:nameLabel];
//    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(view).offset(15);
//        make.centerY.equalTo(view);
//    }];
//    UILabel *introLabel = [[UILabel alloc] init];
//    introLabel.text = labIntro;
//    introLabel.textColor = kTextBlackColor;
//    introLabel.font = kFont(kStandardPx(30));
//    [view addSubview:introLabel];
//    [introLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(view).offset(-15);
//        make.centerY.equalTo(view);
//    }];
//    UIView *line = [[UIView alloc] init];
//    line.backgroundColor = kBackgroundColor;
//    [view addSubview:line];
//    [line mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.left.right.equalTo(view);
//        make.height.mas_equalTo(0.5);
//    }];
//}

@end
