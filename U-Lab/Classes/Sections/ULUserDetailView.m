//
//  ULUserDetailView.m
//  U-Lab
//
//  Created by 周维康 on 17/5/30.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULUserDetailView.h"
#import "ZWKAlertView.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface ULUserDetailView() <UITableViewDelegate, UITableViewDataSource, ZWKAlertViewDelegate>

@property (nonatomic, strong) UITableView *detailTableView;  /**< 详情列表 */
@property (nonatomic, strong) UIButton *headerView;  /**< 顶部按钮 */
@property (nonatomic, strong) UIImageView *bottomView;  /**< 底部花篮 */

@property (nonatomic, strong) ZWKAlertView *alertView;  /**< 退出登录 */
@end

@implementation ULUserDetailView
{
    NSArray *_nameArray;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.schoolText = [[UITextField alloc]init];
        self.researchText = [[UITextField alloc]init];
    }
    return self;
}

- (void)reloadData{
    NSString *userPhone = [ULUserMgr sharedMgr].userPhone ? [ULUserMgr sharedMgr].userPhone : @"";
    NSString *research = [ULUserMgr sharedMgr].research ? [ULUserMgr sharedMgr].research : @"";
    NSString *userEmail = [ULUserMgr sharedMgr].userEmail ? [ULUserMgr sharedMgr].userEmail : @"";
    NSString *school = [ULUserMgr sharedMgr].school ? [ULUserMgr sharedMgr].school : @"";
    _detailArray = @[userPhone, research, userEmail, school];
    [self.detailTableView reloadData];
}

- (void)ul_bindViewModel
{
    
}

- (void)ul_setupViews
{
    NSLog(@"%@",[ULUserMgr sharedMgr].userEmail);
    _nameArray = @[@"手机号码", @"研究方向", @"常用邮箱", @"毕业院校"];
    NSString *userPhone = [ULUserMgr sharedMgr].userPhone ? [ULUserMgr sharedMgr].userPhone : @"";
    NSLog(@"%@",[ULUserMgr sharedMgr].research);
    NSString *research = [ULUserMgr sharedMgr].research ? [ULUserMgr sharedMgr].research : @"";
    NSString *userEmail = [ULUserMgr sharedMgr].userEmail ? [ULUserMgr sharedMgr].userEmail : @"";
    NSString *school = [ULUserMgr sharedMgr].school ? [ULUserMgr sharedMgr].school : @"";
    _detailArray = @[userPhone, research, userEmail, school];
    self.changeSubject = [RACSubject subject];
    
    [self addSubview:self.detailTableView];
    [self addSubview:self.headerView];
    [self addSubview:self.bottomView];
    [self updateConstraintsIfNeeded];
    [self setNeedsUpdateConstraints];
    [self registerNotification];
}

- (void)updateConstraints
{
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(64+15);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(88);
    }];
    [self.detailTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom).offset(15);
        make.left.right.equalTo(self);
        make.bottom.equalTo(self).offset(-33);
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(33);
    }];
    [super updateConstraints];
}

- (UITableView *)detailTableView
{
    if (!_detailTableView)
    {
        _detailTableView = [[UITableView alloc] init];
        _detailTableView.delegate = self;
        _detailTableView.dataSource = self;
        _detailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _detailTableView.backgroundColor = kBackgroundColor;
        _detailTableView.scrollEnabled = NO;
        [_detailTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ULUserDetailTableViewCellIdentifier"];
    }
    return _detailTableView;
}

- (UIButton *)headerView
{
    if (!_headerView)
    {
        _headerView = [UIButton buttonWithType:UIButtonTypeCustom];
        _headerView.backgroundColor = kCommonWhiteColor;
        self.headerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ulab_user_default"]];
        if ([ULUserMgr sharedMgr].avaterImageUrl&&[ULUserMgr sharedMgr].avaterImage) {
            self.headerImageView.image = [ULUserMgr sharedMgr].avaterImage;
        }else if ([ULUserMgr sharedMgr].avaterImageUrl){
            [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:[ULUserMgr sharedMgr].avaterImageUrl] placeholderImage:[UIImage imageNamed:@"ulab_user_default"]];
        }else if ([ULUserMgr sharedMgr].avaterImage){
            self.headerImageView.image = [ULUserMgr sharedMgr].avaterImage;
        }
        self.headerImageView.layer.cornerRadius = 25.5;
        self.headerImageView.layer.masksToBounds = YES;
        [_headerView addSubview:self.headerImageView];
        [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_headerView);
            make.left.equalTo(_headerView).offset(15);
            make.size.mas_equalTo(CGSizeMake(51, 51));
        }];
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.text = [ULUserMgr sharedMgr].userName;
        nameLabel.textColor = [UIColor blackColor];
        nameLabel.font = kFont(kStandardPx(34));
        [_headerView addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.headerImageView.mas_right).offset(17);
            make.top.equalTo(_headerView).offset(21);
        }];
        UILabel *detailLabel = [[UILabel alloc] init];
        NSString *detailString = [ULUserMgr sharedMgr].laboratoryName;
        detailLabel.textColor = KTextGrayColor;
        detailLabel.text = detailString;
        detailLabel.font = kFont(kStandardPx(28));
        [_headerView addSubview:detailLabel];
        [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(nameLabel);
            make.top.equalTo(nameLabel.mas_bottom).offset(13);
        }];
        UIImageView *imageView = [[UIImageView alloc] init];
        if ([[ULUserMgr sharedMgr].sex  isEqual: @0])
        {
            imageView.image = [UIImage imageNamed:@"user_sex_womem"];
            [_headerView addSubview:imageView];
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(nameLabel.mas_right).offset(4);
                make.centerY.equalTo(nameLabel);
                make.size.mas_equalTo(CGSizeMake(8.5,13));
            }];
        } else {
            imageView.image = [UIImage imageNamed:@"user_sex_mem"];
            [_headerView addSubview:imageView];
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(nameLabel.mas_right).offset(4);
                make.centerY.equalTo(nameLabel);
                make.size.mas_equalTo(CGSizeMake(13,13.5));
            }];
        }
        
        @weakify(self)
        [[_headerView rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self)
            [self.improveSubject sendNext:nil];
        }];
    }
    return _headerView;
}

