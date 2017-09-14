//
//  ULUserProjectModel.m
//  U-Lab
//
//  Created by 周维康 on 2017/6/6.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULUserProjectModel.h"

@implementation ULUserProjectModel

+ (NSDictionary <NSString *, id> *)modelCustomPropertyMapper
{
    return @{
             NSStringFromSelector(@selector(projectName)) : @"name",
             NSStringFromSelector(@selector(projectIntro)) : @"introduction",
             NSStringFromSelector(@selector(userId)) : @"userId",
             NSStringFromSelector(@selector(projectId)) : @"id",
             NSStringFromSelector(@selector(time)) : @"createTime"
             };
}

@end
