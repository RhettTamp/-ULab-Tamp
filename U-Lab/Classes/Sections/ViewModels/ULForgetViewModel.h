//
//  ULForgetViewModel.h
//  U-Lab
//
//  Created by 周维康 on 17/5/30.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULViewModel.h"

@interface ULForgetViewModel : ULViewModel

@property (nonatomic, strong) RACSubject *validSubject;  /**< 跳转信号 */
@property (nonatomic, strong) RACSubject *forgetSubject;  /**< 注册信号 */
@property (nonatomic, strong) RACSubject *changeSubject;
@property (nonatomic, strong) RACCommand *forgetCommand;  /**< 注册命令 */
@property (nonatomic, strong) RACCommand *validCommand;  /**< 验证码命令 */
@property (nonatomic, strong) RACCommand *changeCommand;


@end