- (UIImageView *)bottomView
{
    if (!_bottomView)
    {
        _bottomView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"register_bottom"]];
    }
    return _bottomView;
}

- (RACSubject *)improveSubject
{
    if (!_improveSubject)
    {
        _improveSubject = [RACSubject subject];
    }
    return _improveSubject;
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _detailArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ULUserDetailTableViewCellIdentifier"];
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.font = kFont(kStandardPx(30));
    nameLabel.text = _nameArray[indexPath.row];
    nameLabel.textColor = KTextGrayColor;
    [cell addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell).offset(15);
        make.centerY.equalTo(cell);
    }];
    if (indexPath.row == 1)
    {
        if ([[ULUserMgr sharedMgr].research isKindOfClass:[NSNull class]]) {
            [ULUserMgr sharedMgr].research = nil;
        }
        self.researchText.text = [ULUserMgr sharedMgr].research?:@"";
        self.researchText.font = kFont(kStandardPx(30));
        self.researchText.textColor = KTextGrayColor;
        [self setTextFieldInputAccessoryView:self.researchText];
        self.researchText.textAlignment = NSTextAlignmentRight;
        [cell addSubview:self.researchText];
        [self.researchText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(cell).offset(-15);
            make.left.equalTo(nameLabel.mas_right).offset(15);
            make.centerY.equalTo(cell);
        }];
    } else if (indexPath.row == 3) {
//        self.schoolText = [[UITextField alloc] init];
        self.schoolText.text = [ULUserMgr sharedMgr].school;
        self.schoolText.font = kFont(kStandardPx(30));
        self.schoolText.textColor = KTextGrayColor;
        self.schoolText.textAlignment = NSTextAlignmentRight;
        [self setTextFieldInputAccessoryView:self.schoolText];
        [cell addSubview:self.schoolText];
        [self.schoolText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(cell).offset(-15);
            make.left.equalTo(nameLabel.mas_right).offset(15);
            make.centerY.equalTo(cell);
        }];
    } else {
        UILabel *detailLabel = [[UILabel alloc] init];
        detailLabel.textColor = KTextGrayColor;
        detailLabel.text = _detailArray[indexPath.row];
        detailLabel.font = kFont(kStandardPx(30));
        [cell addSubview:detailLabel];
        [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(cell).offset(-15);
            make.centerY.equalTo(cell);
        }];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.schoolText.userInteractionEnabled)
    {
        if ([ULUserMgr sharedMgr].regType == 0) {
            if (indexPath.row == 2)
            {
                [self.changeSubject sendNext:@(indexPath.row)];
            }
        }else{
            if (indexPath.row == 0)
            {
                [self.changeSubject sendNext:@(indexPath.row)];
            }
        }
        
    }
}
- (void)setTextFieldInputAccessoryView:(UITextField *)textField{
    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 40)];
    [topView setBarStyle:UIBarStyleDefault];
    UIBarButtonItem * spaceBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [doneBtn setTitle:@"完成" forState:UIControlStateNormal];
    doneBtn.frame = CGRectMake(2, 5, 40, 45);
    [doneBtn addTarget:self action:@selector(dealKeyboardHide) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *doneBtnItem = [[UIBarButtonItem alloc]initWithCustomView:doneBtn];
    NSArray * buttonsArray = [NSArray arrayWithObjects:spaceBtn,doneBtnItem,nil];
    [topView setItems:buttonsArray];
    
    [textField setInputAccessoryView:topView];
    [textField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [textField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    
}

- (void)dealKeyboardHide {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

- (void)registerNotification
{
    @weakify(self)
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillShowNotification object:nil]
     subscribeNext:^(NSNotification *notification) {
         @strongify(self)
         if (self.schoolText.isFirstResponder)
         {
             NSDictionary *info = [notification userInfo];
             NSValue *keyboardFrameValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
             CGRect keyboardFrame = [keyboardFrameValue CGRectValue];
             [UIView animateWithDuration:1.0f animations:^{
                 [self.headerView mas_updateConstraints:^(MASConstraintMaker *make) {
                     make.top.equalTo(self).offset(100-keyboardFrame.size.height/2);
                 }];
                 [self.headerView.superview layoutIfNeeded];
             }];
         }
         
     }];
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillHideNotification object:nil] subscribeNext:^(id x) {
        @strongify(self)
        [UIView animateWithDuration:1.0f animations:^{
            [self.headerView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self).offset(79);
            }];
            [self.headerView.superview layoutIfNeeded];
        }];
    }];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:UIKeyboardWillShowNotification];
    [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:UIKeyboardWillHideNotification];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
}
@end
