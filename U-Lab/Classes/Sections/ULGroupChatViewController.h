//
//  ULGroupChatViewController.h
//  ULab
//
//  Created by 周维康 on 2017/6/21.
//  Copyright © 2017年 周维康. All rights reserved.
//
#import <JSQMessagesViewController/JSQMessagesViewController.h>

@interface ULGroupChatViewController : JSQMessagesViewController

- (instancetype)initWithGroupId:(NSString *)gid conversation:(JMSGConversation *)conversation;

@end
