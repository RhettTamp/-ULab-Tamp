//
//  ULCountDownManager.h
//  U-Lab
//
//  Created by 周维康 on 17/5/18.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ULCountdownTask;

NS_ASSUME_NONNULL_BEGIN

@interface ULCountdownManager : NSObject

+ (instancetype)defaultManager;

- (void)scheduledCountDownWithKey:(NSString *)aKey
                     timeInterval:(NSTimeInterval)timeInterval
                     countingDown:(nullable void(^)(NSTimeInterval leftTimeInterval))countingDown
                         finished:(nullable void (^)(__unused NSTimeInterval finalTimeInterval))finished;

- (BOOL)countdownTaskExistWithKey:(NSString *)aKey task:(ULCountdownTask *_Nullable *_Nullable)task;
@end

NS_ASSUME_NONNULL_END
