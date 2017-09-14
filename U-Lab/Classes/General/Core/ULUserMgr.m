//
//  ULUserMgr.m
//  U-Lab
//
//  Created by 周维康 on 17/5/17.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULUserMgr.h"

static ULUserMgr *user = nil;
@interface ULUserMgr()<NSCoding>

@end

@implementation ULUserMgr

+ (ULUserMgr *)sharedMgr
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
//        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"ulab_user"];
        NSData *data = [ULKeychainTool load:@"ulab_user"];
        if (data) {
            user = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        }else{
            user = [[ULUserMgr alloc] init];
            user.friendArray = [[NSMutableArray alloc] init];
            user.avaterImage = [[UIImage alloc] init];
            user.addFriendArray = [[NSMutableArray alloc] init];
            user.groupArray = [NSMutableArray array];
            user.searchArray = [NSArray array];
            user.firendLabArray = [NSMutableArray array];
        }
    });
    [ULUserMgr saveMgr];
    return user;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        self.userPhone = [aDecoder decodeObjectForKey:@"user_phone"];
        self.userEmail = [aDecoder decodeObjectForKey:@"user_email"];
        self.userName = [aDecoder decodeObjectForKey:@"user_name"];
        self.laboratoryId = [[aDecoder decodeObjectForKey:@"user_laboratoryId"] integerValue];
        self.laboratoryName = [aDecoder decodeObjectForKey:@"user_laboratoryName"];
        self.school = [aDecoder decodeObjectForKey:@"user_school"];
        self.research = [aDecoder decodeObjectForKey:@"user_research"];
//        self.educational = [aDecoder decodeObjectForKey:@"user_educational"];
        self.labResearch = [aDecoder decodeObjectForKey:@"user_labResearch"];
        self.labIntro = [aDecoder decodeObjectForKey:@"user_labIntro"];
        self.labLocation = [aDecoder decodeObjectForKey:@"user_labLocation"];
        self.labSetTime = [aDecoder decodeObjectForKey:@"user_labSetTime"];
        self.labImage = [aDecoder decodeObjectForKey:@"user_labImage"];
        self.labPi = [[aDecoder decodeObjectForKey:@"user_labPi"] integerValue];
        if ([aDecoder decodeObjectForKey:@"user_friendList"])
        self.friendArray = [aDecoder decodeObjectForKey:@"user_friendList"];
        if ([aDecoder decodeObjectForKey:@"user_addFriendList"])
        self.addFriendArray = [aDecoder decodeObjectForKey:@"user_addFriendList"];
        self.groupArray = [aDecoder decodeObjectForKey:@"user_groupList"];
        self.sex = [aDecoder decodeObjectForKey:@"user_sex"];
        self.role = [aDecoder decodeObjectForKey:@"user_role"];
        self.userId = [aDecoder decodeObjectForKey:@"user_id"];
        self.avaterImage = [aDecoder decodeObjectForKey:@"user_avator"];
        self.labPiName = [aDecoder decodeObjectForKey:@"user_labPiName"];
        self.searchArray = [aDecoder decodeObjectForKey:@"searchArray"];
        self.labMoney = [aDecoder decodeObjectForKey:@"labMoney"];
        self.regType = [aDecoder decodeIntegerForKey:@"regType"];
        self.score = [aDecoder decodeIntegerForKey:@"labScore"];
        if ([aDecoder decodeObjectForKey:@"user_firendLabArray"]) {
                    self.firendLabArray = [aDecoder decodeObjectForKey:@"user_firendLabArray"];
        }
    }
    return self;
}

+ (NSDictionary<NSString *, id> *)modelCustomPropertyMapper
{
    return @{
             NSStringFromSelector(@selector(userName)) : @"username",
             NSStringFromSelector(@selector(userEmail)) : @"email",
             NSStringFromSelector(@selector(userPhone)) : @"telephone",
             NSStringFromSelector(@selector(laboratoryId)) : @"laboratoryId",
             NSStringFromSelector(@selector(avaterImageUrl)):@"headImage",
             NSStringFromSelector(@selector(school)) : @"educationalHistory",
             NSStringFromSelector(@selector(labIntro)) : @"introduction",
             NSStringFromSelector(@selector(labLocation)) : @"location",
             NSStringFromSelector(@selector(labSetTime)) : @"setupTime",
             NSStringFromSelector(@selector(labImage)) : @"image",
             NSStringFromSelector(@selector(labPi)) : @"piId",
             NSStringFromSelector(@selector(userId)) : @"id",
             NSStringFromSelector(@selector(labPiName)) : @"piName"
             };
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.userPhone forKey:@"user_phone"];
    [aCoder encodeObject:self.userEmail forKey:@"user_email"];
    [aCoder encodeObject:self.userName forKey:@"user_name"];
    [aCoder encodeObject:self.laboratoryName forKey:@"user_laboratoryName"];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.laboratoryId] forKey:@"user_laboratoryId"];
    [aCoder encodeObject:self.school forKey:@"user_school"];
//    [aCoder encodeObject:self.educational forKey:@"user_educational"];
    [aCoder encodeObject:self.research forKey:@"user_research"];
    [aCoder encodeObject:self.labResearch forKey:@"user_labResearch"];
    [aCoder encodeObject:self.labLocation forKey:@"user_labLocation"];
    [aCoder encodeObject:self.labSetTime forKey:@"user_labSetTime"];
    [aCoder encodeObject:self.labImage forKey:@"user_labImage"];
    [aCoder encodeObject:self.labIntro forKey:@"user_labIntro"];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.labPi] forKey:@"user_labPi"];
    [aCoder encodeObject:self.friendArray forKey:@"user_friendList"];
    [aCoder encodeObject:self.addFriendArray forKey:@"user_addFriendList"];
    [aCoder encodeObject:self.groupArray forKey:@"user_groupList"];
    [aCoder encodeObject:self.sex forKey:@"user_sex"];
    [aCoder encodeObject:self.userId forKey:@"user_id"];
    [aCoder encodeObject:self.role forKey:@"user_role"];
    [aCoder encodeObject:self.avaterImage forKey:@"user_avator"];
    [aCoder encodeObject:self.labPiName forKey:@"user_labPiName"];
    [aCoder encodeObject:self.searchArray forKey:@"searchArray"];
    [aCoder encodeObject:self.labMoney forKey:@"labMoney"];
    [aCoder encodeInteger:self.regType forKey:@"regType"];
    [aCoder encodeInteger:self.score forKey:@"labScore"];
    [aCoder encodeObject:self.firendLabArray forKey:@"user_firendLabArray"];
}

+ (void)saveMgr
{
    NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:user];
//    [[NSUserDefaults standardUserDefaults] setObject:userData forKey:@"ulab_user"];
    [ULKeychainTool save:@"ulab_user" data:userData];
}

- (void)removeMgr
{
    self.userName = nil;
    self.userEmail = nil;
    self.userPhone = nil;
    self.laboratoryId = 0;
    self.laboratoryName = nil;
    self.school = nil;
//    self.educational = nil;
    self.research = nil;
    self.labIntro = nil;
    self.labImage = nil;
    self.labSetTime = nil;
    self.labLocation = nil;
    self.labResearch = nil;
    self.friendArray = nil;
    self.addFriendArray = nil;
    self.labPi = 0;
    self.groupArray = nil;
    self.sex = @0;
    self.role = @0;
    self.userId = @0;
    self.avaterImage = nil;
    self.labPiName = nil;
    self.searchArray = nil;
    self.regType = 0;
    self.score = 0;
    self.firendLabArray = nil;
}

@end
