//
//  ZWKAlertView.h
//  U-Lab
//
//  Created by 周维康 on 2017/6/6.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZWKAlertView;
@protocol ZWKAlertViewDelegate <NSObject>

@required
- (void)alertView:(ZWKAlertView *)alertView didClickAtIndex:(NSInteger)index;

@optional
- (void)cancelButtonDidClick;

@end
@interface ZWKAlertView : UIView

- (instancetype)initWithFuncArray:(NSArray *)funcArray;

@property (nonatomic, weak) id <ZWKAlertViewDelegate>delegate;

- (void)show;

- (void)hide;
@end

