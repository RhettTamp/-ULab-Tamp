//
//  UITabBar+Badge.h
//  ULab
//
//  Created by 谭培 on 2017/8/2.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar (Badge)

- (void)showBadgeOnItmIndex:(int)index;
-(void)hideBadgeOnItemIndex:(int)index;

@end
