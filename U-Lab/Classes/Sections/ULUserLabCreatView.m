//
//  ULUserLabCreatView.m
//  U-Lab
//
//  Created by 周维康 on 2017/6/3.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULUserLabCreatView.h"
#import "ULUserLabViewModel.h"
#import "ULUserLabModel.h"
#import "YYText.h"

@interface ULUserLabCreatView() <YYTextViewDelegate, UIScrollViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;  /**< 背景画动图 */
@property (nonatomic, strong) UILabel *nameLabel;  /**< 名称 */
@property (nonatomic, strong) UITextField *nameText;  /**< 名称 */
@property (nonatomic, strong) UILabel *timeLabel;  /**< 时间 */
@property (nonatomic, strong) UIButton *timeButton;  /**< 时间 */
@property (nonatomic, strong) UILabel *mainLabel;  /**< 要点 */
@property (nonatomic, strong) UITextField *mainText;  /**< 要点 */
@property (nonatomic, strong) UILabel *contextLabel;  /**< 内容 */
@property (nonatomic, strong) YYTextView *contextText;  /**< 内容 */
@property (nonatomic, strong) UILabel *diffLabel;  /**< 难点 */
@property (nonatomic, strong) YYTextView *diffText;  /**< 难点 */
@property (nonatomic, strong) UIButton *creatButton;  /**< 新建 */
@property (nonatomic, strong) ULUserLabViewModel *viewModel;  /**< VM */
@property (nonatomic, strong) NSNumber *projectId;  /**< projectId */
@property (nonatomic, strong) ULUserLabModel *model;  /**< model */
@property (nonatomic, strong) UIDatePicker *datePicker;  /**< <#comment#> */
@property (nonatomic, strong) UILabel *timeDetailLabel;  /**< <#comment#> */
@property (nonatomic, strong) UIView *whiteView;  /**< <#comment#> */
@end

@implementation ULUserLabCreatView
{
   
}

- (void)ul_setupViews
{
    self.backgroundColor = kBackgroundColor;
    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.nameLabel];
    [self.scrollView addSubview:self.nameText];
    [self.scrollView addSubview:self.timeLabel];
    [self.scrollView addSubview:self.timeButton];
    [self.scrollView addSubview:self.mainLabel];
    [self.scrollView addSubview:self.mainText];
    [self.scrollView addSubview:self.contextLabel];
    [self.scrollView addSubview:self.contextText];
    [self.scrollView addSubview:self.diffLabel];
    [self.scrollView addSubview:self.diffText];
    [self addSubview:self.creatButton];
    [self registerNotification];
    self.datePicker = [[UIDatePicker alloc] init];
    self.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    self.datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh"];
    self.datePicker.backgroundColor = kBackgroundColor;
    self.whiteView = [[UIView alloc] init];
    self.whiteView.backgroundColor = kBackgroundColor;
    [self addSubview:self.whiteView];
    [self.whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.mas_equalTo(45);
        make.top.equalTo(self.mas_bottom);
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
            make.top.equalTo(self.mas_bottom);
        }];
    }];
    [self.whiteView addSubview:doneButton];
    [doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.whiteView).offset(-15);
        make.centerY.equalTo(self.whiteView);
    }];
    [self addSubview:self.datePicker];
    [self.datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.whiteView.mas_bottom);
        make.height.mas_equalTo(180);
    }];

}


- (instancetype)initWithProjectId:(NSNumber *)projectId
{
    self.projectId = projectId;
    if (self = [super init])
    {
       
    }
    return self;
}

- (instancetype)initWithProjectId:(NSNumber *)projectId labModel:(ULUserLabModel *)model
{
    self.projectId = projectId;
    self.model = model;
    if (self = [super init])
    {
        
    }
    return self;
}

