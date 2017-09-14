//
//  ULGroupCreatViewController.m
//  ULab
//
//  Created by 周维康 on 2017/6/20.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULGroupCreatViewController.h"
#import "ULMainShareSelectViewController.h"
#import "YYTextView.h"

@interface ULGroupCreatViewController() <UITextFieldDelegate, YYTextViewDelegate>

@property (nonatomic, strong) UILabel *nameLabel;  /**< 群名册 */
@property (nonatomic, strong) UITextField *nameText;  /**< <#comment#> */
@property (nonatomic, strong) UILabel *detailLabel;  /**< <#comment#> */
@property (nonatomic, strong) YYTextView *textView;  /**< <#comment#> */
@property (nonatomic, strong) UILabel *memberLabel;  /**< <#comment#> */
@property (nonatomic, strong) UIView *memberView;  /**< <#comment#> */
@property (nonatomic, strong) UIButton *creatButton;  /**< <#comment#> */
@property (nonatomic, strong) UIImageView *bottomView;  /**< <#comment#> */
@property (nonatomic, strong) NSMutableArray *memberArray;  /**< <#comment#> */
@property (nonatomic, strong) UILabel *numLabel;  /**< <#comment#> */

@end

@implementation ULGroupCreatViewController

- (void)ul_bindViewModel
{
    
}

- (void)ul_addSubviews
{
    self.view.backgroundColor = kBackgroundColor;
    self.memberArray = [NSMutableArray array];
    [self.view addSubview:self.nameLabel];
    [self.view addSubview:self.detailLabel];
    [self.view addSubview:self.nameText];
    [self.view addSubview:self.textView];
    [self.view addSubview:self.memberView];
    [self.view addSubview:self.memberLabel];
    [self.view addSubview:self.creatButton];
    [self.view addSubview:self.bottomView];
    [self.view updateConstraintsIfNeeded];
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.top.equalTo(self.view).offset(64+14);
    }];
    [self.nameText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(8);
        make.height.mas_equalTo(45);
    }];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.top.equalTo(self.nameText.mas_bottom).offset(14);
    }];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(100);
        make.top.equalTo(self.detailLabel.mas_bottom).offset(8);
    }];
    [self.memberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.top.equalTo(self.textView.mas_bottom).offset(14);
    }];
    [self.memberView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.memberLabel.mas_bottom).offset(8);
        make.height.mas_equalTo(90);
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(33);
    }];
    [self.creatButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.memberLabel.mas_bottom).offset(138);
        make.height.mas_equalTo(45);
    }];
    [super updateViewConstraints];
}
- (void)ul_layoutNavigation
{
    self.title = @"创建群";
}

- (UILabel *)nameLabel
{
    if (!_nameLabel)
    {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = kFont(kStandardPx(28));
        _nameLabel.text = @"群名称";
        _nameLabel.textColor = KTextGrayColor;
    }
    return _nameLabel;
}

- (YYTextView *)textView
{
    if (!_textView)
    {
        _textView = [[YYTextView alloc] init];
        _textView.font = kFont(kStandardPx(32));
        _textView.placeholderText = @"请填写群信息";
        _textView.textColor = [UIColor blackColor];
        _textView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
        _textView.textContainerInset = UIEdgeInsetsMake(4, 15, 0, -15);
        _textView.backgroundColor = kCommonWhiteColor;
        _textView.delegate = self;
        [self setTextFieldInputAccessoryView:nil];
    }
    return _textView;
}

- (UILabel *)detailLabel
{
    if (!_detailLabel)
    {
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.font = kFont(kStandardPx(28));
        _detailLabel.text = @"群信息";
        _detailLabel.textColor = KTextGrayColor;
    }
    return _detailLabel;
}


- (UILabel *)memberLabel
{
    if (!_memberLabel)
    {
        _memberLabel = [[UILabel alloc] init];
        _memberLabel.font = kFont(kStandardPx(28));
        _memberLabel.text = @"添加成员";
        _memberLabel.textColor = KTextGrayColor;
    }
    return _memberLabel;
}

- (UITextField *)nameText
{
    if (!_nameText)
    {
        _nameText = [[UITextField alloc] init];
        _nameText.font = kFont(kStandardPx(32));
        _nameText.placeholder = @"请填写群名称";
        _nameText.textColor = [UIColor blackColor];
        _nameText.delegate = self;
        _nameText.backgroundColor = kCommonWhiteColor;
        UIView *left = [[UIView alloc] init];
        left.backgroundColor = kCommonWhiteColor;
        left.frame = CGRectMake(0, 0, 15, 45);
        _nameText.leftViewMode = UITextFieldViewModeAlways;
        _nameText.leftView = left;
    }
    return _nameText;
}

