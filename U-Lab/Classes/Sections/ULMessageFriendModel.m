//
//  ULMessageFriendModel.m
//  U-Lab
//
//  Created by 周维康 on 2017/6/8.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULMessageFriendModel.h"

@implementation ULMessageFriendModel

+ (NSDictionary<NSString *, id> *)modelCustomPropertyMapper
{
    return @{
             NSStringFromSelector(@selector(userName)) : @"username",
             NSStringFromSelector(@selector(avatar)) : @"avatar"
             };
}
@end
