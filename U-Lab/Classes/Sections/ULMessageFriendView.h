//
//  ULMessageFriendView.h
//  U-Lab
//
//  Created by 周维康 on 2017/6/8.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULView.h"

@interface ULMessageFriendView : ULView

@property (nonatomic, strong) RACSubject *chatSubject;  /**< 聊天信号 */
- (void)updateFriendList;

@end
