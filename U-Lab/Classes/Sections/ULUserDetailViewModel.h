//
//  ULUserDetailViewModel.h
//  U-Lab
//
//  Created by 周维康 on 17/5/30.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULViewModel.h"

@interface ULUserDetailViewModel : ULViewModel

@property (nonatomic, strong) RACCommand *detailCommand;  /**< 获取详情 */
@property (nonatomic, strong) RACCommand *improveCommand;  /**< improve */
@property (nonatomic, strong) RACCommand *avatorCommand;  /**< <#comment#> */
@property (nonatomic, strong) RACCommand *researchCommand;  /**< <#comment#> */
@end
