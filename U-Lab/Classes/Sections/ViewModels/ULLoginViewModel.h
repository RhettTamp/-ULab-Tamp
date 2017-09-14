//
//  ULLoginViewModel.h
//  U-Lab
//
//  Created by 周维康 on 17/5/18.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULViewModel.h"

@interface ULLoginViewModel : ULViewModel

@property (nonatomic, strong) RACCommand *loginCommand;  /**< 登录命令 */
@property (nonatomic, strong) RACSubject *successSubject;  /**< 登录成功 */
@property (nonatomic, strong) RACSubject *failureSubject;  /**< 登录失败 */
@property (nonatomic, strong) RACSubject *registerSubject;  /**< 注册新号 */
@property (nonatomic, strong) RACSubject *forgetSubject;  /**< 忘记密码信号 */
@end
