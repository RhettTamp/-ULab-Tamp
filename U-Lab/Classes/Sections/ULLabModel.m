//
//  ULLabModel.m
//  U-Lab
//
//  Created by 周维康 on 17/5/31.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULLabModel.h"

@interface ULLabModel ()<NSCoding>

@end

@implementation ULLabModel

+ (NSDictionary <NSString *, id> *)modelCustomPropertyMapper
{
    return @{ NSStringFromSelector(@selector(labName)) : @"name",
              NSStringFromSelector(@selector(labID)) : @"id",
              NSStringFromSelector(@selector(labIntroduction)) : @"introduction",
              NSStringFromSelector(@selector(labLocation)) : @"location",
              NSStringFromSelector(@selector(labResearch)) : @"researchDirection",
              NSStringFromSelector(@selector(labSetTime)) : @"setupTime",
              NSStringFromSelector(@selector(labImage)) : @"image",
              NSStringFromSelector(@selector(piId)) : @"piId"
              };
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeInteger:self.labID forKey:@"lab_labID"];
    [aCoder encodeObject:self.labName forKey:@"lab_labName"];
    [aCoder encodeObject:self.labLocation forKey:@"lab_labLocation"];
    [aCoder encodeObject:self.labIntroduction forKey:@"lab_labIntroduction"];
    [aCoder encodeObject:self.labResearch forKey:@"lab_labResearch"];
    [aCoder encodeObject:self.labSetTime forKey:@"lab_labSetTime"];
    [aCoder encodeObject:self.labImage forKey:@"lab_labImage"];
    [aCoder encodeObject:self.piId forKey:@"lab_piId"];
    [aCoder encodeObject:self.piName forKey:@"lab_piName"];
    [aCoder encodeObject:self.labMoney forKey:@"lab_labMoney"];
    [aCoder encodeInteger:self.applyStatus forKey:@"lab_applyStatus"];

}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.labID = [aDecoder decodeIntegerForKey:@"lab_labID"];
        self.labName = [aDecoder decodeObjectForKey:@"lab_labName"];
        self.labLocation = [aDecoder decodeObjectForKey:@"lab_labLocation"];

        self.labIntroduction = [aDecoder decodeObjectForKey:@"lab_labIntroduction"];
        self.labResearch = [aDecoder decodeObjectForKey:@"lab_labResearch"];
        self.labSetTime = [aDecoder decodeObjectForKey:@"lab_labSetTime"];
        self.labImage = [aDecoder decodeObjectForKey:@"lab_labImage"];
        self.piId = [aDecoder decodeObjectForKey:@"lab_piId"];
        self.piName = [aDecoder decodeObjectForKey:@"lab_piName"];
        self.labMoney = [aDecoder decodeObjectForKey:@"lab_labMoney"];
        self.applyStatus = [aDecoder decodeIntegerForKey:@"lab_applyStatus"];
        
    }
    return self;
}

@end
