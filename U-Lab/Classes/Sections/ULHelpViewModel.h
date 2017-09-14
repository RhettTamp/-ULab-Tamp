//
//  ULHelpViewModel.h
//  ULab
//
//  Created by 周维康 on 2017/6/22.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULViewModel.h"

@interface ULHelpViewModel : ULViewModel

@property (nonatomic, strong) RACCommand *useCommand;  /**< <#comment#> */
@property (nonatomic, strong) RACCommand *feedbackCommand;  /**< <#comment#> */
@end
