//
//  ULViewModelProtocol.h
//  U-Lab
//
//  Created by 周维康 on 17/5/18.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, ULRefreshDataStatus)
{
    ULHeaderRefresh_HasMoreData = 1,
    ULHeaderRefresh_HasNoMoreData,
    ULFooterRefresh_HasMoreData,
    ULFooterRefresh_HasNoMoreData,
    ULRefreshError,
    ULRefreshUI,
};

@protocol ULViewModelProtocol <NSObject>

@optional

- (instancetype)initWithModel:(id)model;

@property (nonatomic, strong)ULBaseRequest *request;

- (void)ul_initialize;

@end