- (void)updateConstraints
{
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self).offset(64);
        make.height.mas_equalTo(screenHeight-64-110);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView).offset(12);
        make.top.equalTo(self.scrollView).offset(12);
    }];
    [self.nameText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.mas_equalTo(44);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(9);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.top.equalTo(self.nameText.mas_bottom).offset(12);
    }];
    [self.timeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.mas_equalTo(44);
        make.top.equalTo(self.timeLabel.mas_bottom).offset(9);
    }];
    [self.mainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.top.equalTo(self.timeButton.mas_bottom).offset(12);
    }];
    [self.mainText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.mas_equalTo(44);
        make.top.equalTo(self.mainLabel.mas_bottom).offset(9);
    }];
    [self.contextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.top.equalTo(self.mainText.mas_bottom).offset(12);
    }];
    [self.contextText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.mas_equalTo(100);
        make.top.equalTo(self.contextLabel.mas_bottom).offset(9);
    }];
    [self.diffLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.top.equalTo(self.contextText.mas_bottom).offset(12);
    }];
    [self.diffText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.mas_equalTo(100);
        make.top.equalTo(self.diffLabel.mas_bottom).offset(9);
    }];
    [self.creatButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.left.equalTo(self).offset(24);
        make.top.equalTo(self.scrollView.mas_bottom).offset(41);
        make.height.mas_equalTo(44);
    }];
    [super updateConstraints];
}
- (UILabel *)nameLabel
{
    if (!_nameLabel)
    {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = kFont(kStandardPx(28));
        _nameLabel.text = @"实验名称";
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
        _nameText.placeholder = @"请填写实验名称";
        _nameText.textColor = [UIColor blackColor];
        _nameText.delegate = self;
        _nameText.text = _model.labName;
        _nameText.backgroundColor = kCommonWhiteColor;
        UIView *left = [[UIView alloc] init];
        left.backgroundColor = kCommonWhiteColor;
        left.frame = CGRectMake(0, 0, 15, 45);
        _nameText.leftViewMode = UITextFieldViewModeAlways;
        _nameText.leftView = left;
    }
    return _nameText;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel)
    {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = kFont(kStandardPx(28));
        _timeLabel.text = @"实验时间";
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
        self.timeDetailLabel.text = [NSString stringWithFormat:@"%@ %@:00:00", [NSDate nowTime], @([NSDate date].hour+1)];;
        [_timeButton addSubview:self.timeDetailLabel];
        [self.timeDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_timeButton).offset(15);
            make.centerY.equalTo(_timeButton);
        }];
        _timeButton.backgroundColor = kCommonWhiteColor;
        if (_model)
        self.timeDetailLabel.text = _model.labTime;
        [[_timeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            [self endEditing:YES];
            [self.whiteView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.mas_bottom).offset(-180-45);
            }];
        }];
        
    }
    return _timeButton;
}

- (UILabel *)mainLabel
{
    if (!_mainLabel)
    {
        _mainLabel = [[UILabel alloc] init];
        _mainLabel.font = kFont(kStandardPx(28));
        _mainLabel.text = @"研究要点";
        _mainLabel.textColor = KTextGrayColor;
    }
    return _mainLabel;
}

- (UITextField *)mainText
{
    if (!_mainText)
    {
        _mainText = [[UITextField alloc] init];
        _mainText.font = kFont(kStandardPx(32));
        _mainText.placeholder = @"请填写研究要点";
        _mainText.textColor = [UIColor blackColor];
        _mainText.delegate = self;
        UIView *left = [[UIView alloc] init];
        left.backgroundColor = kCommonWhiteColor;
        left.frame = CGRectMake(0, 0, 15, 45);
        _mainText.leftViewMode = UITextFieldViewModeAlways;
        _mainText.leftView = left;
        _mainText.backgroundColor = kCommonWhiteColor;
        _mainText.text = _model.labMain;
    }
    return _mainText;
}

- (UILabel *)contextLabel
{
    if (!_contextLabel)
    {
        _contextLabel = [[UILabel alloc] init];
        _contextLabel.font = kFont(kStandardPx(28));
        _contextLabel.text = @"研究内容";
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
        _contextText.placeholderText = @"请填写研究内容";
        _contextText.textColor = [UIColor blackColor];
        _contextText.delegate = self;
        _contextText.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
        _contextText.textContainerInset = UIEdgeInsetsMake(10, 15, 0, -15);
        _contextText.backgroundColor = kCommonWhiteColor;
        _contextText.text = _model.labIntro;
    }
    return _contextText;
}

- (UILabel *)diffLabel
{
    if (!_diffLabel)
    {
        _diffLabel = [[UILabel alloc] init];
        _diffLabel.font = kFont(kStandardPx(28));
        _diffLabel.text = @"研究难点";
        _diffLabel.textColor = KTextGrayColor;
    }
    return _diffLabel;
}

- (YYTextView *)diffText
{
    if (!_diffText)
    {
        _diffText = [[YYTextView alloc] init];
        _diffText.font = kFont(kStandardPx(32));
        _diffText.placeholderText = @"请填写实验难点";
        _diffText.textColor = [UIColor blackColor];
        _diffText.delegate = self;
        _diffText.textContainerInset = UIEdgeInsetsMake(10, 15, 0, -15);
        _diffText.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
        _diffText.backgroundColor = kCommonWhiteColor;
        _diffText.text = _model.labDifficult;
    }
    return _diffText;
}


