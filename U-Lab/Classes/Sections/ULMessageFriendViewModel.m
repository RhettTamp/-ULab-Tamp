//
//  ULMessageFriendViewModel.m
//  ULab
//
//  Created by 周维康 on 2017/6/10.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULMessageFriendViewModel.h"
#import "ULMessageFriendModel.h"

@implementation ULMessageFriendViewModel

- (RACCommand *)searchCommand
{
    if (!_searchCommand)
    {
        @weakify(self)
        _searchCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self)
                [JMSGUser userInfoArrayWithUsernameArray:@[self.searchString] completionHandler:^(id resultObject, NSError *error) {
                    if (!error) {
                        [subscriber sendNext:@[@0,resultObject]];
                    } else {
                        [JMSGGroup groupInfoWithGroupId:self.searchString completionHandler:^(id resultObject, NSError *error) {
                            if (!error)
                            {
                                NSArray *array = @[resultObject];
                                if (array.count !=0)
                                    [subscriber sendNext:@[@1,array]];
                                else
                                    [subscriber sendNext:@[]];
                            } else {
                                [ULProgressHUD showWithMsg:@"搜索无结果"];
                            }
                            [subscriber sendCompleted];
                        }];
                    }
                }];
                return nil;
            }];
        }];

    }
    return _searchCommand;
}

- (RACCommand *)friendListCommand
{
    if (!_friendListCommand)
    {
        _friendListCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                [JMSGFriendManager getFriendList:^(id resultObject, NSError *error) {
                    [ULProgressHUD hide];
                    if(!error){
                        NSLog(@"%@",resultObject);
                        NSArray *friendList = (NSArray *)resultObject;
                        [subscriber sendNext:friendList];
                    } else {
                        [ULProgressHUD showWithMsg:@"请求失败"];
                    }
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
        
    }
    return _friendListCommand;
}

- (RACCommand *)addFriendCommand
{
    if (!_addFriendCommand)
    {
        _addFriendCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                [JMSGFriendManager sendInvitationRequestWithUsername:input appKey:jMessageAppKey reason:nil completionHandler:^(id resultObject, NSError *error) {
                    [ULProgressHUD hide];
                    if (!error) {
                        [ULProgressHUD showWithMsg:@"已发送好友请求"];
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
    return _addFriendCommand;
}

- (RACCommand *)acceptCommand
{
    if (!_acceptCommand)
    {
        _acceptCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                [JMSGFriendManager acceptInvitationWithUsername:input appKey:jMessageAppKey completionHandler:^(id resultObject, NSError *error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (!error) {
                            
                        }
                        else{
                            [ULProgressHUD showWithMsg:@"请求失败"];
                        }
                        [subscriber sendCompleted];
                    });
                }];
                return nil;
            }];
        }];
        
    }
    return _acceptCommand;
}

- (RACCommand *)rejectCommand
{
    if (!_rejectCommand)
    {
        _rejectCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                [JMSGFriendManager rejectInvitationWithUsername:input appKey:jMessageAppKey reason:nil completionHandler:^(id resultObject, NSError *error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (!error) {
                            
                        }
                        else{
                            [ULProgressHUD showWithMsg:@"请求失败"];
                        }
                        [subscriber sendCompleted];
                    });
                }];
                return nil;
            }];
        }];
        
    }
    return _rejectCommand;
}

- (RACCommand *)removeCommand
{
    if (!_removeCommand)
    {
        _removeCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                [JMSGFriendManager rejectInvitationWithUsername:input appKey:jMessageAppKey reason:nil completionHandler:^(id resultObject, NSError *error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (!error) {
                            
                        }
                        else{
                            [ULProgressHUD showWithMsg:@"请求失败"];
                        }
                        [subscriber sendCompleted];
                    });
                }];
                return nil;
            }];
        }];
        
    }
    return _removeCommand;
}

@end
