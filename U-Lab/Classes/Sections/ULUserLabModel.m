//
//  ULUserLabModel.m
//  U-Lab
//
//  Created by 周维康 on 2017/6/6.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULUserLabModel.h"

@implementation ULUserLabModel

+ (NSDictionary <NSString *, id> *)modelCustomPropertyMapper
{
    return @{
             NSStringFromSelector(@selector(labId)) : @"id",
             NSStringFromSelector(@selector(labName)) : @"name",
             NSStringFromSelector(@selector(labMain)) : @"mainPoint",
             NSStringFromSelector(@selector(labIntro)) : @"introduction",
             NSStringFromSelector(@selector(labDifficult)) : @"difficult",
             NSStringFromSelector(@selector(labTime)) : @"startTime",
             NSStringFromSelector(@selector(projectId)) : @"projectId",
             NSStringFromSelector(@selector(userId)) : @"userId"
             };
}

@end
