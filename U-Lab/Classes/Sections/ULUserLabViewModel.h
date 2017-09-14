//
//  ULUserLabViewModel.h
//  U-Lab
//
//  Created by 周维康 on 17/5/31.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULViewModel.h"

@interface ULUserLabViewModel : ULViewModel
@property (nonatomic, strong) RACCommand *addCommand;  /**< 添加实验 */
@property (nonatomic, strong) RACCommand *updateCommand;  /**< 更新实验 */
@property (nonatomic, strong) RACCommand *getCommand;  /**< 获取实验 */
@property (nonatomic, strong) RACSubject *addSubject;  /**< 添加信号 */
@property (nonatomic, strong) RACSubject *updateSubject;  /**< 更新信号 */
@property (nonatomic, strong) RACSubject *getSubject;  /**< 获取信号 */
@property (nonatomic, strong) RACCommand *deleteCommand;  /**< <#comment#> */
@property (nonatomic, strong) RACCommand *addProjectCommand;  /**< <#comment#> */
@end
