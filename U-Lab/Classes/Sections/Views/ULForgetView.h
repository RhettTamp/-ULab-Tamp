//
//  ULForgetView.h
//  U-Lab
//
//  Created by 周维康 on 17/5/30.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULView.h"
#import "ULForgetViewModel.h"

@interface ULForgetView : ULView

@property (nonatomic, strong) ULForgetViewModel *viewModel;  /**< VM */

- (instancetype)initWithPhone:(NSString *)phoneNumber isLogin:(BOOL)isLogin;

@end
