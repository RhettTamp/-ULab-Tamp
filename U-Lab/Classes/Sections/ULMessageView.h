//
//  ULMessageView.h
//  U-Lab
//
//  Created by 周维康 on 17/5/21.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULView.h"
#import "ULMessageOrderView.h"
#import "ULMessageFriendView.h"

@interface ULMessageView : ULView

@property (nonatomic, strong) RACSubject *appearSubject;  /**< 视图出现 */
@property (nonatomic, strong) ULMessageOrderView *orderView;  /**< 订单列表 */
@property (nonatomic, strong) ULMessageFriendView *friendView;  /**< 好友消息 */

@end
