//
//  ULAppDelegate+Service.h
//  ULab
//
//  Created by 谭培 on 2017/8/2.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULAppDelegate.h"

@interface ULAppDelegate (Service)

- (void)registerJMessage;
- (void)regesterJPush;
- (void)initJPushWithLaunchOption:(NSDictionary *)option;

@end
