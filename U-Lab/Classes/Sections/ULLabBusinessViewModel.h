//
//  ULLabBusinessViewModel.h
//  ULab
//
//  Created by 周维康 on 2017/6/15.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULViewModel.h"

@interface ULLabBusinessViewModel : ULViewModel

@property (nonatomic, strong) RACCommand *getCommand;  /**< 获取财务信息 */
@property (nonatomic, strong) RACCommand *detailCommand;  /**< 获取详情 */
@property (nonatomic, strong) RACSubject *nextSubject;
@property (nonatomic, strong) RACSubject *detailSubject;

@end
