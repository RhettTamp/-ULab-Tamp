//
//  ULMessageOrderViewModel.h
//  ULab
//
//  Created by 周维康 on 2017/6/15.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULViewModel.h"

@interface ULMessageOrderViewModel : ULViewModel

@property (nonatomic, strong) RACCommand *getCommand;  /**< getCommand */
@property (nonatomic, strong) RACCommand *agreeCommand;  /**< agree */
@property (nonatomic, strong) RACCommand *getLendCommand;
@property (nonatomic, strong) RACCommand *inCommand;

@property (nonatomic, strong) RACSubject *objectSubject;  /**< 获取购买信息信号 */
@property (nonatomic, strong) RACSubject *lendSubject;  /**< 获取借用信息信号 */
@property (nonatomic, strong) RACSubject *inSubject;

@end
