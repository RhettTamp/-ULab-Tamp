//
//  ULBaseViewController.m
//  U-Lab
//
//  Created by 周维康 on 17/5/13.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULViewController.h"

@interface ULViewController ()

@end

@implementation ULViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
//    DDLogInfo(@"current Controller:%@", [self class]);
    self.view.backgroundColor = [UIColor whiteColor];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    ULViewController *viewController = [super allocWithZone:zone];
    @weakify(viewController)
    [[viewController rac_signalForSelector:@selector(viewDidLoad)] subscribeNext:^(id x) {
        @strongify(viewController)
        [viewController ul_addSubviews];
        [viewController ul_bindViewModel];
    }];
    [[viewController rac_signalForSelector:@selector(viewWillAppear:)] subscribeNext:^(id x) {
        @strongify(viewController)
        [viewController ul_layoutNavigation];
        [viewController ul_getNewData];
    }];
    return viewController;
}

- (instancetype)initWithViewModel:(id<ULViewControllerProtocol>)viewModel
{
    if (self = [super init])
    {
        
    }
    return self;
}

#pragma mark - RAC
/**
 *  添加控件
 */
- (void)ul_addSubviews
{
    
}

/**
 *  绑定
 */
- (void)ul_bindViewModel
{
    
}

/**
 *  绑定navigation
 */
- (void)ul_layoutNavigation
{
    
}

/**
 *  初次获取数据
 */
- (void)ul_getNewData
{
    
}

@end
