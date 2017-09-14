//
//  ULMainSearchViewController.m
//  ULab
//
//  Created by 周维康 on 2017/6/15.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULMainSearchViewController.h"
#import "ULUserObjectModel.h"
#import "ULMainCheckUseViewController.h"
#import "ULMainObjectDetailViewController.h"
#import "ULMainApplyBuyViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ULMainSearchViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *array;  /**< array */
@property (nonatomic, strong) UITableView *tableView;  /**< tableView */
@property (nonatomic, strong) UILabel *searchLabel;  /**< label */
@property (nonatomic, strong) UIImageView *bottomView;  /**< bottomView */
@property (nonatomic, copy) NSString *searchKey;  /**< seach */
@end

@implementation ULMainSearchViewController

- (instancetype)initWithObjectDic:(NSDictionary *)dic
{
    if (![dic[@"result"] isKindOfClass:[NSArray class]]) {
        self.array = @[];
    }else{
        self.array = dic[@"result"];
    }
    
    self.searchKey = dic[@"key"];
    if (self = [super init])
    {
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)ul_layoutNavigation
{
    self.title = @"搜索结果";
}

- (void)ul_addSubviews
{
    
    [self.view addSubview:self.searchLabel];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomView];
    if (self.array.count == 0) {
        self.tableView.hidden = YES;
        [self addTintView];
    }
    [self.view setNeedsUpdateConstraints];
    [self.view updateConstraintsIfNeeded];
}

- (void)addTintView{
    UILabel *label1 = [UILabel new];
    label1.font = kFont(kStandardPx(33));
    label1.textColor = KTextGrayColor;
    label1.text = @"没有找到您搜索的物品";
    [self.view addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.mas_offset(150);
    }];
    UIView *secondView = [UIView new];
    [self.view addSubview:secondView];
    [secondView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label1.mas_bottom);
        make.centerX.equalTo(self.view);
    }];
    
    UILabel *label2 = [[UILabel alloc]init];
    label2.font = kFont(kStandardPx(33));
    label2.textColor = KTextGrayColor;
    label2.text = @"请返回重新搜索或";
    [secondView addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(secondView.mas_left);
        make.centerY.equalTo(secondView);
        make.height.equalTo(secondView);
    }];
    UIButton *buyButton = [[UIButton alloc]init];
    [buyButton setTitle:@"申请购买" forState:UIControlStateNormal];
    buyButton.titleLabel.font = kFont(kStandardPx(33));
    [buyButton setTitleColor:kCommonBlueColor forState:UIControlStateNormal];
    [[buyButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        ULMainApplyBuyViewController *applyVC = [[ULMainApplyBuyViewController alloc] init];
        [self.navigationController pushViewController:applyVC animated:YES];
    }];
    [secondView addSubview:buyButton];
    [buyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label2.mas_right);
        make.right.equalTo(secondView);
        make.centerY.equalTo(secondView);
    }];
}

- (void)updateViewConstraints
{
    [self.searchLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.top.equalTo(self.view).offset(70);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(88);
        make.bottom.equalTo(self.view).offset(-33);
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        make.height.mas_equalTo(33);
    }];
    [super updateViewConstraints];
}

- (UILabel *)searchLabel
{
    if (!_searchLabel)
    {
        _searchLabel = [[UILabel alloc] init];
        _searchLabel.font = kFont(kStandardPx(25));
        _searchLabel.textColor = KTextGrayColor;
        _searchLabel.text = [NSString stringWithFormat:@"🔍 “%@”的搜索结果", self.searchKey];
    }
    return _searchLabel;
}

- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = kBackgroundColor;
        _tableView.rowHeight = 88;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ULMainSearchResultTableViewCellIdentifier"];
    }
    return _tableView;
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
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"ULMainSearchResultTableViewCellIdentifier"];
    for (UIView *subView in cell.subviews)
    {
        [subView removeFromSuperview];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    ULUserObjectModel *model = self.array[indexPath.row];
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.imageURL]] placeholderImage:[UIImage imageNamed:@"ulab_object_default"]];
    imageView.layer.masksToBounds = YES;
    imageView.layer.cornerRadius = 25.5;
    [cell addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell).offset(15);
        make.size.mas_equalTo(CGSizeMake(51, 51));
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
        make.right.equalTo(cell).offset(-100);
    }];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.layer.cornerRadius = 5;
    button.layer.masksToBounds = YES;
    if ([model.isUsing boolValue])
    {
        [button setTitle:@"已使用" forState:UIControlStateNormal];
        [button setTitleColor:KTextGrayColor forState:UIControlStateNormal];
        button.userInteractionEnabled = NO;
    } else {
        [button setTitle:@"登记使用" forState:UIControlStateNormal];
        button.titleLabel.font = kFont(kStandardPx(28));
        [button setBackgroundColor:KButtonBlueColor];
        [button setTitleColor:kCommonWhiteColor forState:UIControlStateNormal];
        cell.userInteractionEnabled = YES;
    }
    @weakify(self)
    [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        ULMainCheckUseViewController *checkVC = [[ULMainCheckUseViewController alloc] initWithObjectModel:model];
        [self.navigationController pushViewController:checkVC animated:YES];
    }];
    [cell addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell);
        make.right.equalTo(cell).offset(-15);
        make.size.mas_equalTo(CGSizeMake(75, 30));
    }];
    
    UILabel *detailLabel = [[UILabel alloc] init];
    NSString *detailString = [NSString stringWithFormat:@"位置：%@", model.objectLocation];
    detailLabel.textColor = KTextGrayColor;
    detailLabel.text = detailString;
    detailLabel.font = kFont(kStandardPx(28));
    detailLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [cell addSubview:detailLabel];
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLabel);
        make.top.equalTo(nameLabel.mas_bottom).offset(13);
        make.right.equalTo(button.mas_left).offset(-10);
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
    ULUserObjectModel *model = self.array[indexPath.row];
    
    ULMainObjectDetailViewController *vc = [[ULMainObjectDetailViewController alloc]initWithObjectModel:model];
    [self.navigationController pushViewController:vc animated:YES];
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
