//
//  ULLabMemberModel.m
//  U-Lab
//
//  Created by 周维康 on 17/5/31.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULLabMemberModel.h"

@implementation ULLabMemberModel

+ (NSDictionary<NSString *, id> *)modelCustomPropertyMapper
{
    return @{
             NSStringFromSelector(@selector(memberId)) : @"id",
             NSStringFromSelector(@selector(memberName)) : @"username",
             NSStringFromSelector(@selector(memberEmail)) : @"email",
             NSStringFromSelector(@selector(memberPhone)) : @"telephone",
             NSStringFromSelector(@selector(labId)) : @"laboratoryId",
             NSStringFromSelector(@selector(labName)) : @"laboratoryName",
             NSStringFromSelector(@selector(school)) : @"educationalHistory",
             NSStringFromSelector(@selector(research)) : @"researchDirection",
             NSStringFromSelector(@selector(educational)) : @"educationalHistory",
             NSStringFromSelector(@selector(menberStatus)):@"status"
             };
}

@end
