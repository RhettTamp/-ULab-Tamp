//
//  ULHomeView.m
//  U-Lab
//
//  Created by 周维康 on 17/5/19.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULHomeView.h"
#import "ULHomeKeyView.h"
#import "ULUserDetailViewModel.h"
#import "ULMainViewModel.h"
#import "ULUserMgr.h"
#import "ULQueueTool.h"

#define dis(x) x/375.0*screenWidth

@interface ULHomeView() <UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIImageView *backgroundImageView;  /**< 背景板 */
@property (nonatomic, strong) UIImageView *signImageView;  /**< 标志 */
@property (nonatomic, strong) UITextField *searchTextField;  /**< 搜索框 */
@property (nonatomic, strong) UILabel *lastestLabel;  /**< 最近搜素 */
@property (nonatomic, strong) UIButton *searchButton;  /**< 搜索按钮 */
@property (nonatomic, strong) UILabel *shareLabel;  /**< 共享实验物品 */
@property (nonatomic, strong) UIButton *notFindButton;  /**< 找不到使用的物品 */
@property (nonatomic, strong) ULHomeKeyView *keyView;  /**< 关键字视图 */
@property (nonatomic, strong) UICollectionView *shareCollectionView;  /**< 分享物品 */
@property (nonatomic, strong) UIButton *allButton;  /**< 全部 */
@property (nonatomic, strong) ULUserDetailViewModel *viewModel;  /**< <#comment#> */
@property (nonatomic, strong) UITableView *allTableView;  /**< tableview */
@property (nonatomic, strong) UIButton *otherButton;  /**< 其他 */
@property (nonatomic, strong) ULMainViewModel *mainViewModel;  /**< main */
@property (nonatomic, copy) NSString *searchString;  /**< searchString */
@end

@implementation ULHomeView
{
    NSArray *_cellNameArray;
    NSArray *_cellImageArray;
    NSArray *_searchArray;
}

- (void)ul_setupViews
{
    _searchArray = @[@"全部", @"耗材", @"试剂", @"动物", @"仪器", @"其他"];
    self.applyBuySubject = [RACSubject subject];
    self.shareSubject = [RACSubject subject];
    self.searchSubject = [RACSubject subject];
    self.mainViewModel = [[ULMainViewModel alloc] init];
    [self addSubview:self.backgroundImageView];
    [self addSubview:self.signImageView];
    [self addSubview:self.searchButton];
    [self addSubview:self.searchTextField];
    [self addSubview:self.lastestLabel];
    [self addSubview:self.shareLabel];
    [self addSubview:self.notFindButton];
    [self addSubview:self.keyView];
    [self addSubview:self.shareCollectionView];
    [self addSubview:self.allButton];
    [self addSubview:self.allTableView];
    [self addSubview:self.otherButton];
    [self updateConstraintsIfNeeded];
    [self setNeedsUpdateConstraints];
}

- (void)ul_bindViewModel
{
    [self.viewModel.detailCommand execute:nil];
    [self.mainViewModel.searchCommand.executionSignals.flatten subscribeNext:^(id x) {
        [ULProgressHUD hide];
        NSArray *array = x;
        if (array.count == 0)
        {
            [self.searchSubject sendNext:@{
                                           @"key" : self.searchTextField.text,
                                           @"result" : @""
                                           }];
        } else {
            [self.searchSubject sendNext:@{
                                           @"key" : self.searchTextField.text,
                                           @"result" : x
                                           }];
        }
    }];
}

