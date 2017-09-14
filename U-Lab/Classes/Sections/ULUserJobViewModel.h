//
//  ULUserJobViewModel.h
//  U-Lab
//
//  Created by 周维康 on 17/5/30.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULViewModel.h"

@interface ULUserJobViewModel : ULViewModel

@property (nonatomic, strong) RACCommand *jobCommand;  /**< 获取今日工作 */
@property (nonatomic, strong) RACSubject *jobSubject;  /**< <#comment#> */
@property (nonatomic, strong) RACCommand *addCommand;  /**< 添加今日工作 */
@property (nonatomic, strong) RACCommand *otherCommand;  /**< <#comment#> */
@property (nonatomic, strong) RACCommand *otherJobCommand;  /**< <#comment#> */
@property (nonatomic, strong) RACSubject *otherSubject;  /**< <#comment#> */
@property (nonatomic, strong) RACSubject *otherJobSubject;  /**< <#comment#> */
@property (nonatomic, strong) RACCommand *updateCommand;  /**< <#comment#> */

@end
