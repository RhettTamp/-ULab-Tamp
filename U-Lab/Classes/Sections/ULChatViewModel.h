//
//  ULChatViewModel.h
//  ULab
//
//  Created by 周维康 on 2017/6/11.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULViewModel.h"

@interface ULChatViewModel : ULViewModel

@property (nonatomic, strong) RACCommand *creatCommand;  /**< 创建单聊 */
@property (nonatomic, strong) RACCommand *getCommand;  /**< 获取单聊消息 */
@property (nonatomic, strong) RACCommand *sendCommand;  /**< 发送消息 0:文本 1:图片 */
@property (nonatomic, strong) RACCommand *avatarCommand;  /**< 获取用户头像 */
@property (nonatomic, strong) RACCommand *unreadCommand;  /**< 未读消息 */
@property (nonatomic, strong) RACCommand *clearCommand;  /**< 清除未读消息 */
@property (nonatomic, strong) RACCommand *lastestCommand;  /**< 最后一条消息内容 */

@end
