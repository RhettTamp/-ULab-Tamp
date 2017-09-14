//
//  ULMainShareSelectViewController.m
//  ULab
//
//  Created by 周维康 on 2017/6/13.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULMainShareSelectViewController.h"
#import "ULLabModel.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ULMainShareSelectViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;  /**< 详情列表 */
@property (nonatomic, strong) UIImageView *bottomView;  /**< bottom */
@property (nonatomic, assign) ULMainShareSelectType selectType;  /**< type  */
@property (nonatomic, strong) NSArray *array;  /**< array */


@end

@implementation ULMainShareSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (instancetype)initWithSelectType:(ULMainShareSelectType)selectType
{
    self.selectType = selectType;
    self = [super init];
    self.popSubject = [RACSubject subject];
    return self;
}
- (void)ul_layoutNavigation
{
    switch (_selectType) {
        case ULMainShareSelectTypeFriend:
            self.title = @"从好友列表选择";
            break;
        case ULMainShareSelectTypeLab:
            self.title = @"从友好实验室选择";
            break;
        default:
            break;
    }
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addButton.frame = CGRectMake(0, 0, 40, 17);
    [addButton setTitle:@"保存" forState:UIControlStateNormal];
    @weakify(self)
    [[addButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        [self.popSubject sendNext:@{
                                    @"type" : @(_selectType),
                                    @"result" : self.resultArray
                                    }];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:addButton];
    self.navigationItem.rightBarButtonItem = buttonItem;
}

- (void)ul_addSubviews
{
    self.resultArray = [NSMutableArray array];
    switch (_selectType) {
        case ULMainShareSelectTypeFriend:
            self.array = [ULUserMgr sharedMgr].friendArray;
            break;
        case ULMainShareSelectTypeLab:
            self.array = [ULUserMgr sharedMgr].firendLabArray;
            break;
        default:
            break;
    }
    [self.view addSubview:self.bottomView];
    [self.view addSubview:self.tableView];
    [self.view updateConstraintsIfNeeded];
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(64+18);
        make.height.mas_equalTo(screenHeight-64-18-33);
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(33);
    }];
    [super updateViewConstraints];
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
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 88;
        _tableView.backgroundColor = kCommonWhiteColor;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ULMainShareSelectTableViewCellIdentifier"];
    }
    return _tableView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"ULMainShareSelectTableViewCellIdentifier"];
    for (UIView *subview in cell.subviews)
    {
        [subview removeFromSuperview];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIImageView *headerImageView = [[UIImageView alloc] init];
    headerImageView.layer.cornerRadius = 25.5;
    headerImageView.layer.masksToBounds = YES;
    [cell addSubview:headerImageView];
    [headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell);
        make.left.equalTo(cell).offset(15);
        make.size.mas_equalTo(CGSizeMake(51, 51));
    }];
    UILabel *nameLabel = [[UILabel alloc] init];
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
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.layer.borderWidth = 0.5;
    button.layer.borderColor = kCommonGrayColor.CGColor;
    button.layer.cornerRadius = 12.5;
    button.layer.masksToBounds = YES;
    [cell addSubview:button];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithColor:KButtonBlueColor]];
    imageView.hidden = YES;
    imageView.layer.cornerRadius = 10;
    imageView.layer.masksToBounds = YES;
    [button addSubview:imageView];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(cell).offset(-15);
        make.centerY.equalTo(cell);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.centerX.equalTo(button);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    UIButton *selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    @weakify(self)
    [[selectButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        cell.selected = !cell.isSelected;
        if (cell.selected)
        {
            [self.resultArray addObject:self.array[indexPath.row]];
            imageView.hidden = NO;
        } else {
            [self.resultArray removeObject:self.array[indexPath.row]];
            imageView.hidden = YES;
        }

    }];
    [cell addSubview:selectButton];
    [selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(cell);
    }];
    switch (_selectType) {
        case ULMainShareSelectTypeFriend:{
            JMSGUser *user = self.array[indexPath.row];
            nameLabel.text = user.username;
            [headerImageView sd_setImageWithURL:[NSURL URLWithString:user.avatar] placeholderImage:[UIImage imageNamed:@"ulab_user_default"]];
        }
            break;
        case ULMainShareSelectTypeLab:{
            ULLabModel *model = self.array[indexPath.row];
            nameLabel.text = model.labName;
            [headerImageView sd_setImageWithURL:[NSURL URLWithString:model.labImage] placeholderImage:[UIImage imageNamed:@"ulab_lab_default"]];
        }
            break;
        default:
            break;
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
