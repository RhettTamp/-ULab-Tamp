//
//  ULChatViewModel.m
//  ULab
//
//  Created by 周维康 on 2017/6/11.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULChatViewModel.h"

@implementation ULChatViewModel

- (RACCommand *)creatCommand
{
    if (!_creatCommand)
    {
        _creatCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                
                [JMSGConversation createSingleConversationWithUsername:input completionHandler:^(id resultObject, NSError *error) {
                    [ULProgressHUD hide];
                    if (!error) {
                        [subscriber sendNext:resultObject];
                        [subscriber sendCompleted];
                    } else {
                        [ULProgressHUD showWithMsg:@"请求失败"];
                        [subscriber sendCompleted];
                    }
                }];
                return nil;
            }];
        }];
    }
    return _creatCommand;
}

- (RACCommand *)getCommand
{
    if (!_getCommand)
    {
        _getCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                JMSGConversation *conversation = [[JMSGConversation alloc] init];
                [conversation allMessages:^(id resultObject, NSError *error) {
                    [ULProgressHUD hide];
                    if (!error) {
                        [subscriber sendNext:resultObject];
                        [subscriber sendCompleted];
                    } else {
                        [ULProgressHUD showWithMsg:@"请求失败"];
                        [subscriber sendCompleted];
                    }
                }];
                return nil;
            }];
        }];
    }
    return _getCommand;
}

- (RACCommand *)sendCommand
{
    if (!_sendCommand)
    {
        _sendCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                JMSGConversation *conversation = [[JMSGConversation alloc] init];
                if ([input[@"type"]  isEqual: @0])
                {
                    [conversation sendTextMessage:input[@"content"]];
                } else if ([input[@"type"] isEqual: @1]){
                    [conversation sendImageMessage:input[@"content"]];
                }
                return nil;
            }];
        }];
    }
    return _sendCommand;

}

- (RACCommand *)avatarCommand
{
    if (!_avatarCommand)
    {
        _avatarCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                JMSGConversation *conversation = [[JMSGConversation alloc] init];
                [conversation avatarData:^(NSData *data, NSString *objectId, NSError *error) {
                    if (!error) {
                        UIImage *image;
                        if (data)
                        {
                            image = [UIImage imageWithData:data];
                        } else {
                            image = [UIImage imageWithColor:kCommonGrayColor];
                        }
                        [subscriber sendNext:image];
                        [subscriber sendCompleted];
                    } else {
                        [ULProgressHUD showWithMsg:@"请求失败"];
                        [subscriber sendCompleted];
                    };
                }];
                return nil;
            }];
        }];
    }
    return _avatarCommand;
}

- (RACCommand *)unreadCommand
{
    if (!_unreadCommand)
    {
        _unreadCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//                JMSGConversation *conversation = [[JMSGConversation alloc] init];
//                [JMSGConversation un  avatarData:^(NSData *data, NSString *objectId, NSError *error) {
//                    if (!error) {
//                        UIImage *image;
//                        if (data)
//                        {
//                            image = [UIImage imageWithData:data];
//                        } else {
//                            image = [UIImage imageWithColor:kCommonGrayColor];
//                        }
//                        [subscriber sendNext:image];
//                        [subscriber sendCompleted];
//                    } else {
//                        [ULProgressHUD showWithMsg:@"请求失败"];
//                        [subscriber sendCompleted];
//                    };
//                }];
                return nil;
            }];
        }];
    }
    return _unreadCommand;
}

- (RACCommand *)clearCommand
{
    return _clearCommand;
}

@end
