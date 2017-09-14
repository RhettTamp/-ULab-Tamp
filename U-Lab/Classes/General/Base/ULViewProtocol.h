//
//  ULViewProtocol.h
//  U-Lab
//
//  Created by 周维康 on 17/5/17.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ULViewModelProtocol;

@protocol ULViewProtocol <NSObject>

@optional

- (instancetype)initWithViewModel:(id <ULViewModelProtocol>)viewModel;

//绑定V VM
- (void)ul_bindViewModel;
//添加子View到主View
- (void)ul_setupViews;
//点击任意出回收键盘
- (void)ul_addReturnKeyBoard;

@end