- (UIScrollView *)scrollView
{
    if (!_scrollView)
    {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.contentSize = CGSizeMake(screenWidth, 503);
        _scrollView.contentOffset = CGPointMake(0, 0);
        _scrollView.backgroundColor = kBackgroundColor;
        _scrollView.contentInset=UIEdgeInsetsMake(-64, 0, 0, 0);
        _scrollView.delegate = self;
    }
    return _scrollView;
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
      
        [_creatButton setTitle:@"完成" forState:UIControlStateNormal];
       
        @weakify(self)
        [[_creatButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self)
            [self hideKeyboard];
            if ([self.nameText.text  isEqual: @""])
            {
                [ULProgressHUD showWithMsg:@"请填写实验名称" inView:self];
            } else if ([self.timeDetailLabel.text  isEqual: @""]) {
                [ULProgressHUD showWithMsg:@"请填写实验时间" inView:self];
            } else if ([self.mainText.text  isEqual: @""]) {
                [ULProgressHUD showWithMsg:@"请填写研究要点" inView:self];
            } else if ([self.contextText.text  isEqual: @""]) {
                [ULProgressHUD showWithMsg:@"请填写研究内容" inView:self];
            } else if ([self.diffText.text  isEqual: @""]) {
                [ULProgressHUD showWithMsg:@"请填写研究难点" inView:self];
            } else {
                ULUserLabModel *model = [[ULUserLabModel alloc] init];
                model.labName = self.nameText.text;
                model.labIntro = self.contextText.text;
                model.labTime = self.timeDetailLabel.text;
                model.labDifficult = self.diffText.text;
                model.labMain = self.mainText.text;
                if (self.projectId)
                {
                    [self.viewModel.addCommand execute:@{
                                                        @"name": self.nameText.text,
                                                        @"startTime": self.timeDetailLabel.text,
                                                        @"endTime": self.timeDetailLabel.text,
                                                        @"mainPoint": self.mainText.text,
                                                        @"introduction":self.contextText.text,
                                                        @"difficult":self.diffText.text,
                                                        @"projectId":self.projectId
                                                        }];
                }
                if (self.model && self.isEdit)
                {
                    [self.viewModel.updateCommand execute:@{
                                                            @"name": self.nameText.text,
                                                            @"startTime": self.timeDetailLabel.text,
                                                            @"endTime": self.timeDetailLabel.text,
                                                            @"mainPoint": self.mainText.text,
                                                            @"introduction":self.contextText.text,
                                                            @"difficult":self.diffText.text,
                                                            @"id":@(self.model.labId)
                                                            }];
                }
                [self.finishSubject sendNext:model];
            }
        }];
    }
    return _creatButton;
}

- (RACSubject *)finishSubject
{
    if (!_finishSubject)
    {
        _finishSubject = [RACSubject subject];
    }
    return _finishSubject;
}
- (ULUserLabViewModel *)viewModel
{
    if (!_viewModel)
    {
        _viewModel = [[ULUserLabViewModel alloc] init];
    }
    return _viewModel;
}

- (void)registerNotification
{
    @weakify(self)
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillShowNotification object:nil]
     subscribeNext:^(NSNotification *notification) {
         @strongify(self)
         if(self.diffText.isFirstResponder || self.contextText.isFirstResponder) {
         NSDictionary *info = [notification userInfo];
         NSValue *keyboardFrameValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
         CGRect keyboardFrame = [keyboardFrameValue CGRectValue];
         [UIView animateWithDuration:1.0f animations:^{
             [self.scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
                 make.top.equalTo(self).offset(64-keyboardFrame.size.height);
             }];
             [self.scrollView.superview layoutIfNeeded];
         }];
         
         }
     }];
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillHideNotification object:nil] subscribeNext:^(id x) {
        @strongify(self)
        if(self.diffText.isFirstResponder || self.contextText.isFirstResponder) {
        [UIView animateWithDuration:1.0f animations:^{
            [self.scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self).offset(64);
            }];
            [self.scrollView.superview layoutIfNeeded];
        }];
        }
    }];
}

- (void)dealloc
{
//    [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:UIKeyboardWillShowNotification];
//    [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:UIKeyboardWillHideNotification];
}

- (BOOL)textViewShouldEndEditing:(YYTextView *)textView
{
//    [self.nameText resignFirstResponder];
//    [self.timeText resignFirstResponder];
//    [self.mainText resignFirstResponder];
//    [self.contextText resignFirstResponder];
//    [self.diffText resignFirstResponder];
    return YES;
}

- (void)textViewDidEndEditing:(YYTextView *)textView
{
//    [self.nameText resignFirstResponder];
//    [self.timeText resignFirstResponder];
//    [self.mainText resignFirstResponder];
//    [self.contextText resignFirstResponder];
//    [self.diffText resignFirstResponder];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self hideKeyboard];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.nameText resignFirstResponder];
    [self.mainText resignFirstResponder];
    return YES;
}
- (void)hideKeyboard
{
    [self.nameText resignFirstResponder];
    [self.mainText resignFirstResponder];
    [self.contextText resignFirstResponder];
    [self.diffText resignFirstResponder];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.nameText resignFirstResponder];
    [self.mainText resignFirstResponder];
    [self.contextText resignFirstResponder];
    [self.diffText resignFirstResponder];
}
@end