- (void)updateConstraints
{
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.signImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(dis(138));
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(dis(180), dis(46)));
    }];
    [self.searchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-15);
        make.top.equalTo(self.signImageView.mas_bottom).offset(dis(72));
        make.size.mas_equalTo(CGSizeMake(dis(58), dis(28)));
    }];
    [self.allButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.centerY.equalTo(self.searchButton);
        make.width.mas_equalTo(dis(58));
    }];
    [self.allTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.allButton);
        make.top.equalTo(self.allButton.mas_bottom);
        make.height.mas_equalTo(dis(40)*6);
    }];
    [self.searchTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self.searchButton);
        make.right.equalTo(self.searchButton.mas_left).offset(-9);
        make.height.mas_equalTo(dis(28));
    }];
    [self.lastestLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.searchTextField.mas_bottom).offset(dis(25));
        make.left.equalTo(self).offset(15);
    }];
    [self.notFindButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-15);
        make.top.equalTo(self.keyView.mas_bottom).offset(dis(32));
    }];
    [self.shareLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.top.equalTo(self.notFindButton.mas_bottom).offset(dis(20));
    }];
    [self.otherButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-15);
        make.centerY.equalTo(self.shareLabel);
    }];
    [self.shareCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.shareLabel.mas_bottom).offset(dis(19));
        make.left.right.equalTo(self);
        make.height.mas_equalTo(dis(87.5));
    }];
    [self.keyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.height.mas_equalTo(dis(52));
        make.right.equalTo(self).offset(-15);
        make.top.equalTo(self.lastestLabel.mas_bottom).offset(dis(15));
    }];
    [super updateConstraints];
}

#pragma mark - lazyLoad
- (UIImageView *)backgroundImageView
{
    if (!_backgroundImageView)
    {
        _backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_background"]];
    }
    return _backgroundImageView;
}

- (UIImageView *)signImageView
{
    if (!_signImageView)
    {
        _signImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_ulab"]];
    }
    return _signImageView;
}

- (UITextField *)searchTextField
{
    if (!_searchTextField)
    {
        _searchTextField = [[UITextField alloc] init];
        NSAttributedString *attributeString = [[NSAttributedString alloc] initWithString:@"输入你想使用的物品" attributes:@{NSForegroundColorAttributeName : kCommonBlueColor}];
        _searchTextField.attributedPlaceholder = attributeString;
        _searchTextField.delegate = self;
        _searchTextField.layer.cornerRadius = 5;
        _searchTextField.layer.borderWidth = 0.8;
        _searchTextField.backgroundColor = kCommonWhiteColor;
        _searchTextField.layer.borderColor = kCommonLightGrayColor.CGColor;
        _searchTextField.layer.masksToBounds = YES;
        _searchTextField.textColor = [UIColor colorWithRGBHex:0x333333];
        _searchTextField.leftViewMode = UITextFieldViewModeAlways;
        UIView *whiteView = [[UIView alloc] init];
        whiteView.backgroundColor = kCommonWhiteColor;
        whiteView.frame = CGRectMake(0, 0, 25, 25);
        _searchTextField.leftView = whiteView;
    }
    return _searchTextField;
}

- (UILabel *)shareLabel
{
    if (!_shareLabel)
    {
        _shareLabel = [[UILabel alloc] init];
        _shareLabel.text = @"共享我的实验室物品";
        _shareLabel.textColor = [UIColor colorWithRGBHex:0x666666];
        _shareLabel.font = kFont(kStandardPx(24));
    }
    return _shareLabel;
}

