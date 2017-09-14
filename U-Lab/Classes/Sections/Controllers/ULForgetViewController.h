//
//  ULForgetViewController.h
//  U-Lab
//
//  Created by 周维康 on 17/5/18.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULViewController.h"

@interface ULForgetViewController : ULViewController

- (instancetype)initWithPhone:(NSString *)phoneNumber;
- (instancetype)initWithPhone:(NSString *)phoneNumber isLogin:(BOOL)isLogin;
@end
