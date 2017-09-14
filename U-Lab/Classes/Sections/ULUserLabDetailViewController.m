//
//  ULUserLabDetailViewController.m
//  ULab
//
//  Created by 周维康 on 2017/6/12.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULUserLabDetailViewController.h"
#import "ULUserLabCreatViewController.h"
#import "ULUserLabDetailView.h"
#import "ULUserLabModel.h"
@interface ULUserLabDetailViewController ()

@property (nonatomic, strong) ULUserLabModel *model;  /**< model */
@property (nonatomic, strong) ULUserLabDetailView *detailView;  /**< detail */
@end

@implementation ULUserLabDetailViewController

- (instancetype)initWithLabModel:(ULUserLabModel *)model
{
    self.model = model;
    if (self = [super init])
    {
     
    }
    return self;
}


- (void)ul_addSubviews
{
    [self.view addSubview:self.detailView];
    [self.view updateConstraintsIfNeeded];
    [self.view setNeedsUpdateConstraints];
}


- (void)ul_layoutNavigation
{
    self.title = @"查看实验";
    UIButton *editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    editButton.frame = CGRectMake(0, 0, 40, 17);
    [editButton setTitle:@"编辑" forState:UIControlStateNormal];
    [editButton setTitleColor:kCommonWhiteColor forState:UIControlStateNormal];
    [[editButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        ULUserLabCreatViewController *creatVC = [[ULUserLabCreatViewController alloc] initWithLabModel:self.model projectId:nil];
        creatVC.isEdit = YES;
        [creatVC.popSubject subscribeNext:^(id x) {
            self.model = x;
            [self updateViews];
        }];
        [self.navigationController pushViewController:creatVC animated:YES];
    }];
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:editButton];
    self.navigationItem.rightBarButtonItem = buttonItem;
}

- (void)updateViews{
    [self.detailView uploadWithModel:self.model];
}

- (void)ul_bindViewModel
{
    
}
- (void)updateViewConstraints
{
    [self.detailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [super updateViewConstraints];
}

- (ULUserLabDetailView *)detailView
{
    if (!_detailView)
    {
        _detailView = [[ULUserLabDetailView alloc] initWithLabModel:self.model];
    }
    return _detailView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
