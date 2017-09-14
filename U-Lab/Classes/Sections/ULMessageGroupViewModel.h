//
//  ULMessageGroupViewModel.h
//  ULab
//
//  Created by 周维康 on 2017/6/11.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULViewModel.h"

@interface ULMessageGroupViewModel : ULViewModel

@property (nonatomic, strong) RACCommand *searchCommand;  /**< search */
@property (nonatomic, strong) RACCommand *buildCommand;  /**< 创建 */
@property (nonatomic, strong) RACCommand *getCommand;  /**< 获取我的群组 */
@property (nonatomic, strong) RACCommand *getUserCommand;  /**< 获取群成员 */
@property (nonatomic, strong) RACCommand *addUserCommand;  /**< 添加群成员 */
@property (nonatomic, strong) RACCommand *deleteUserCommand;  /**< 删除群成员 */
@property (nonatomic, strong) RACCommand *outCommand;  /**< 退出群 */
@end
