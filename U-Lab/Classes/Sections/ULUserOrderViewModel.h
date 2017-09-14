//
//  ULUserOrderViewModel.h
//  U-Lab
//
//  Created by 周维康 on 17/5/30.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULViewModel.h"

@interface ULUserOrderViewModel : ULViewModel

@property (nonatomic, strong) RACCommand *orderCommand;  /**< 获取我的订单 */
@property (nonatomic, strong) RACCommand *agreeCommand;  /**< agree */
@property (nonatomic, strong) RACSubject *orderSubject;  /**< 订单信号 */
@property (nonatomic, strong) RACSubject *agreeySubject;  /**< 订单信号 */


@end
