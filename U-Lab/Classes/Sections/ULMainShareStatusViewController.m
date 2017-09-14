//
//  ULMainShareStatusViewController.m
//  ULab
//
//  Created by 周维康 on 2017/6/13.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULMainShareStatusViewController.h"
#import "ULMainShareSelectViewController.h"
#import "ULLabModel.h"

@interface ULMainShareStatusViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *fristTableView;  /**< first */
@property (nonatomic, strong) UITableView *secondTableView;  /**< second */
@property (nonatomic, strong) UIImageView *bottomView;  /**< 底部花篮 */
@property (nonatomic, assign) NSNumber* isShare;  /**< isShare  */
@property (nonatomic, strong) NSMutableArray *users;  /**< <#comment#> */
@property (nonatomic, strong) NSMutableArray *labs;  /**< <#comment#> */
@property (nonatomic, strong) NSMutableArray *groups;  /**< <#comment#> */
@property (nonatomic, strong) NSDictionary *resultDic;  /**< <#comment#> */

@end

@implementation ULMainShareStatusViewController
{
    NSArray *_firstArray;
    NSArray *_secondArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (instancetype)init
{
    self.popSubject = [RACSubject subject];
    if (self = [super init])
    {
        
    }
    return self;
}
- (void)ul_layoutNavigation
{
    self.title = @"共享状态";
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addButton.frame = CGRectMake(0, 0, 40, 17);
    [addButton setTitle:@"保存" forState:UIControlStateNormal];
    @weakify(self)
    [[addButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        
        [self.popSubject sendNext:@{
                                    @"isShare" : self.isShare,
                                    @"users" : self.users,
                                    @"labs" : self.labs,
                                    }];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:addButton];
    self.navigationItem.rightBarButtonItem = buttonItem;
}

- (void)ul_addSubviews
{
    self.view.backgroundColor = kBackgroundColor;
    _firstArray = @[@"共享", @"不共享", @"共享给", @"所有实验室可见", @"仅本实验室可见", @"选中的实验室和好友可见"];
    _secondArray = @[@"友好实验室", @"我的好友"];
    self.users = [NSMutableArray array];
    self.labs = [NSMutableArray array];
    self.groups = [NSMutableArray array];
    self.isShare = @1;
    [self.view addSubview:self.bottomView];
    [self.view addSubview:self.fristTableView];
    [self.view addSubview:self.secondTableView];
    [self.view updateConstraintsIfNeeded];
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    [self.fristTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(64+18);
        make.height.mas_equalTo(88*3);
    }];
    [self.secondTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.fristTableView.mas_bottom);
        make.height.mas_equalTo(88*2);
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

- (UITableView *)fristTableView
{
    if (!_fristTableView)
    {
        _fristTableView = [[UITableView alloc] init];
        _fristTableView.rowHeight = 88;
//        _fristTableView.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0);
        _fristTableView.delegate = self;
        _fristTableView.dataSource = self;
        _fristTableView.scrollEnabled = NO;
        _fristTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_fristTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ULMainShareStatusFristTableViewCellIdentifier"];
    }
    return _fristTableView;
}

- (UITableView *)secondTableView
{
    if (!_secondTableView)
    {
        _secondTableView = [[UITableView alloc] init];
        _secondTableView.rowHeight = 88;
        _secondTableView.delegate = self;
        _secondTableView.dataSource = self;
        _secondTableView.scrollEnabled = NO;
        _secondTableView.hidden = YES;
        _secondTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_secondTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ULMainShareStatusSecondTableViewCellIdentifier"];
    }
    return _secondTableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _secondTableView) {
        return 2;
    }
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (tableView == self.fristTableView)
    {
        cell = [self.fristTableView dequeueReusableCellWithIdentifier:@"ULMainShareStatusFristTableViewCellIdentifier"];
    } else {
        cell = [self.secondTableView dequeueReusableCellWithIdentifier:@"ULMainShareStatusSecondTableViewCellIdentifier"];
    }
    cell.backgroundColor = kCommonWhiteColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.textColor = kTextBlackColor;
    nameLabel.font = kFont(kStandardPx(32));
    [cell addSubview:nameLabel];
    
    UILabel *detailLabel = [[UILabel alloc] init];
    detailLabel.textColor = KTextGrayColor;
    detailLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    detailLabel.font = kFont(kStandardPx(28));
    [cell addSubview:detailLabel];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.layer.borderWidth = 0.5;
    button.layer.borderColor = kCommonGrayColor.CGColor;
    button.layer.cornerRadius = 12.5;
    button.layer.masksToBounds = YES;
    [cell addSubview:button];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithColor:KButtonBlueColor]];
    imageView.hidden = YES;
    imageView.layer.cornerRadius = 10.0;
    imageView.layer.masksToBounds = YES;
    [button addSubview:imageView];
    NSMutableString *string = [[NSMutableString alloc] init];
    if ([self.resultDic[@"type"]  isEqual: @(0)] && indexPath.row == 0)
    {
        cell.selected = YES;
        for (ULLabModel *model in self.resultDic[@"result"])
        {
            [string appendString:[NSString stringWithFormat:@"%@、", model.labName]];
        }
    } else if ([self.resultDic[@"type"]  isEqual: @(1)] && indexPath.row == 1) {
        cell.selected = YES;
        for (JMSGUser *user in self.resultDic[@"result"])
        {
            [string appendString:[NSString stringWithFormat:@"%@、", user.username]];
        }
    } else if ([self.resultDic[@"type"]  isEqual: @(2)] && indexPath.row == 2) {
        cell.selected = YES;
        for (JMSGGroup *group in self.resultDic[@"result"])
        {
            [string appendString:[NSString stringWithFormat:@"%@、", group.name]];
        }
    }
    detailLabel.text = string;

    UIView *line = [[UIView alloc] init];
    line.backgroundColor = kBackgroundColor;
    [cell addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.and.left.and.right.equalTo(cell);
        make.height.mas_equalTo(0.5);
    }];
    if (tableView == self.fristTableView)
    {
        nameLabel.text = _firstArray[indexPath.row];
        detailLabel.text = _firstArray[indexPath.row+3];

        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell).offset(15);
            make.top.equalTo(cell).offset(18);
        }];
        [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell).offset(15);
            make.top.equalTo(nameLabel.mas_bottom).offset(10);
        }];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(cell).offset(-15);
            make.centerY.equalTo(cell);
            make.size.mas_equalTo(CGSizeMake(25, 25));
        }];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.centerX.equalTo(button);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
        [[RACObserve(cell, selected) skip:2] subscribeNext:^(id x) {
            if (cell.selected)
            {
                imageView.hidden = NO;
            } else {
                imageView.hidden = YES;
            }
        }];
        } else {
        nameLabel.text = _secondArray[indexPath.row];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell).offset(15);
            make.centerY.equalTo(cell);
            make.size.mas_equalTo(CGSizeMake(25, 25));
        }];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.centerX.equalTo(button);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imageView.mas_right).offset(15);
            make.top.equalTo(cell).offset(18);
        }];
        [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(nameLabel);
            make.top.equalTo(nameLabel.mas_bottom).offset(10);
            make.right.equalTo(cell).offset(-40);
        }];
        UIImageView *next = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_user_next"]];
        [cell addSubview:next];
        [next mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(cell).offset(-20);
            make.centerY.equalTo(cell);
            make.size.mas_equalTo(CGSizeMake(10, 15));
        }];
        [[RACObserve(cell, selected) skip:2] subscribeNext:^(id x) {
            if (cell.selected)
            {
                imageView.hidden = NO;
            } else {
                imageView.hidden = YES;
            }
        }];

    }

    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.fristTableView)
    {
        UITableViewCell *cell = [self.fristTableView cellForRowAtIndexPath:indexPath];
        cell.selected = !cell.selected;
        for (NSInteger row=0; row<3; row++)
        {
            if (indexPath.row != row)
            {
                NSIndexPath *other = [NSIndexPath indexPathForRow:row inSection:0];
                UITableViewCell *otherCell = [self.fristTableView cellForRowAtIndexPath:other];
                otherCell.selected = NO;
            }
        }
        if (indexPath.row == 2)
        {
            self.secondTableView.hidden = NO;
        } else {
            self.secondTableView.hidden = YES;
        }
        if (indexPath.row == 1)
        {
            self.isShare = @0;
        } else if (indexPath.row == 0){
            self.isShare = @1;
        } else {
            self.isShare = @2;
        }
    } else {
        UITableViewCell *cell = [self.secondTableView cellForRowAtIndexPath:indexPath];
        cell.selected = !cell.selected;
        for (NSInteger row=0; row<2; row++)
        {
            if (indexPath.row != row)
            {
                NSIndexPath *other = [NSIndexPath indexPathForRow:row inSection:0];
                UITableViewCell *otherCell = [self.secondTableView cellForRowAtIndexPath:other];
                otherCell.selected = NO;
            }
        }
        ULMainShareSelectViewController *selectVC = [[ULMainShareSelectViewController alloc] initWithSelectType:indexPath.row];
        [selectVC.resultArray addObject:self.resultDic[@"result"]];
        @weakify(self)
        [selectVC.popSubject subscribeNext:^(id x) {
            @strongify(self)
            self.resultDic = x;
            ULMainShareSelectType type = [x[@"type"] integerValue];
            switch (type) {
                case ULMainShareSelectTypeLab:
                    self.labs = x[@"result"];
                    break;
                case ULMainShareSelectTypeFriend:
                    self.users = x[@"result"];
                    break;
                default:
                    break;
            }
            [self.secondTableView reloadData];
        }];
        [self.navigationController pushViewController:selectVC animated:YES];

    }
    
}

@end