- (UIView *)memberView
{
    if (!_memberView)
    {
        _memberView = [[UIView alloc] init];
        _memberView.backgroundColor = kCommonWhiteColor;
        self.numLabel = [[UILabel alloc] init];
        self.numLabel.font = kFont(kStandardPx(28));
        self.numLabel.text = [NSString stringWithFormat:@"已选%@人", @(self.memberArray.count)];
        self.numLabel.textColor = KTextGrayColor;
        UIImageView *next = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_user_next"]];
        [_memberView addSubview:next];
        [next mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_memberView).offset(-15);
            make.centerY.equalTo(_memberView);
            make.size.mas_equalTo(CGSizeMake(10, 15));
        }];

        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"message_group_user"]];
        [_memberView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_memberView).offset(15);
            make.centerY.equalTo(_memberView);
            make.size.mas_equalTo(CGSizeMake(20, 30));
        }];
        [_memberView addSubview:self.numLabel];
        [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(next.mas_left).offset(-6);
            make.centerY.equalTo(_memberView);
        }];
        @weakify(self)
        [self.memberArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx>2)
            {
                *stop = YES;
            } else {
                JMSGUser *user = obj;
                UIImageView *avator = [[UIImageView alloc] initWithImage:[UIImage imageWithData:[NSData dataWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:user.avatar]]]]];
                avator.layer.cornerRadius = 22.5;
                avator.layer.masksToBounds = YES;
                [_memberView addSubview:avator];
                [avator mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(_memberView).offset(idx*47+45);
                    make.centerY.equalTo(_memberView);
                    make.size.mas_equalTo(CGSizeMake(45, 45));
                }];
            }
            
        }];
        UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [addButton setBackgroundImage:[UIImage imageNamed:@"message_group_add"] forState:UIControlStateNormal];
        [[addButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self)
            ULMainShareSelectViewController *selectVC = [[ULMainShareSelectViewController alloc] initWithSelectType:ULMainShareSelectTypeFriend];
            [selectVC.popSubject subscribeNext:^(id x) {
                self.memberArray = x[@"result"];
                self.numLabel.text = [NSString stringWithFormat:@"已选%@人", @(self.memberArray.count)];
                [self.memberArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (idx>2)
                    {
                        *stop = YES;
                    } else {
                        JMSGUser *user = obj;
                        UIImageView *avator = [[UIImageView alloc] initWithImage:[UIImage imageWithData:[NSData dataWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:user.avatar]]]]];
                        avator.layer.cornerRadius = 22.5;
                        avator.layer.masksToBounds = YES;
                        [_memberView addSubview:avator];
                        [avator mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.equalTo(_memberView).offset(idx*47+45);
                            make.centerY.equalTo(_memberView);
                            make.size.mas_equalTo(CGSizeMake(45, 45));
                        }];
                        if (self.memberArray.count<3)
                        {
                            [addButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                                make.left.equalTo(_memberView).offset(self.memberArray.count*47+45);
                                make.size.mas_equalTo(CGSizeMake(45, 45));
                                make.centerY.equalTo(_memberView);
                            }];
                        } else {
                            [addButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                                make.left.equalTo(_memberView).offset(3*47+45);
                                make.size.mas_equalTo(CGSizeMake(45, 45));
                                make.centerY.equalTo(_memberView);
                            }];
                        }
                    }
                    
                }];
            }];
            [self.navigationController pushViewController:selectVC animated:YES];
        }];
        [_memberView addSubview:addButton];
        if (self.memberArray.count<3)
        {
            [addButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_memberView).offset(self.memberArray.count*47+45);
                make.size.mas_equalTo(CGSizeMake(45, 45));
                make.centerY.equalTo(_memberView);
            }];
        } else {
            [addButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_memberView).offset(3*47+45);
                make.size.mas_equalTo(CGSizeMake(45, 45));
                make.centerY.equalTo(_memberView);
            }];
        }
    }
    return _memberView;
}

- (UIButton *)creatButton
{
    if (!_creatButton)
    {
        _creatButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _creatButton.backgroundColor = KButtonBlueColor;
        [_creatButton setTitle:@"创建" forState:UIControlStateNormal];
        _creatButton.layer.cornerRadius = 5;
        _creatButton.layer.masksToBounds = YES;
        [_creatButton setTitleColor:kCommonWhiteColor forState:UIControlStateNormal];
        @weakify(self)
        [[_creatButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            [ULProgressHUD showWithMsg:@"创建中" inView:self.view withBlock:^{
                @strongify(self)
                if ([self.nameText.text  isEqual: @""])
                {
                    [ULProgressHUD showWithMsg:@"请填写群名称"];
                } else if ([self.textView.text  isEqual: @""]) {
                    [ULProgressHUD showWithMsg:@"请填写群信息"];
                } else {
                    NSMutableArray *array = [NSMutableArray array];
                    for(JMSGUser *user in self.memberArray)
                    {
                        [array addObject:user.username];
                    }
                    [JMSGGroup createGroupWithName:self.nameText.text desc:self.textView.text memberArray:array completionHandler:^(id resultObject, NSError *error) {
                        if (!error) {
                            [ULProgressHUD showWithMsg:@"创建成功"];
                            JMSGGroup *group = (JMSGGroup *)resultObject;
                            [[ULUserMgr sharedMgr].groupArray addObject:group.gid];
                            [self.navigationController popViewControllerAnimated:YES];
                        }
                    }];
                }
            }];
            
        }];
    }
    return _creatButton;
}

- (UIImageView *)bottomView
{
    if (!_bottomView)
    {
        _bottomView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"register_bottom"]];
    }
    return _bottomView;
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
    
    [self.textView setInputAccessoryView:topView];
    [self.textView setAutocorrectionType:UITextAutocorrectionTypeNo];
    [self.textView setAutocapitalizationType:UITextAutocapitalizationTypeNone];
}

- (void)dealKeyboardHide
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.textView resignFirstResponder];
    [self.nameText resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.nameText resignFirstResponder];
    return YES;
}


@end
