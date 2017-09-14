//
//  ULUserOrderModel.m
//  U-Lab
//
//  Created by 周维康 on 2017/6/2.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULUserOrderModel.h"

@implementation ULUserOrderModel

+ (NSDictionary <NSString *, id> *)modelCustomPropertyMapper
{
    return @{
             NSStringFromSelector(@selector(orderId)) : @"id",
             NSStringFromSelector(@selector(senderId)) : @"senderId",
             NSStringFromSelector(@selector(senderName)) : @"senderName",
             NSStringFromSelector(@selector(receiverId)) : @"receiverId",
             NSStringFromSelector(@selector(receiverName)) : @"receiverName",
             NSStringFromSelector(@selector(itemId)) : @"itemId",
             NSStringFromSelector(@selector(orderTime)) : @"itme",
             NSStringFromSelector(@selector(orderQuantity)) : @"quantity",
             NSStringFromSelector(@selector(senderPhone)) : @"senderTelephone",
             NSStringFromSelector(@selector(labId)) : @"laboratoryId",
             NSStringFromSelector(@selector(orderStatus)) : @"status",
             NSStringFromSelector(@selector(orderAmount)) : @"amount"
             
             };
}

@end
