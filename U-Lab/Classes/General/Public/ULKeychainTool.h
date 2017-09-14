//
//  ULKeychainTool.h
//  ULab
//
//  Created by 谭培 on 2017/7/19.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ULKeychainTool : NSObject

+ (void)save:(NSString *)service data:(id)data;
+ (id)load:(NSString *)service;
+ (void)delete:(NSString *)service;


@end
