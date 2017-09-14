//
//  ULMainViewModel.h
//  ULab
//
//  Created by 周维康 on 2017/6/15.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULViewModel.h"

@interface ULMainViewModel : ULViewModel

@property (nonatomic, strong) RACCommand *searchCommand;  /**< search */
@end
