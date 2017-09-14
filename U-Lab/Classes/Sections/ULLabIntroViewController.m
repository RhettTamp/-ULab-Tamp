//
//  ULLabIntroViewController.m
//  U-Lab
//
//  Created by 周维康 on 2017/6/7.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULLabIntroViewController.h"
#import "ULLabIntroView.h"
#import "ULChangeLabInfoViewController.h"

@interface ULLabIntroViewController ()
@property (nonatomic, strong) ULLabIntroView *introView;  /**< 简介仕途 */

@end

@implementation ULLabIntroViewController

- (instancetype)initWithModel:(ULLabModel *)model
{
    self = [super init];
    if (self) {
        self.introView = [[ULLabIntroView alloc] initWithModel:model];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    ULBaseRequest *request = [[ULBaseRequest alloc]init];
    [request getDataWithParameter:nil session:YES progress:nil success:^(ULBaseRequest *request, NSDictionary *responseObject) {
        [[ULUserMgr sharedMgr] yy_modelSetWithJSON:responseObject[@"data"]];
        [ULUserMgr sharedMgr].research = nil;
        if (self.introView) {
            [self.introView reloadData];
        }
        
    } failure:^(ULBaseRequest *request, NSError *error) {
        
    } withPath:@"ulab_user/users/info"];
    [super viewWillAppear:animated];
}

- (void)updateViewConstraints
{
    [self.introView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [super updateViewConstraints];
}

- (void)ul_addSubviews
{
    if (!self.introView) {
        self.introView = [[ULLabIntroView alloc] init];
    }
    
    [self.view addSubview:self.introView];
    [self.view setNeedsUpdateConstraints];
    [self.view updateConstraintsIfNeeded];
}
- (void)ul_layoutNavigation
{
    self.title = @"实验室信息";
    if (!self.introView.model&&[[ULUserMgr sharedMgr].role integerValue] == 2) {
        UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(change)];
        self.navigationItem.rightBarButtonItem = item;
    }
    
}

- (void)change{
    ULChangeLabInfoViewController *vc = [[ULChangeLabInfoViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
