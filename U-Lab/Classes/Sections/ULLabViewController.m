//
//  ULLabViewController.m
//  U-Lab
//
//  Created by 周维康 on 17/5/18.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULLabViewController.h"
#import "ULLabView.h"
#import "ULLabSearchView.h"
#import "ULLabSearchResultViewController.h"
#import "ULLabIntroViewController.h"
#import "ULLabMemberViewController.h"
#import "ULLabObjectViewController.h"
#import "ULLabFriendViewController.h"
#import "ULLabBusinessViewController.h"
#import "ULLabViewModel.h"
@interface ULLabViewController ()

@property (nonatomic, strong) ULLabView *mainView;  /**< 主视图 */
@property (nonatomic, strong) ULLabSearchView *searchView;  /**< 搜索试图 */
@property (nonatomic, strong) ULLabViewModel *labVM;  /**< <#comment#> */

@end

@implementation ULLabViewController
{
    NSArray *_controllerArray;
//    NSInteger type;
    BOOL _isHaveNewApply;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _isHaveNewApply = NO;
//        self.isShowSearchView = NO;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    ULBaseRequest *request = [[ULBaseRequest alloc]init];
    [request getDataWithParameter:nil session:YES progress:nil success:^(ULBaseRequest *request, NSDictionary *responseObject) {
        [[ULUserMgr sharedMgr] yy_modelSetWithJSON:responseObject[@"data"]];
        
    } failure:^(ULBaseRequest *request, NSError *error) {
        
    } withPath:@"ulab_user/users/info"];
    if ([ULUserMgr sharedMgr].laboratoryId&& self.type == 0)
    {
        self.searchView.hidden = YES;
        self.mainView.hidden = NO;
        [self.labVM.labCommand execute:nil];
        [self.mainView updateLabView];
//        type = 1;
    } else {
        self.searchView.hidden = NO;
        self.mainView.hidden = YES;
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [request getDataWithParameter:@{@"labId":@([ULUserMgr sharedMgr].laboratoryId)} session:YES progress:nil success:^(ULBaseRequest *request, NSDictionary *responseObject) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.mainView.isShowNewsView = NO;
            });
            if ([responseObject[@"data"] class] != [NSNull class])
            {
                for (NSDictionary *labDic in responseObject[@"data"])
                {
                    if ([labDic[@"status"] integerValue] != 0&&[labDic[@"status"] integerValue] != 1) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            self.mainView.isShowNewsView = YES;
                        });
                    }
                }
            }
        } failure:^(ULBaseRequest *request, NSError *error) {
        } withPath:@"ulab_lab/lab/friendlyApplies"];
    });
}

- (void)ul_bindViewModel
{
    [self.searchView.searchSubject subscribeNext:^(id x) {
        ULLabSearchResultViewController *resultVC = [[ULLabSearchResultViewController alloc] initWithKey:self.searchView.viewModel.searchKey labArray:x andType:self.type];
        [self.navigationController pushViewController:resultVC animated:YES];
    }];
    [self.mainView.nextControllerSubject subscribeNext:^(id x) {
        Class vcClass = NSClassFromString(_controllerArray[[x integerValue]]);
        UIViewController *controller = [[vcClass alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    }];
}
- (void)ul_addSubviews
{
    self.labVM = [[ULLabViewModel alloc] init];
    _controllerArray = @[NSStringFromClass([ULLabIntroViewController class]), NSStringFromClass([ULLabMemberViewController class]), NSStringFromClass([ULLabObjectViewController class]), NSStringFromClass([ULLabFriendViewController class]), NSStringFromClass([ULLabBusinessViewController class])];
    [self.view addSubview:self.searchView];
    [self.view addSubview:self.mainView];
    [self.view updateConstraintsIfNeeded];
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [super updateViewConstraints];
}

- (ULLabView *)mainView
{
    if (!_mainView)
    {
        _mainView = [[ULLabView alloc] init];
    }
    return _mainView;
}

- (ULLabSearchView *)searchView
{
    if (!_searchView)
    {
        _searchView = [[ULLabSearchView alloc] init];

    }
    return _searchView;
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
