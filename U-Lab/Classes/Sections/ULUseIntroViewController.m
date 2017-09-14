//
//  ULUseIntroViewController.m
//  ULab
//
//  Created by 周维康 on 2017/6/22.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULUseIntroViewController.h"
#import "ULHelpViewModel.h"

@interface ULUseIntroViewController ()

@property (nonatomic, strong) UIView *whiteView;  /**< 白色背景 */
@property (nonatomic, strong) UILabel *questionLabel;
@property (nonatomic, strong) UILabel *answerLabel;
@property (nonatomic, strong) UILabel *question2Label;
@property (nonatomic, strong) UILabel *answer2Label;
@property (nonatomic, strong) UILabel *question3Label;
@property (nonatomic, strong) UILabel *answer3Label;
@property (nonatomic, strong) UILabel *question4Label;
@property (nonatomic, strong) UILabel *answer4Label;
@property (nonatomic, strong) UILabel *question5Label;
@property (nonatomic, strong) UILabel *answer5Label;

@property (nonatomic, strong) UIImageView *bottomView;  /**< 底部花篮 */
@property (nonatomic, strong) ULHelpViewModel *viewModel;  /**< <#comment#> */
@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation ULUseIntroViewController


- (void)viewDidLoad
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.viewModel = [[ULHelpViewModel alloc] init];
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.viewModel.useCommand execute:nil];
}
- (void)ul_addSubviews
{
    self.view.backgroundColor = kBackgroundBlueColor;
    [self.view addSubview:self.whiteView];
    [self.whiteView addSubview:self.scrollView];
    [self.scrollView addSubview:self.questionLabel];
    [self.scrollView addSubview:self.answerLabel];
    [self.scrollView addSubview:self.question2Label];
    [self.scrollView addSubview:self.answer2Label];
    [self.scrollView addSubview:self.question3Label];
    [self.scrollView addSubview:self.answer3Label];
    [self.scrollView addSubview:self.question4Label];
    [self.scrollView addSubview:self.answer4Label];
    [self.scrollView addSubview:self.question5Label];
    [self.scrollView addSubview:self.answer5Label];
    [self.view addSubview:self.bottomView];
    [self.view updateConstraintsIfNeeded];
    [self.view setNeedsUpdateConstraints];
}

- (void)ul_bindViewModel
{
    [self.viewModel.useCommand.executionSignals.flatten subscribeNext:^(id x) {
        if (x[@"success"]) {
            self.questionLabel.text = x[@"data"][0][@"question"];
            self.answerLabel.text = x[@"data"][0][@"answer"];
            self.question2Label.text = x[@"data"][1][@"question"];
            self.answer2Label.text = x[@"data"][1][@"answer"];
            self.question3Label.text = x[@"data"][2][@"question"];
            self.answer3Label.text = x[@"data"][2][@"answer"];
            self.question4Label.text = x[@"data"][3][@"question"];
            self.answer4Label.text = x[@"data"][3][@"answer"];
            self.question5Label.text = x[@"data"][4][@"question"];
            self.answer5Label.text = x[@"data"][4][@"answer"];
        }
    }];
}

- (void)ul_layoutNavigation
{
    self.title = @"帮助";
}
- (void)updateViewConstraints
{
    [self.whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.top.equalTo(self.view).offset(110);
        make.bottom.equalTo(self.view).offset(-80);
    }];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.whiteView);
    }];
    [self.questionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.whiteView).offset(12);
        make.right.equalTo(self.whiteView).offset(-12);
        make.top.equalTo(self.scrollView).offset(8);
    }];
    [self.answerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.questionLabel);
        make.right.equalTo(self.questionLabel);
        make.top.equalTo(self.questionLabel.mas_bottom).offset(12);
    }];
    [self.question2Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.questionLabel);
        make.right.equalTo(self.questionLabel);
        make.top.equalTo(self.answerLabel.mas_bottom).offset(18);
    }];
    [self.answer2Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.answerLabel);
        make.right.equalTo(self.questionLabel);
        make.top.equalTo(self.question2Label.mas_bottom).offset(14);
    }];
    [self.question3Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.questionLabel);
        make.right.equalTo(self.questionLabel);
        make.top.equalTo(self.answer2Label.mas_bottom).offset(18);
    }];
    [self.answer3Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.answerLabel);
        make.right.equalTo(self.questionLabel);
        make.top.equalTo(self.question3Label.mas_bottom).offset(14);
    }];
    
    [self.question4Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.questionLabel);
        make.right.equalTo(self.questionLabel);
        make.top.equalTo(self.answer3Label.mas_bottom).offset(18);
    }];
    [self.answer4Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.answerLabel);
        make.right.equalTo(self.questionLabel);
        make.top.equalTo(self.question4Label.mas_bottom).offset(14);
    }];
    [self.question5Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.questionLabel);
        make.right.equalTo(self.questionLabel);
        make.top.equalTo(self.answer4Label.mas_bottom).offset(18);
    }];
    [self.answer5Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.answerLabel);
        make.right.equalTo(self.questionLabel);
        make.top.equalTo(self.question5Label.mas_bottom).offset(14);
    }];

    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(33);
    }];
    
    [super updateViewConstraints];
}

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.contentSize = CGSizeMake(screenWidth-40, 720);
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