- (UIButton *)otherButton
{
    if (!_otherButton)
    {
        _otherButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_otherButton setTitle:@"其他" forState:UIControlStateNormal];
        [[_otherButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            if (![ULUserMgr sharedMgr].laboratoryId) {
                [ULProgressHUD showWithMsg:@"请先加入实验室"];
            }else{
                [self.shareSubject sendNext:@(4)];
            }
        }];
        _otherButton.titleLabel.font = kFont(kStandardPx(28));
        [_otherButton setTitleColor:kCommonBlueColor forState:UIControlStateNormal];
    }
    return _otherButton;
}
- (UIButton *)searchButton
{
    if (!_searchButton)
    {
        _searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_searchButton setTitle:@"搜索" forState:UIControlStateNormal];
        [_searchButton setTitleColor:kCommonWhiteColor forState:UIControlStateNormal];
        _searchButton.backgroundColor = KButtonBlueColor;
        _searchButton.layer.cornerRadius = 5;
        _searchButton.layer.masksToBounds = YES;
        @weakify(self)
        [[_searchButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            [self endEditing:YES];
            __block NSString *searchStr = self.searchTextField.text;
            if (![ULUserMgr sharedMgr].laboratoryId) {
                [ULProgressHUD showWithMsg:@"请先加入实验室"];
            }else if (!searchStr||[searchStr isEqualToString:@""]){
                [ULProgressHUD showWithMsg:@"请输入搜索内容"];
            }else{
                [ULProgressHUD showWithMsg:@"搜索中" inView:self withBlock:^{
                    @strongify(self)
                    
                    for (NSString *str in self.keyView.keyArray) {
                        if ([str isEqualToString:searchStr]) {
                            searchStr = nil;
                        }
                    }
                    if (searchStr && ![searchStr isEqualToString:@""]) {
                        if (self.keyView.keyArray.count <= 8) {
//                            self.keyView.keyArray = [[queue getQueue] mutableCopy];
//                            [ULUserMgr sharedMgr].searchArray = [queue getQueue];
                            [self.keyView.keyArray addObject:searchStr];
                            for (NSInteger i = self.keyView.keyArray.count-1; i > 0; i--) {
                                self.keyView.keyArray[i] = self.keyView.keyArray[i-1];
                            }
                            self.keyView.keyArray[0] = searchStr;
                            [ULUserMgr sharedMgr].searchArray = [self.keyView.keyArray copy];
                            [ULUserMgr saveMgr];
                            [self.keyView reloadData];
                        }else{
                            [self.keyView.keyArray addObject:searchStr];
                            for (NSInteger i = self.keyView.keyArray.count-1; i > 0; i--) {
                                self.keyView.keyArray[i] = self.keyView.keyArray[i-1];
                            }
                            self.keyView.keyArray[0] = searchStr;
                            [self.keyView.keyArray removeObjectAtIndex:self.keyView.keyArray.count-1];
                            [ULUserMgr sharedMgr].searchArray = [self.keyView.keyArray copy];
                            [ULUserMgr saveMgr];
                            [self.keyView reloadData];
                        }
                    }
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        [self.mainViewModel.searchCommand execute:@{
                                                                    @"key":self.searchTextField.text, //搜索的关键字
                                                                    @"page":@1, //第几页
                                                                    @"size":@10 //每页的数量
                                                                    }];
                    });
                    
                    
                }];
            }
            
        }];
    }
    return _searchButton;
}

- (UILabel *)lastestLabel
{
    if (!_lastestLabel)
    {
        _lastestLabel = [[UILabel alloc] init];
        _lastestLabel.text = @"最近搜索:";
        _lastestLabel.font = kFont(kStandardPx(24));
        _lastestLabel.textColor = [UIColor colorWithRGBHex:0x666666];
    }
    return _lastestLabel;
}

- (UIButton *)notFindButton
{
    if (!_notFindButton)
    {
        _notFindButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_notFindButton setTitle:@"找不到要使用的物品？点击申请购买" forState:UIControlStateNormal];
        [_notFindButton setTitleColor:kCommonBlueColor forState:UIControlStateNormal];
        _notFindButton.titleLabel.font = kFont(kStandardPx(22));
        @weakify(self)
        [[_notFindButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self)
            if (![ULUserMgr sharedMgr].laboratoryId) {
                [ULProgressHUD showWithMsg:@"请先加入实验室"];
            }else{
                [self.applyBuySubject sendNext:nil];
            }
            
        }];
    }
    return _notFindButton;
}

- (ULHomeKeyView *)keyView
{
    if (!_keyView)
    {
        _keyView = [[ULHomeKeyView alloc] initWithKeyArray:[ULUserMgr sharedMgr].searchArray];
        @weakify(self);
        [self.keyView.touchSubject subscribeNext:^(id x) {
            @strongify(self)
            self.searchTextField.text = x;
        }];
    }
    return _keyView;
}

