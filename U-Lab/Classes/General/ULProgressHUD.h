//
//  ULProgressHUD.h
//  U-Lab
//
//  Created by 周维康 on 17/5/18.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULView.h"

@interface ULProgressHUD : MBProgressHUD

+ (void)hide;

//文字提醒
+ (void)showWithMsg:(NSString *)message inView:(UIView *)view;
+ (void)showWithMsg:(NSString *)message;
//旋转等待
+ (void)showWithMsg:(NSString *)message inView:(UIView *)view whileExecutingBlock:(dispatch_block_t)block;

//手动控制结束时间
+ (void)showWithMsg:(NSString *)message inView:(UIView *)view withBlock:(dispatch_block_t)block;
@end
