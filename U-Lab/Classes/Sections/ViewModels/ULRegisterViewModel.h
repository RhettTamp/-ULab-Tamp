//
//  ULRegisterViewModel.h
//  U-Lab
//
//  Created by 周维康 on 17/5/18.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULViewModel.h"

@interface ULRegisterViewModel : ULViewModel

@property (nonatomic, strong) RACSubject *validSubject;  /**< 跳转信号 */
@property (nonatomic, strong) RACSubject *registerSubject;  /**< 注册信号 */
@property (nonatomic ,strong) RACSubject *verifySubject;   /**< 验证码信号*/
@property (nonatomic ,strong) RACSubject *verifyContactSubject;  

@property (nonatomic, strong) RACCommand *registerCommand;  /**< 注册命令 */
@property (nonatomic, strong) RACCommand *validCommand;  /**< 验证码命令 */
@property (nonatomic, strong) RACCommand *verifyCommand;

@property (nonatomic, strong) RACCommand *verifyContactCommand;


@end
