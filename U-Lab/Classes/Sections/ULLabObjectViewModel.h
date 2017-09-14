//
//  ULLabObjectViewModel.h
//  U-Lab
//
//  Created by 周维康 on 2017/6/9.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULViewModel.h"

@interface ULLabObjectViewModel : ULViewModel

@property (nonatomic, strong) RACSubject *objectSubject;  /**< subject */
@property (nonatomic, strong) RACCommand *objectCommand;  /**< 获取实验室物品 */
@property (nonatomic, strong) RACCommand *detailCommand;  /**< 物品详情 */
@property (nonatomic, strong) RACCommand *lendCommand;  /**< 借用 */
@property (nonatomic, strong) RACCommand *inCommand;  /**< 入库 */
@property (nonatomic, strong) RACCommand *buyCommand;  /**< 购买 */
@end
