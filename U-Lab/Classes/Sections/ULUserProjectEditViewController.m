//
//  ULUserProjectEditViewController.m
//  ULab
//
//  Created by 周维康 on 2017/6/12.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULUserProjectEditViewController.h"
#import "ULUserLabEditView.h"
#import "ULUserLabCreatViewController.h"
#import "ULUserLabDetailViewController.h"

@interface ULUserProjectEditViewController ()

@property (nonatomic, strong) NSMutableArray *labArray;  /**< 实验室数组 */
@property (nonatomic, strong) ULUserLabEditView *editView;  /**< edit */
@property (nonatomic, strong) NSNumber *projectId;  /**< <#comment#> */
@end

@implementation ULUserProjectEditViewController

- (instancetype)initWithLabArray:(NSArray *)labArray andProjectId:(NSNumber *)projectId
{
    self.labArray = [labArray mutableCopy];
    self.projectId = projectId;
    if (self = [super init])
    {
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    
}
- (void)ul_addSubviews
{
    [self.view addSubview:self.editView];
    [self.view updateConstraintsIfNeeded];
    [self.view setNeedsUpdateConstraints];
}


- (void)ul_layoutNavigation
{
    self.title = @"我的实验";
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addButton.frame = CGRectMake(0, 0, 18, 17);
    @weakify(self)
    [[addButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        ULUserLabCreatViewController *creatVC = [[ULUserLabCreatViewController alloc] initWithLabModel:nil projectId:self.projectId];
        [creatVC.popSubject subscribeNext:^(id x) {
            [self.labArray addObject:x];
            [self.editView updateViewWithArray:self.labArray];
            
        }];
        [self.navigationController pushViewController:creatVC animated:YES];
    }];
    [addButton setBackgroundImage:[UIImage imageNamed:@"home_user_add"] forState:UIControlStateNormal];
    //    [addButton setTitle:@"新建" forState:UIControlStateNormal];
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:addButton];
    self.navigationItem.rightBarButtonItem = buttonItem;
}

- (void)ul_bindViewModel
{
    [self.editView.cellSelectSubject subscribeNext:^(id x) {
        ULUserLabDetailViewController *detailVC = [[ULUserLabDetailViewController alloc] initWithLabModel:x];
        [self.navigationController pushViewController:detailVC animated:YES];
    }];
//    [self.editView.addSubject subscribeNext:^(id x) {
//        ULUserLabCreatViewController *creatVC = [[ULUserLabCreatViewController alloc] init];
//        @weakify(self)
//        [creatVC.popSubject subscribeNext:^(id x) {
//            @strongify(self)
//            [self.creatView.finishSubject sendNext:x];
//        }];
//        [self.navigationController pushViewController:creatVC animated:YES];
//    }];
}
- (void)updateViewConstraints
{
    [self.editView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [super updateViewConstraints];
}

- (ULUserLabEditView *)editView
{
    if (!_editView)
    {
        _editView = [[ULUserLabEditView alloc] initWithLabArray:_labArray];
    }
    return _editView;
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
