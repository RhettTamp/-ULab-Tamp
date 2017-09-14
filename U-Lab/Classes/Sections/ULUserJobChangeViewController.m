//
//  ULUserJobChangeViewController.m
//  ULab
//
//  Created by 周维康 on 2017/6/23.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULUserJobChangeViewController.h"
#import "YYTextView.h"
#import "ULUserJobModel.h"
#import "ULUserJobViewModel.h"

@interface ULUserJobChangeViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) UILabel *titleLabel;  /**< 标题 */
@property (nonatomic, strong) UITextField *titleText;  /**< 标题 */
@property (nonatomic, strong) UILabel *timeLabel;  /**< 时间 */
@property (nonatomic, strong) UIButton *timeButton;  /**< 时间 */
@property (nonatomic, strong) UILabel *contextLabel;  /**< 内容 */
@property (nonatomic, strong) YYTextView *contextText;  /**< 内容 */
@property (nonatomic, strong) UIButton *creatButton;  /**< 新建 */
@property (nonatomic, strong) UIImageView *bottomView;  /**< 底部花篮 */
@property (nonatomic, strong) ULUserJobViewModel *viewModel;  /**< VM */
@property (nonatomic, strong) UIDatePicker *datePicker;  /**< <#comment#> */
@property (nonatomic, strong) UIView *whiteView;  /**< <#comment#> */
@property (nonatomic, strong) UILabel *timeDetailLabel;  /**< <#comment#> */
@property (nonatomic, strong) ULUserJobModel *job;  /**< <#comment#> */
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger userId;

@end


@implementation ULUserJobChangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.type == 0) {
        self.titleText.enabled = NO;
        self.timeButton.enabled = NO;
        self.contextText.editable = NO;
        self.creatButton.hidden = YES;
    }
}

- (instancetype)initWithUserId:(NSInteger)userId andType:(NSInteger)type{
    self.userId = userId;
    self.type = type;
    if (self = [super init]) {
        
    }
    return self;
}

- (instancetype)initWithJob:(ULUserJobModel *)job andType:(NSInteger)type
{
    self.type = type;
    self.job = job;
    self = [super init];
    return self;
}

- (void)ul_layoutNavigation
{
    if (self.type == 1) {
        self.title = @"修改工作";
    }else{
        self.title = @"查看他人工作";
    }
    
}

- (void)ul_addSubviews
{
    self.view.backgroundColor = kBackgroundColor;
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.titleText];
    [self.view addSubview:self.timeLabel];
    [self.view addSubview:self.timeButton];
    [self.view addSubview:self.contextLabel];
    [self.view addSubview:self.contextText];
    [self.view addSubview:self.creatButton];
    [self.view addSubview:self.bottomView];
    [self registerNotification];
    self.datePicker = [[UIDatePicker alloc] init];
    self.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    self.datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh"];
    self.datePicker.backgroundColor = kBackgroundColor;
    self.whiteView = [[UIView alloc] init];
    self.whiteView.backgroundColor = kBackgroundColor;
    [self.view addSubview:self.whiteView];
    [self.whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(45);
        make.top.equalTo(self.view.mas_bottom);
    }];
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [doneButton setTitle:@"完成" forState:UIControlStateNormal];
    [doneButton setTitleColor:KButtonBlueColor forState:UIControlStateNormal];
    @weakify(self)
    [[doneButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        NSDate * date = [self.datePicker date];
        
        NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        NSString * dateString = [formatter stringFromDate:date];
        self.timeDetailLabel.text = dateString;
        [self.whiteView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_bottom);
        }];
    }];
    [self.whiteView addSubview:doneButton];
    [doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.whiteView).offset(-15);
        make.centerY.equalTo(self.whiteView);
    }];
    [self.view addSubview:self.datePicker];
    [self.datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.whiteView.mas_bottom);
        make.height.mas_equalTo(180);
    }];
    if (self.job) {
        [self reloadData];
    }
    
}
- (void)updateViewConstraints
{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(12);
        make.top.equalTo(self.view).offset(76);
    }];
    [self.titleText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(44);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(9);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(self.titleText.mas_bottom).offset(12);
    }];
    [self.timeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(44);
        make.top.equalTo(self.timeLabel.mas_bottom).offset(9);
    }];
    [self.contextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(self.timeButton.mas_bottom).offset(12);
    }];
    [self.contextText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(100);
        make.top.equalTo(self.contextLabel.mas_bottom).offset(9);
    }];
    [self.creatButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.left.equalTo(self.view).offset(24);
        make.top.equalTo(self.contextText.mas_bottom).offset(41);
        make.height.mas_equalTo(44);
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(33);
    }];
    [super updateViewConstraints];
}

