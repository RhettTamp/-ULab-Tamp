//
//  ULSearchLabViewModel.h
//  U-Lab
//
//  Created by 周维康 on 17/5/31.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULViewModel.h"

@interface ULSearchLabViewModel : ULViewModel

@property (nonatomic, strong) RACCommand *searchCommand;  /**< 搜索命令 */
@property (nonatomic, strong) RACCommand *addCommand;  /**< 添加实验室 */
@property (nonatomic, strong) RACCommand *addFriendCommand;
@property (nonatomic, strong) RACSubject *addSubject;
@property (nonatomic, strong) NSString *searchKey;  /**< 搜索关键字 */
@end
