//
//  ULViewControllerProtocol.h
//  U-Lab
//
//  Created by 周维康 on 17/5/17.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ULViewProtocol;

@protocol ULViewControllerProtocol <NSObject>

@optional

- (instancetype)initWithViewModel:(id <ULViewProtocol>)viewModel;

- (void)ul_bindViewModel;
- (void)ul_addSubviews;
- (void)ul_layoutNavigation;
- (void)ul_getNewData;
- (void)recoverKeyboard;

@end
