//
//  ULProgressHUD.m
//  U-Lab
//
//  Created by 周维康 on 17/5/18.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULProgressHUD.h"

static MBProgressHUD *hud = nil;
@implementation ULProgressHUD

+ (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

+ (void)showWithMsg:(NSString *)message inView:(UIView *)view
{
    [ULProgressHUD hide];
    hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = message;
    hud.mode = MBProgressHUDModeText;
    [hud show:YES];
    [hud hide:YES afterDelay:1.5f];
    
}

+ (void)showWithMsg:(NSString *)message
{
    [self showWithMsg:message inView:[UIApplication sharedApplication].keyWindow];
}

+ (void)showWithMsg:(NSString *)message inView:(UIView *)view whileExecutingBlock:(dispatch_block_t)block
{
    hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = message;
    hud.mode = MBProgressHUDModeIndeterminate;
    [hud showAnimated:YES whileExecutingBlock:block];

}

+ (void)showWithMsg:(NSString *)message inView:(UIView *)view withBlock:(dispatch_block_t)block
{
    hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = message;
    hud.mode = MBProgressHUDModeIndeterminate;
    [hud show:YES];
    block();
}

+ (void)hide
{
    [hud hide:YES];
}


@end
