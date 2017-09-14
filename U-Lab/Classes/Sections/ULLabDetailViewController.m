//
//  ULLabDetailViewController.m
//  ULab
//
//  Created by 周维康 on 2017/6/18.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULLabDetailViewController.h"
#import "ULLabModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ULLabViewModel.h"

@interface ULLabDetailViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIView *headerView;  /**< <#comment#> */
@property (nonatomic, strong) UIButton *rejectButton;  /**< <#comment#> */
@property (nonatomic, strong) UIButton *agreeButton;  /**< <#comment#> */
@property (nonatomic, strong) UITableView *tableView;  /**< <#comment#> */
@property (nonatomic, strong) UIImageView *bottomView;  /**< <#comment#> */
@property (nonatomic, strong) UILabel *stateLabel;
@property (nonatomic, strong) ULLabViewModel *viewModel;

@end

@implementation ULLabDetailViewController
{
    NSArray *_nameArray;
    NSArray *_detailArray;
    NSInteger _status;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (instancetype)initWithStatus:(NSInteger)status labModel:(ULLabModel *)model{
    _status = status;
    self.model = model;
    if (self = [super init])
    {
        
    }
    return self;
}
- (void)ul_layoutNavigation
{
    self.title = @"实验室资料";
}

- (void)ul_bindViewModel{
    @weakify(self)
    [self.viewModel.relieveSubject subscribeNext:^(id x) {
        @strongify(self)
        [ULProgressHUD showWithMsg:@"解除成功"];
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)ul_addSubviews
{
    self.viewModel = [[ULLabViewModel alloc]init];
    _nameArray = @[@"实验室PI", @"研究方向"];
    _detailArray = @[[NSString stringWithFormat:@"%@",self.model.piName], self.model.labResearch?:@""];
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.bottomView];
    [self.view addSubview:self.tableView];
    if (_status == 0) {
        if (self.model.applyStatus == -1)
        {
            [self.view addSubview:self.agreeButton];
            [self.view addSubview:self.rejectButton];
        }else{
            [self.view addSubview:self.stateLabel];
        }
    }else{
        UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"解除" style:UIBarButtonItemStylePlain target:self action:@selector(relieve)];
        self.navigationItem.rightBarButtonItem = item;
    }
    [self.view updateConstraintsIfNeeded];
    [self.view setNeedsUpdateConstraints];
}

- (void)relieve{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否确定解除友好实验室关系" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [_viewModel.relieveCommand execute:@{@"srcLab":@([ULUserMgr sharedMgr].laboratoryId),@"destLab":@(self.model.labID)}];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)updateViewConstraints
{
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(76);
        make.height.mas_equalTo(88);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.headerView.mas_bottom).offset(5);
//        CGSize size = [self.model.labIntroduction sizeWithAttributes:@{NSFontAttributeName: kFont(kStandardPx(30))}];
        make.height.mas_equalTo(210);
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(33);
    }];
    if (_status == 0) {
        if (self.model.applyStatus == -1) {
            [self.agreeButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.view.mas_bottom).offset(-80);
                make.size.mas_equalTo(CGSizeMake(80, 40));
                make.centerX.equalTo(self.view).offset(-50);
            }];
            
            [self.rejectButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.view.mas_bottom).offset(-80);
                make.size.mas_equalTo(CGSizeMake(80, 40));
                make.centerX.equalTo(self.view).offset(50);
            }];
            
        }else if (self.model.applyStatus == 1){
            [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.view);
                make.bottom.equalTo(self.view).offset(-80);
            }];
            self.stateLabel.text = @"已同意";
        }else{
            [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.view);
                make.bottom.equalTo(self.view).offset(-80);
            }];
            self.stateLabel.text = @"已拒绝";
        }
        
    }
    [super updateViewConstraints];
}

- (UILabel *)stateLabel{
    if (!_stateLabel) {
        _stateLabel = [[UILabel alloc]init];
        _stateLabel.textColor = kCommonGrayColor;
    }
    return _stateLabel;
}

- (UIButton *)rejectButton
{
    if (!_rejectButton)
    {
        _rejectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rejectButton setTitle:@"拒绝" forState:UIControlStateNormal];
        [_rejectButton setTitleColor:kCommonWhiteColor forState:UIControlStateNormal];
        _rejectButton.backgroundColor = kCommonRedColor;
        _rejectButton.layer.cornerRadius = 4;
        [[_rejectButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            ULBaseRequest *request = [[ULBaseRequest alloc]init];
            request.isJson = NO;
            [request postDataWithParameter:@{@"applyId":@(self.model.labID),
                                             @"status":@(0)} session:YES progress:nil success:^(ULBaseRequest *request, NSDictionary *responseObject) {
                                                 _rejectButton.hidden = YES;
                                                 _agreeButton.hidden = YES;
                                                 [self.view addSubview:self.stateLabel];
                                                 self.stateLabel.text = @"已拒绝";
                                                 [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                                                     make.centerX.equalTo(self.view);
                                                     make.bottom.equalTo(self.view).offset(-80);
                                                 }];
                                             } failure:^(ULBaseRequest *request, NSError *error) {
                                                 [ULProgressHUD showWithMsg:@"请求失败"];
                                             } withPath:@"ulab_lab/lab/friendlyApply/status"];
        }];
        
    }
    return _rejectButton;
}