- (UICollectionView *)shareCollectionView
{
    if (!_shareCollectionView)
    {
        _cellNameArray = @[@"耗材", @"试剂", @"动物", @"仪器"];
        _cellImageArray = @[@"home_material", @"home_reagent", @"home_animal", @"home_lab"];
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.itemSize = CGSizeMake(dis(61.5), dis(87.5));
        if (screenWidth < 375.0) {
            flowLayout.itemSize = CGSizeMake(dis(61.5), dis(80.5));
        }
        _shareCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _shareCollectionView.backgroundColor = [UIColor clearColor];
        _shareCollectionView.delegate = self;
        _shareCollectionView.dataSource = self;
        _shareCollectionView.scrollEnabled = NO;
        [_shareCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"ULHomeShareCollectionViewIdentifier"];
    }
    return  _shareCollectionView;
}
- (UIButton *)allButton
{
    if (!_allButton)
    {
        _allButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_allButton setBackgroundColor:[UIColor clearColor]];
        [_allButton setTitleColor:kCommonBlueColor forState:UIControlStateNormal];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_all_down"]];
        [_allButton addSubview:imageView];
        UILabel *label = [[UILabel alloc] init];
        label.text = @"全部";
        label.textColor = KButtonBlueColor;
        label.font = kFont(kStandardPx(30));
        [_allButton addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_allButton);
            make.centerY.equalTo(_allButton);
        }];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.centerY.equalTo(_allButton);
            make.size.mas_equalTo(CGSizeMake(dis(20), dis(10)));
        }];
        @weakify(self)
        [[_allButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self)
            self.allTableView.hidden = !self.allTableView.isHidden;
            if (self.allTableView.hidden)
            {
                imageView.image = [UIImage imageNamed:@"home_all_down"];
            } else {
                imageView.image = [UIImage imageNamed:@"home_all_up"];
            }
        }];
    }
    return _allButton;
}

- (UITableView *)allTableView
{
    if (!_allTableView)
    {
        _allTableView = [[UITableView alloc] init];
        _allTableView.backgroundColor = kCommonWhiteColor;
        _allTableView.delegate = self;
        _allTableView.dataSource = self;
        [_allTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ULHomeAllSearchTableViewCellIdentifier"];
        _allTableView.rowHeight = 40;
        _allTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _allTableView.hidden = YES;
    }
    return _allTableView;
}
- (ULUserDetailViewModel *)viewModel
{
    if (!_viewModel)
    {
        _viewModel = [[ULUserDetailViewModel alloc] init];
    }
    return _viewModel;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.searchTextField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.searchTextField resignFirstResponder];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.allTableView dequeueReusableCellWithIdentifier:@"ULHomeAllSearchTableViewCellIdentifier"];
    UILabel *label = [[UILabel alloc] init];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    label.text = _searchArray[indexPath.row];
    label.textColor = KTextGrayColor;
    label.font = kFont(kStandardPx(28));
    label.textAlignment = NSTextAlignmentCenter;
    [cell addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(cell);
    }];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    for (UIView *subview in self.allButton.subviews)
    {
        if ([subview class] == [UIImageView class])
        {
            UIImageView *imageView = (UIImageView *)subview;
            imageView.image = [UIImage imageNamed:@"home_all_down"];
        }
        if ([subview class] == [UILabel class])
        {
            UILabel *label = (UILabel *)subview;
            label.text = _searchArray[indexPath.row];
        }
    }
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    cell.selected = !cell.isSelected;
//    NSLog(@"%@",@(cell.isSelected));
    tableView.hidden = YES;
}
#pragma mark - UICollectionViewDelegate & DataSource & FlowLayout
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 4;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (![ULUserMgr sharedMgr].laboratoryId) {
        [ULProgressHUD showWithMsg:@"请先加入实验室"];
    }else{
        [self.shareSubject sendNext:@(indexPath.row)];
    }
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [self.shareCollectionView dequeueReusableCellWithReuseIdentifier:@"ULHomeShareCollectionViewIdentifier" forIndexPath:indexPath];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:_cellImageArray[indexPath.row]]];
    UILabel *label = [[UILabel alloc] init];
    label.text = _cellNameArray[indexPath.row];
    label.font = kFont(kStandardPx(26));
    [cell addSubview:imageView];
    [cell addSubview:label];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.right.left.equalTo(cell);
        make.height.mas_equalTo(dis(61));
    }];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        if (screenWidth < 375.0) {
             make.top.equalTo(imageView.mas_bottom).offset(dis(10));
        }else{
            make.top.equalTo(imageView.mas_bottom).offset(dis(12));
        }
        make.centerX.equalTo(cell);
    }];
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, dis(25), 0, dis(25));
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return (collectionView.frame.size.width - dis(61.5)*3 - dis(50)) / 3;
}
@end
