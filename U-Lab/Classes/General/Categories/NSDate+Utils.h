//
//  NSDate+Utils.h
//  U-Lab
//
//  Created by 周维康 on 2017/6/7.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Utils)

+ (NSString *)nowTime;
- (NSInteger)month;
- (NSInteger)day;
- (NSInteger)year;
- (NSInteger)hour;
@end
