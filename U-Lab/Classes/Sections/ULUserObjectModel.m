//
//  ULUserObjectModel.m
//  U-Lab
//
//  Created by 周维康 on 2017/5/31.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULUserObjectModel.h"

@implementation ULUserObjectModel

+ (NSDictionary <NSString *, id> *)modelCustomPropertyMapper
{
    return @{
             NSStringFromSelector(@selector(objectId)) : @"id",
             NSStringFromSelector(@selector(objectName)) : @"name",
             NSStringFromSelector(@selector(objectType)) : @"type",
             NSStringFromSelector(@selector(objectQuantity)) : @"quantity",
             NSStringFromSelector(@selector(objectLocation)) : @"location",
             NSStringFromSelector(@selector(userName)) : @"userTrueName",
             NSStringFromSelector(@selector(userId)) : @"userId",
             NSStringFromSelector(@selector(ownerId)) : @"ownerId",
             NSStringFromSelector(@selector(ownerName)) : @"ownerTrueName",
             NSStringFromSelector(@selector(labId)) : @"laboratoryId",
             NSStringFromSelector(@selector(contactNumber)) : @"contactNumber",
             NSStringFromSelector(@selector(price)) : @"unitPrice",
             NSStringFromSelector(@selector(measureUnit)) : @"unitMeasurement",
             NSStringFromSelector(@selector(factory)) : @"factory",
             NSStringFromSelector(@selector(specification)) : @"specification",
             NSStringFromSelector(@selector(dealer)) : @"dealer",
             NSStringFromSelector(@selector(objectDescription)) : @"description",
             NSStringFromSelector(@selector(imageURL)) : @"image",
             NSStringFromSelector(@selector(isUsing)) : @"isUsing",
             NSStringFromSelector(@selector(isShared)) : @"isShared",
             NSStringFromSelector(@selector(servicePhone)) : @"afterServicePhone",
             NSStringFromSelector(@selector(status)) : @"status"
             };
}
@end
