//
//  ULMessageChatViewController.h
//  ULab
//
//  Created by 周维康 on 2017/6/10.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import <JSQMessagesViewController/JSQMessagesViewController.h>
@class ULMessageFriendModel;
@interface ULMessageChatViewController : JSQMessagesViewController

- (instancetype)initWithUser:(JMSGUser *)user conversation:(JMSGConversation *)conversation 
;

@end