- (UIView *)whiteView
{
    if (!_whiteView)
    {
        _whiteView = [[UIView alloc] init];
        _whiteView.backgroundColor = kCommonWhiteColor;
    }
    return _whiteView;
}
- (UILabel *)questionLabel
{
    if (!_questionLabel)
    {
        _questionLabel = [[UILabel alloc] init];
        _questionLabel.font = [UIFont systemFontOfSize:kStandardPx(30) weight:2];
        _questionLabel.textColor = kTextBlackColor;
        _questionLabel.numberOfLines = 0;
    }
    return _questionLabel;
}

- (UILabel *)answerLabel
{
    if (!_answerLabel)
    {
        _answerLabel = [[UILabel alloc] init];
        _answerLabel.font = kFont(kStandardPx(25));
        _answerLabel.textColor = kTextBlackColor;
        _answerLabel.numberOfLines = 0;
    }
    return _answerLabel;
}
- (UILabel *)question2Label
{
    if (!_question2Label)
    {
        _question2Label = [[UILabel alloc] init];
        _question2Label.font = [UIFont systemFontOfSize:kStandardPx(30) weight:2];
        _question2Label.textColor = kTextBlackColor;
        _question2Label.numberOfLines = 0;
    }
    return _question2Label;
}
- (UILabel *)answer2Label
{
    if (!_answer2Label)
    {
        _answer2Label = [[UILabel alloc] init];
        _answer2Label.font = kFont(kStandardPx(25));
        _answer2Label.textColor = KTextGrayColor;
        _answer2Label.numberOfLines = 0;
    }
    return _answer2Label;
}
- (UILabel *)question3Label
{
    if (!_question3Label)
    {
        _question3Label = [[UILabel alloc] init];
        _question3Label.font = [UIFont systemFontOfSize:kStandardPx(30) weight:2];
        _question3Label.textColor = kTextBlackColor;
        _question3Label.numberOfLines = 0;
    }
    return _question3Label;
}
- (UILabel *)answer3Label
{
    if (!_answer3Label)
    {
        _answer3Label = [[UILabel alloc] init];
        _answer3Label.font = kFont(kStandardPx(25));
        _answer3Label.textColor = KTextGrayColor;
        _answer3Label.numberOfLines = 0;
    }
    return _answer3Label;
}

- (UILabel *)question4Label
{
    if (!_question4Label)
    {
        _question4Label = [[UILabel alloc] init];
        _question4Label.font = [UIFont systemFontOfSize:kStandardPx(30) weight:2];
        _question4Label.textColor = kTextBlackColor;
        _question4Label.numberOfLines = 0;
    }
    return _question4Label;
}
- (UILabel *)answer4Label
{
    if (!_answer4Label)
    {
        _answer4Label = [[UILabel alloc] init];
        _answer4Label.font = kFont(kStandardPx(25));
        _answer4Label.textColor = KTextGrayColor;
        _answer4Label.numberOfLines = 0;
    }
    return _answer4Label;
}

- (UILabel *)question5Label
{
    if (!_question5Label)
    {
        _question5Label = [[UILabel alloc] init];
        _question5Label.font = [UIFont systemFontOfSize:kStandardPx(30) weight:2];
        _question5Label.textColor = kTextBlackColor;
        _question5Label.numberOfLines = 0;
    }
    return _question5Label;
}
- (UILabel *)answer5Label
{
    if (!_answer5Label)
    {
        _answer5Label = [[UILabel alloc] init];
        _answer5Label.font = kFont(kStandardPx(25));
        _answer5Label.textColor = KTextGrayColor;
        _answer5Label.numberOfLines = 0;
    }
    return _answer5Label;
}



- (UIImageView *)bottomView
{
    if (!_bottomView)
    {
        _bottomView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"register_bottom"]];
    }
    return _bottomView;
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
