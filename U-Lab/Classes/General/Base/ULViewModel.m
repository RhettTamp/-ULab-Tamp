//
//  ULViewModel.m
//  U-Lab
//
//  Created by 周维康 on 17/5/18.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULViewModel.h"


@implementation ULViewModel

@synthesize request = _request;

//请求管理
- (ULBaseRequest *)request
{
    if (!_request)
    {
        _request = [[ULBaseRequest alloc] init];
        _request.isJson = NO;
    }
    return _request;
}

//通过alloc调用绑定数据
+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    ULViewModel *viewModel = [super allocWithZone:zone];
    if (viewModel)
    {
        [viewModel ul_initialize];
    }
    return viewModel;
}

//用M初始化VM
- (instancetype)initWithModel:(id)model
{
    if (self = [super init])
    {
        
    }
    return self;
}

//做一些数据绑定之类的事
- (void)ul_initialize
{
    
}
@end
