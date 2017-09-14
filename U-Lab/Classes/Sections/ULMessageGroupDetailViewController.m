//
//  ULMessageGroupDetailViewController.m
//  ULab
//
//  Created by 周维康 on 2017/6/11.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULMessageGroupDetailViewController.h"
#import "ULMessageGroupDetailView.h"
@interface ULMessageGroupDetailViewController ()

@property (nonatomic, strong) ULMessageGroupDetailView *detailView;  /**< detail */
@property (nonatomic, strong) JMSGGroup *group;  /**< group */
@end

@implementation ULMessageGroupDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (instancetype)initWithGroup:(JMSGGroup *)group
{
    self.group = group;
    if (self = [super init])
    {
        
    }
    return self;
}

- (void)ul_bindViewModel
{
    
}

- (void)ul_layoutNavigation
{
    self.title = @"群信息";
}

- (void)ul_addSubviews
{
    [self.view addSubview:self.detailView];
    [self.view setNeedsUpdateConstraints];
    [self.view updateConstraintsIfNeeded];
}

- (void)updateViewConstraints
{
    [self.detailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [super updateViewConstraints];
}

- (ULMessageGroupDetailView *)detailView
{
    if (!_detailView)
    {
        _detailView = [[ULMessageGroupDetailView alloc] initWithGroup:self.group];
    }
    return _detailView;
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
