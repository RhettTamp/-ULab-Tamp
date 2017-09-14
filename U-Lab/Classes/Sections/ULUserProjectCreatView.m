//
//  ULUserProjectCreatView.m
//  U-Lab
//
//  Created by 周维康 on 2017/6/6.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULUserProjectCreatView.h"
#import "ULUserLabViewModel.h"
#import "ULUserLabModel.h"

@interface ULUserProjectCreatView() <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIScrollView *scrollView;  /**< <#comment#> */
@property (nonatomic, strong) UILabel *nameLabel;  /**< 名字 */
@property (nonatomic, strong) UITextField *nameText;  /**< 名字 */
@property (nonatomic, strong) UILabel *introLabel;  /**< 简介 */
@property (nonatomic, strong) UITextField *introText;  /**< 简介 */
@property (nonatomic, strong) UILabel *detailLabel;  /**< 详情 */
@property (nonatomic, strong) UITableView *tableView;  /**< 实验列表 */
@property (nonatomic, strong) UIButton *addButton;  /**< 添加实验 */
@property (nonatomic, strong) UIButton *saveButton;  /**< 保存按钮 */
@property (nonatomic, strong) UIImageView *bottomView;  /**< 底部花篮 */
@property (nonatomic, strong) ULUserLabViewModel *viewModel;  /**< vm */
@end

@implementation ULUserProjectCreatView
{
    NSMutableArray *_labArray;
}

- (void)ul_setupViews
{
    self.backgroundColor = kBackgroundColor;
    self.popSubject = [RACSubject subject];
    self.viewModel = [[ULUserLabViewModel alloc] init];
    _labArray = [NSMutableArray array];
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.contentSize = CGSizeMake(screenWidth, screenHeight);
    self.scrollView.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0);
    [self addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self);
    }];
    [self.scrollView addSubview:self.nameText];
    [self.scrollView addSubview:self.nameLabel];
    [self.scrollView addSubview:self.introLabel];
    [self.scrollView addSubview:self.introText];
    [self.scrollView addSubview:self.detailLabel];
    [self.scrollView addSubview:self.tableView];
    [self.scrollView addSubview:self.saveButton];
    [self.scrollView addSubview:self.addButton];
    [self addSubview:self.bottomView];
    [self updateConstraintsIfNeeded];
    [self setNeedsUpdateConstraints];
}

- (void)ul_bindViewModel
{
    @weakify(self)
    [self.finishSubject subscribeNext:^(id x) {
        @strongify(self)
        ULUserLabModel *model = x;
        [_labArray addObject:model];
        [self.tableView reloadData];
        [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self.detailLabel.mas_bottom).offset(10);
            make.height.mas_equalTo(_labArray.count*80);
        }];
        self.scrollView.contentSize = CGSizeMake(screenWidth, screenHeight-160+_labArray.count*80);
    }];
    [self.viewModel.addProjectCommand.executionSignals.flatten subscribeNext:^(id x) {
        @strongify(self)
        NSNumber *projectId = x[@"data"];
        NSMutableArray *requestArray = [NSMutableArray array];
        for (ULUserLabModel *labModel in _labArray)
        {
            NSDictionary *dic = @{
                                  @"name":labModel.labName, //实验名称
                                  @"startTime": labModel.labTime, //开始时间
                                  @"endTime": labModel.labTime, //截止时间
                                  @"mainPoint":labModel.labMain, //要点
                                  @"introduction":labModel.labIntro, //介绍
                                  @"difficult":labModel.labDifficult, //难点
                                  @"projectId":projectId //项目id
                                  };
            [requestArray addObject:dic];
        }
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:requestArray options:0 error:&error];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        
        NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:@"http://47.92.133.141/ulab_user/users/experiment" parameters:nil error:nil];
        
        [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [req setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
        

        [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            if (!error)
                [self.popSubject sendNext:nil];
            else
                [ULProgressHUD showWithMsg:@"添加失败"];
        }] resume];
        
        

    }];
}
- (void)updateConstraints
{
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView).offset(81);
        make.left.equalTo(self.scrollView).offset(15);
    }];
    [self.nameText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(45);
    }];
    [self.introLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameText.mas_bottom).offset(17);
        make.left.equalTo(self.nameLabel);
    }];
    [self.introText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.introLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(45);
    }];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.top.equalTo(self.introText.mas_bottom).offset(17);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.detailLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(_labArray.count*80);
    }];
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-15);
        make.top.equalTo(self.tableView.mas_bottom).offset(8);
        make.size.mas_equalTo(CGSizeMake(80, 20));
    }];
    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableView.mas_bottom).offset(45);
        make.left.equalTo(self).offset(20);
        make.centerX.equalTo(self);
        make.height.mas_equalTo(40);
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(33);
    }];
    [super updateConstraints];
}

- (RACSubject *)finishSubject
{
    if (!_finishSubject)
    {
        _finishSubject = [RACSubject subject];
    }
    return _finishSubject;
}
- (UILabel *)nameLabel
{
    if (!_nameLabel)
    {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = kFont(kStandardPx(28));
        _nameLabel.text = @"项目名称";
        _nameLabel.textColor = KTextGrayColor;
    }
    return _nameLabel;
}

