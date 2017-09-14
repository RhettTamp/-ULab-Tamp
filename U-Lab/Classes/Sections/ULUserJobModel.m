//
//  ULUserJobModel.m
//  U-Lab
//
//  Created by 周维康 on 2017/6/7.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULUserJobModel.h"

@implementation ULUserJobModel

+ (NSDictionary <NSString *, id> *)modelCustomPropertyMapper
{
    return @{
             NSStringFromSelector(@selector(jobId)) : @"id",
             NSStringFromSelector(@selector(jobTitle)) : @"title",
             NSStringFromSelector(@selector(jobTime)) : @"time",
             NSStringFromSelector(@selector(jobContent)) : @"content",
             NSStringFromSelector(@selector(userId)) : @"userId",
             NSStringFromSelector(@selector(username)):@"username"
             };
}

@end