- (void)ul_bindViewModel
{
    [self.viewModel.updateCommand.executionSignals.flatten subscribeNext:^(id x) {
        [ULProgressHUD hide];
        [ULProgressHUD showWithMsg:@"修改成功"];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    if (self.userId) {
        [self.viewModel.otherJobCommand execute:@{@"otherId":@(self.userId)}];
        [self.viewModel.otherJobSubject subscribeNext:^(id x) {
            self.job = x;
            [self reloadData];
        }];
    }
    
}

- (void)reloadData{
    _titleText.text = self.job.jobTitle;
    self.timeDetailLabel.text = self.job.jobTime;
    _contextText.text = self.job.jobContent;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = kFont(kStandardPx(28));
        _titleLabel.text = @"工作标题";
        _titleLabel.textColor = KTextGrayColor;
    }
    return _titleLabel;
}

- (UITextField *)titleText
{
    if (!_titleText)
    {
        _titleText = [[UITextField alloc] init];
        _titleText.font = kFont(kStandardPx(32));
        _titleText.placeholder = @"请填写工作标题";
        _titleText.textColor = [UIColor blackColor];
        _titleText.delegate = self;
        _titleText.backgroundColor = kCommonWhiteColor;
        UIView *left = [[UIView alloc] init];
        left.backgroundColor = kCommonWhiteColor;
        left.frame = CGRectMake(0, 0, 15, 45);
        _titleText.leftViewMode = UITextFieldViewModeAlways;
        _titleText.leftView = left;
    }
    return _titleText;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel)
    {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = kFont(kStandardPx(28));
        _timeLabel.text = @"工作时间";
        _timeLabel.textColor = KTextGrayColor;
    }
    return _timeLabel;
}

- (UIButton *)timeButton
{
    if (!_timeButton)
    {
        _timeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.timeDetailLabel = [[UILabel alloc] init];
        self.timeDetailLabel.font = kFont(kStandardPx(32));
        [_timeButton addSubview:self.timeDetailLabel];
        [self.timeDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_timeButton).offset(15);
            make.centerY.equalTo(_timeButton);
        }];
        _timeButton.backgroundColor = kCommonWhiteColor;
        [[_timeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            [self.whiteView mas_updateConstraints:^(MASConstraintMaker *make) {
                [self.view endEditing:YES];
                make.top.equalTo(self.view.mas_bottom).offset(-180-45);
            }];
        }];
        
        
    }
    return _timeButton;
}


- (UILabel *)contextLabel
{
    if (!_contextLabel)
    {
        _contextLabel = [[UILabel alloc] init];
        _contextLabel.font = kFont(kStandardPx(28));
        _contextLabel.text = @"工作内容";
        _contextLabel.textColor = KTextGrayColor;
    }
    return _contextLabel;
}

- (YYTextView *)contextText
{
    if (!_contextText)
    {
        _contextText = [[YYTextView alloc] init];
        _contextText.font = kFont(kStandardPx(32));
        _contextText.textColor = [UIColor blackColor];
        _contextText.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
        _contextText.textContainerInset = UIEdgeInsetsMake(4, 15, 0, -15);
        _contextText.backgroundColor = kCommonWhiteColor;
    }
    return _contextText;
}


- (UIButton *)creatButton
{
    if (!_creatButton)
    {
        _creatButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _creatButton.layer.cornerRadius = 5;
        _creatButton.layer.masksToBounds = YES;
        _creatButton.backgroundColor = KButtonBlueColor;
        _creatButton.titleLabel.font = kFont(kStandardPx(39));
        [_creatButton setTitleColor:kCommonWhiteColor forState:UIControlStateNormal];
        [_creatButton setTitle:@"修改" forState:UIControlStateNormal];
        @weakify(self)
        [[_creatButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self)
            [self hideKeyboard];
            if ([self.titleText.text  isEqual: @""])
            {
                [ULProgressHUD showWithMsg:@"请填写工作标题" inView:self.view];
            } else if ([self.timeDetailLabel.text  isEqual: @""]) {
                [ULProgressHUD showWithMsg:@"请填写工作时间" inView:self.view];
            } else if ([self.contextText.text  isEqual: @""]) {
                [ULProgressHUD showWithMsg:@"请填写工作内容" inView:self.view];
            } else {
                [ULProgressHUD showWithMsg:@"工作创建中" inView:self.view withBlock:^{
                    [self.viewModel.updateCommand execute:@{
                                                         @"id" : @(self.job.jobId),
                                                         @"title" : self.titleText.text,
                                                         @"time" : [NSString stringWithFormat:@"%@", self.timeDetailLabel.text],
                                                         @"content" : self.contextText.text
                                                         }];
                }];
                
            }
        }];
    }
    return _creatButton;
}

- (ULUserJobViewModel *)viewModel
{
    if (!_viewModel)
    {
        _viewModel = [[ULUserJobViewModel alloc] init];
    }
    return _viewModel;
}

- (void)registerNotification
{
    @weakify(self)
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillShowNotification object:nil]
     subscribeNext:^(NSNotification *notification) {
         @strongify(self)
         if(self.contextText.isFirstResponder) {
             NSDictionary *info = [notification userInfo];
             NSValue *keyboardFrameValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
             CGRect keyboardFrame = [keyboardFrameValue CGRectValue];
             [UIView animateWithDuration:1.0f animations:^{
                 [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                     make.top.equalTo(self.view).offset(76-(keyboardFrame.size.height-(screenHeight-self.creatButton.frame.origin.y)));
                 }];
                 [self.titleLabel.superview layoutIfNeeded];
             }];
             
         }
     }];
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillHideNotification object:nil] subscribeNext:^(id x) {
        @strongify(self)
        if(self.contextText.isFirstResponder) {
            [UIView animateWithDuration:1.0f animations:^{
                [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.view).offset(76);
                }];
                [self.titleLabel.superview layoutIfNeeded];
            }];
        }
    }];
}

- (void)hideKeyboard
{
    [self.titleText resignFirstResponder];
    [self.contextText resignFirstResponder];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.titleText resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self hideKeyboard];
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