- (UITextField *)nameText
{
    if (!_nameText)
    {
        _nameText = [[UITextField alloc] init];
        _nameText.font = kFont(kStandardPx(32));
        _nameText.placeholder = @"请填写项目名称";
        _nameText.textColor = [UIColor blackColor];
        _nameText.delegate = self;
        UIView *left = [[UIView alloc] init];
        left.backgroundColor = kCommonWhiteColor;
        left.frame = CGRectMake(0, 0, 15, 45);
        _nameText.leftView = left;
        _nameText.leftViewMode = UITextFieldViewModeAlways;
        _nameText.backgroundColor = kCommonWhiteColor;
    }
    return _nameText;
}

- (UILabel *)introLabel
{
    if (!_introLabel)
    {
        _introLabel = [[UILabel alloc] init];
        _introLabel.font = kFont(kStandardPx(28));
        _introLabel.text = @"项目简介";
        _introLabel.textColor = KTextGrayColor;
    }
    return _introLabel;
}

- (UITextField *)introText
{
    if (!_introText)
    {
        _introText = [[UITextField alloc] init];
        _introText.font = kFont(kStandardPx(32));
        _introText.placeholder = @"请填写项目简介";
        _introText.textColor = [UIColor blackColor];
        _introText.delegate = self;
        UIView *left = [[UIView alloc] init];
        left.backgroundColor = kCommonWhiteColor;
        left.frame = CGRectMake(0, 0, 15, 45);
        _introText.leftView = left;
        _introText.leftViewMode = UITextFieldViewModeAlways;
        _introText.backgroundColor = kCommonWhiteColor;
    }
    return _introText;
}

- (UILabel *)detailLabel
{
    if (!_detailLabel)
    {
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.font = kFont(kStandardPx(28));
        _detailLabel.text = @"实验详情";
        _detailLabel.textColor = KTextGrayColor;
    }
    return _detailLabel;
}

- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = kBackgroundColor;
        _tableView.rowHeight = 80;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ULUserProjectTableViewCellIdentifier"];
    }
    return _tableView;
}

- (UIButton *)addButton
{
    if (!_addButton)
    {
        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addButton setTitle:@"添加实验" forState:UIControlStateNormal];
        [_addButton setTitleColor:KButtonBlueColor forState:UIControlStateNormal];
        _addButton.titleLabel.font = kFont(kStandardPx(30));
        @weakify(self)
        [[_addButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self)
          
                [self.addSubject sendNext:nil];
            
        }];
    }
    return _addButton;
}

- (UIButton *)saveButton
{
    if (!_saveButton)
    {
        _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _saveButton.backgroundColor = KButtonBlueColor;
        [_saveButton setTitleColor:kCommonWhiteColor forState:UIControlStateNormal];
        [_saveButton setTitle:@"保存" forState:UIControlStateNormal];
        _saveButton.layer.cornerRadius = 5;
        _saveButton.layer.masksToBounds = YES;
        [[_saveButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            if ([self.nameText.text  isEqual: @""])
            {
                [ULProgressHUD showWithMsg:@"请填写项目名称"];
            } else if ([self.introText.text  isEqual: @""]) {
                [ULProgressHUD showWithMsg:@"请填写项目介绍"];
            } else {
                  [ULProgressHUD showWithMsg:@"创建中" inView:self withBlock:^{
                [self.viewModel.addProjectCommand execute:@{
                                                        @"name":self.nameText.text, //项目名称
                                                        @"introduction":self.introText.text //项目介绍
                                                        }];
                  }];
            }
        }];
    }
    return _saveButton;
}

- (UIImageView *)bottomView
{
    if (!_bottomView)
    {
        _bottomView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"register_bottom"]];
    }
    return _bottomView;
}

- (RACSubject *)addSubject
{
    if (!_addSubject)
    {
        _addSubject = [RACSubject subject];
    }
    return _addSubject;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _labArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"ULUserProjectTableViewCellIdentifier"];
    for (UIView *subView in cell.subviews)
    {
        [subView removeFromSuperview];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = kCommonWhiteColor;
    UILabel *nameLabel = [[UILabel alloc] init];
    ULUserLabModel *model = _labArray[indexPath.row];
    nameLabel.text = model.labName;
    nameLabel.font = [UIFont systemFontOfSize:kStandardPx(34) weight:2];
    [cell addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell).offset(15);
        make.top.equalTo(cell).offset(20);
    }];
    UILabel *introLabel = [[UILabel alloc] init];
    introLabel.text = model.labMain;
    introLabel.textColor = kTextBlackColor;
    introLabel.font = kFont(kStandardPx(28));
    [cell addSubview:introLabel];
    [introLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLabel);
        make.top.equalTo(nameLabel.mas_bottom).offset(14);
    }];
    
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.text = model.labTime;
    timeLabel.textColor = KTextGrayColor;
    timeLabel.font = kFont(kStandardPx(28));
    [cell addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(cell).offset(-15);
        make.centerY.equalTo(nameLabel);
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
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.nameText resignFirstResponder];
    [self.introText resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.nameText resignFirstResponder];
    [self.introText resignFirstResponder];
    return YES;
}
@end
