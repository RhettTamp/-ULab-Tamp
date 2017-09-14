//
//  ULLabInfoChangeView.m
//  ULab
//
//  Created by 谭培 on 2017/7/29.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULLabInfoChangeView.h"
#import "ULLabViewModel.h"

@interface ULLabInfoChangeView () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *saveButton;
@property (nonatomic, strong) ULLabViewModel *viewModel;
@property (nonatomic, strong) UITextField *siteText;

@end

@implementation ULLabInfoChangeView

{
    NSArray *_nameArray;
    NSArray *_tintArray;
    NSMutableArray *_contentArray;
}

- (void)ul_setupViews{
    [self registerNotification];
    self.backgroundColor = kBackgroundColor;
    self.viewModel = [[ULLabViewModel alloc]init];
    _nameArray = @[@"实验室名称",@"研究方向",@"实验室简介",@"地址"];
    _tintArray = @[@"请填写团队名称",@"请填写研究方向",@"请填写实验室简介",@"请填写地址"];
    ULUserMgr *user = [ULUserMgr sharedMgr];
    _contentArray = [@[user.laboratoryName?:@"",user.labResearch?:@"",user.labIntro?:@"",user.labLocation?:@""] mutableCopy];
    [self addSubview:self.tableView];
    [self addSubview:self.saveButton];
    [self updateConstraintsIfNeeded];
    [self setNeedsUpdateConstraints];
}

- (void)ul_bindViewModel{
    [self.viewModel.changeSubject subscribeNext:^(id x) {
        [self.subject sendNext:nil];
    }];
}

- (void)updateConstraints{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(88*4);
    }];
    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.height.mas_equalTo(40);
        make.left.mas_offset(60);
        make.right.mas_offset(-60);
        make.bottom.mas_offset(-80);
    }];
    [super updateConstraints];
}

- (UIButton *)saveButton{
    if (!_saveButton) {
        _saveButton = [[UIButton alloc]init];
        _saveButton.backgroundColor = KButtonBlueColor;
        _saveButton.layer.cornerRadius = 4;
        [_saveButton setTintColor:[UIColor whiteColor]];
        [_saveButton setTitle:@"保存" forState:UIControlStateNormal];
        [[_saveButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            [self.viewModel.changeCommand execute:@{@"id":@([ULUserMgr sharedMgr].laboratoryId),@"name":_contentArray[0],@"researchDirection":_contentArray[1],@"introduction":_contentArray[2],@"location":_contentArray[3]}];
        }];
    }
    return _saveButton;
}

- (RACSubject *)subject{
    if (!_subject) {
        _subject = [RACSubject subject];
    }
    return _subject;
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
        _tableView.scrollEnabled = NO;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ULLabChangeInfoTableViewCellIdentifier"];
    }
    return _tableView;
}

//- (UIScrollView *)scrollView
//{
//    if (!_scrollView)
//    {
//        _scrollView = [[UIScrollView alloc] init];
//        _scrollView.contentSize = CGSizeMake(screenWidth, (_addArray.count+_friendArray.count)*88+screenHeight-132);
//        _scrollView.showsHorizontalScrollIndicator = NO;
//        _scrollView.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0);
//    }
//    return _scrollView;
//}
//

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _nameArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ULLabChangeInfoTableViewCellIdentifier"];
    for (UIView *view in cell.subviews) {
        [view removeFromSuperview];
    }
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.textColor = KTextGrayColor;
    nameLabel.font = kFont(14);
    nameLabel.text = _nameArray[indexPath.row];
    [cell addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(15);
        make.top.mas_offset(20);
    }];
    UIView *whiteView = [UIView new];
    whiteView.backgroundColor = [UIColor whiteColor];
    [cell addSubview:whiteView];
    [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(cell);
        make.top.mas_offset(44);
    }];
    UITextField *contentText = [[UITextField alloc]init];
    contentText.placeholder = _tintArray[indexPath.row];
    contentText.textColor = kTextBlackColor;
    contentText.text = _contentArray[indexPath.row];
    if (indexPath.row == 3) {
        self.siteText = contentText;
    }
    if (indexPath.row == 0) {
        contentText.enabled = NO;
    }
    [[contentText rac_signalForControlEvents:UIControlEventAllEditingEvents] subscribeNext:^(id x) {
        [_contentArray replaceObjectAtIndex:indexPath.row withObject:contentText.text];
    }];
    [whiteView addSubview:contentText];
    [contentText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(15);
        make.centerY.equalTo(whiteView);
        make.right.equalTo(whiteView);
    }];
    cell.backgroundColor = kBackgroundColor;
    cell.selectionStyle = UITableViewCellEditingStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}


- (void)registerNotification
{
    @weakify(self)
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillShowNotification object:nil]
     subscribeNext:^(NSNotification *notification) {
         @strongify(self)
         
         if([self.siteText isFirstResponder]){
             NSDictionary *info = [notification userInfo];
             NSValue *keyboardFrameValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
             CGRect keyboardFrame = [keyboardFrameValue CGRectValue];
             [UIView animateWithDuration:1.0f animations:^{
                 [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                     make.top.equalTo(self).offset(120-keyboardFrame.size.height);
                 }];
                 [self.tableView.superview layoutIfNeeded];
             }];
         }
         
         
     }];
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillHideNotification object:nil] subscribeNext:^(id x) {
        @strongify(self)
        [UIView animateWithDuration:1.0f animations:^{
            [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self);
            }];
            [self.tableView.superview layoutIfNeeded];
        }];
    }];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:UIKeyboardWillShowNotification];
    [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:UIKeyboardWillHideNotification];
}


@end
