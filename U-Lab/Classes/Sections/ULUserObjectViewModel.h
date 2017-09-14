//
//  ULUserObjectViewModel.h
//  U-Lab
//
//  Created by 周维康 on 17/5/29.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULViewModel.h"

@interface ULUserObjectViewModel : ULViewModel

@property (nonatomic, strong) RACCommand *objectCommand;  /**< 获取物品详情 */
@property (nonatomic, strong) RACSubject *objectSubject;  /**< 获取详情信号 */
@end