- (UIButton *)agreeButton
{
    if (!_agreeButton)
    {
        _agreeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_agreeButton setTitle:@"接受" forState:UIControlStateNormal];
        [_agreeButton setTitleColor:kCommonWhiteColor forState:UIControlStateNormal];
        _agreeButton.backgroundColor = kCommonBlueColor;
        _agreeButton.layer.cornerRadius = 4;
        [[_agreeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            ULBaseRequest *request = [[ULBaseRequest alloc]init];
            request.isJson = NO;
            [request postDataWithParameter:@{@"applyId":@(self.model.labID),
                                             @"status":@(1)} session:YES progress:nil success:^(ULBaseRequest *request, NSDictionary *responseObject) {
                                                 _rejectButton.hidden = YES;
                                                 _agreeButton.hidden = YES;
                                                 [self.view addSubview:self.stateLabel];
                                                 self.stateLabel.text = @"已拒绝";
                                                 [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                                                     make.centerX.equalTo(self.view);
                                                     make.bottom.equalTo(self.view).offset(-80);
                                                 }];
                                             } failure:^(ULBaseRequest *request, NSError *error) {
                                                 [ULProgressHUD showWithMsg:@"请求失败"];
                                             } withPath:@"ulab_lab/lab/friendlyApply/status"];
        }];
        
    }
    return _agreeButton;
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
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        _tableView.backgroundColor = kBackgroundColor;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ULLabDetailTableViewCellIdentifier"];
        UIView *view= [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 120)];
        view.backgroundColor = kCommonWhiteColor;
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.font = kFont(kStandardPx(30));
        nameLabel.text = @"实验室简介";
        [view addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(view).offset(10);
            make.left.equalTo(view).offset(15);
            make.height.mas_equalTo(17);
        }];
        nameLabel.textColor = KTextGrayColor;
        UILabel *textLabel = [[UILabel alloc]init];
        textLabel.text = self.model.labIntroduction;
        textLabel.textColor = KTextGrayColor;
        textLabel.font = kFont(kStandardPx(30));
        [view addSubview:textLabel];
        [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(nameLabel);
            make.top.equalTo(nameLabel.mas_bottom).offset(10);
            make.bottom.equalTo(view);
            make.right.equalTo(view);
        }];
        _tableView.tableFooterView = view;
    }
    return _tableView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.row == 2)
//    {
//        CGSize size = [self.model.labIntroduction sizeWithAttributes:@{NSFontAttributeName: kFont(kStandardPx(30))}];
//        return size.height;
//    } else {
        return 45;
//    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ULLabDetailTableViewCellIdentifier"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = kCommonWhiteColor;
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.font = kFont(kStandardPx(30));
    nameLabel.text = _nameArray[indexPath.row];
    nameLabel.textColor = KTextGrayColor;
    [cell addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell).offset(15);
        make.centerY.equalTo(cell);
    }];
    UILabel *detailLabel = [[UILabel alloc] init];
    detailLabel.textColor = KTextGrayColor;
    detailLabel.text = _detailArray[indexPath.row];
    detailLabel.font = kFont(kStandardPx(30));
    [cell addSubview:detailLabel];
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
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
- (UIView *)headerView
{
    if (!_headerView)
    {
        _headerView = [[UIView alloc] init];
        _headerView.backgroundColor = kCommonWhiteColor;
        UIImageView *headerImageView = [[UIImageView alloc] init];
        [headerImageView sd_setImageWithURL:[NSURL URLWithString:self.model.labImage] placeholderImage:[UIImage imageNamed:@"ulab_user_default"]];
        headerImageView.layer.cornerRadius = 25.5;
        headerImageView.layer.masksToBounds = YES;
        [_headerView addSubview:headerImageView];
        [headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_headerView);
            make.left.equalTo(_headerView).offset(15);
            make.size.mas_equalTo(CGSizeMake(51, 51));
        }];
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.text = self.model.labName;
        nameLabel.textColor = [UIColor blackColor];
        nameLabel.font = kFont(kStandardPx(34));
        [_headerView addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(headerImageView.mas_right).offset(17);
            make.top.equalTo(_headerView).offset(21);
        }];
        UILabel *detailLabel = [[UILabel alloc] init];
        NSString *detailString = self.model.labLocation;
        detailLabel.textColor = KTextGrayColor;
        detailLabel.text = detailString;
        detailLabel.font = kFont(kStandardPx(28));
        detailLabel.numberOfLines = 0;
        [_headerView addSubview:detailLabel];
        [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(nameLabel);
            make.top.equalTo(nameLabel.mas_bottom).offset(13);
        }];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_user_next"]];
        [_headerView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_headerView).offset(-15);
            make.centerY.equalTo(_headerView);
            make.size.mas_equalTo(CGSizeMake(10, 15));
        }];
    }
    return _headerView;
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
