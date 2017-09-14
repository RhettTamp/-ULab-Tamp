//
//  ULMessageFriendViewModel.h
//  ULab
//
//  Created by 周维康 on 2017/6/10.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULViewModel.h"

@interface ULMessageFriendViewModel : ULViewModel

@property (nonatomic, strong) RACCommand *searchCommand;  /**< search */
@property (nonatomic, strong) RACCommand *friendListCommand;  /**< 获取好友列表 */
@property (nonatomic, strong) RACCommand *addFriendCommand;  /**< 添加好友 */
@property (nonatomic, strong) RACCommand *acceptCommand;  /**< 接受好友请求 */
@property (nonatomic, copy) NSString *searchString;  /**< 搜索号码 */
@property (nonatomic, strong) RACCommand *rejectCommand;  /**< 拒绝好友申请 */
@property (nonatomic, strong) RACCommand *removeCommand;  /**< 删好友 */
@end
