//
//  ULLabBusinessViewController.m
//  U-Lab
//
//  Created by 周维康 on 2017/6/8.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULLabBusinessViewController.h"
#import "ULLabBusinessDetailViewController.h"
#import "ULLabBusinessView.h"
@interface ULLabBusinessViewController ()

@property (nonatomic, strong) ULLabBusinessView *businessView;  /**< 财务页面 */
@end

@implementation ULLabBusinessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)ul_addSubviews
{
    [self.view addSubview:self.businessView];
    [self.view updateConstraintsIfNeeded];
    [self.view setNeedsUpdateConstraints];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.businessView.pickerView.hidden = YES;
}

- (void)ul_bindViewModel
{
    [self.businessView.nextSubject subscribeNext:^(id x) {
            ULLabBusinessDetailViewController *detailVC = [[ULLabBusinessDetailViewController alloc] initWithType:x[@"type"] andDate:x[@"date"]];
            [self.navigationController pushViewController:detailVC animated:YES];
        
    }];
}
- (void)ul_layoutNavigation
{
    self.title = @"财务管理";
    if ([[ULUserMgr sharedMgr].role integerValue]== 2) {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 17)];
        [button setTitle:@"编辑" forState:UIControlStateNormal];
        UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:button];
        [button addTarget:self action:@selector(saveButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = item;
    }
}

- (void)saveButtonClicked:(UIButton *)button{
    button.selected = !button.selected;
    if (button.selected) {
        [button setTitle:@"保存" forState:UIControlStateNormal];
        self.businessView.introLabel.enabled = YES;
        return;
    }else{
        [button setTitle:@"编辑" forState:UIControlStateNormal];
        button.selected = NO;
    }
    ULBaseRequest *request = [[ULBaseRequest alloc]init];
    request.isJson = NO;
    [request postDataWithParameter:@{@"labId":@([ULUserMgr sharedMgr].laboratoryId),@"money":self.businessView.introLabel.text} session:YES progress:nil success:^(ULBaseRequest *request, NSDictionary *responseObject) {
        [ULProgressHUD showWithMsg:@"保存成功"];
        [[NSUserDefaults standardUserDefaults] setObject:self.businessView.introLabel.text forKey:@"labMoney"];
        [ULUserMgr sharedMgr].labMoney = @([self.businessView.introLabel.text integerValue]);
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(ULBaseRequest *request, NSError *error) {
        [ULProgressHUD showWithMsg:@"请求失败"];
    } withPath:@"ulab_lab/lab/money"];
}

- (void)updateViewConstraints
{
    [self.businessView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [super updateViewConstraints];
}

- (ULLabBusinessView *)businessView
{
    if (!_businessView)
    {
        _businessView = [[ULLabBusinessView alloc] init];
    }
    return _businessView;
}


@end
