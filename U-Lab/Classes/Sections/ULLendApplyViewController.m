//
//  ULLendApplyViewController.m
//  U-Lab
//
//  Created by 周维康 on 17/5/28.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULLendApplyViewController.h"
#import "ULLendApplyView.h"
#import "ULUserOrderModel.h"
@interface ULLendApplyViewController ()
@property (nonatomic, strong) ULLendApplyView *applyView;  /**< 借用申请 */
@property (nonatomic, strong) ULUserOrderModel *model;  /**< <#comment#> */
@property (nonatomic, assign) NSInteger type;

@end

@implementation ULLendApplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (instancetype)initWithModel:(ULUserOrderModel *)model andType:(NSNumber *)type
{
    self.model = model;
    self.type = [type integerValue];
    self = [super init];
    return self;
}
- (void)ul_addSubviews
{
    self.view.backgroundColor = kBackgroundColor;
    [self.view addSubview:self.applyView];
    [self.view setNeedsUpdateConstraints];
    [self.view updateConstraintsIfNeeded];
}

- (void)ul_layoutNavigation
{
    self.title = @"借用申请";
}
- (void)updateViewConstraints
{
    [self.applyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [super updateViewConstraints];
}

- (ULLendApplyView *)applyView
{
    if (!_applyView)
    {
        _applyView = [[ULLendApplyView alloc] initWithModel:self.model andType:@(self.type)];
    }
    return _applyView;
}


@end
