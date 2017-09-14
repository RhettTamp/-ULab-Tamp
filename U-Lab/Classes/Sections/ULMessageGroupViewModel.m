//
//  ULMessageGroupViewModel.m
//  ULab
//
//  Created by 周维康 on 2017/6/11.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULMessageGroupViewModel.h"

@implementation ULMessageGroupViewModel
- (RACCommand *)buildCommand
{
    if (!_buildCommand)
    {
        _buildCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                [JMSGGroup createGroupWithName:input[@"name"] desc:input[@"desc"] memberArray:input[@"member"] completionHandler:^(id resultObject, NSError *error) {
                    if (!error) {
                        JMSGGroup *group = (JMSGGroup *)resultObject;
                        [subscriber sendNext:group];
                        [subscriber sendCompleted];
                    } else {
                        [subscriber sendCompleted];
                        [ULProgressHUD showWithMsg:@"请求失败"];
                    }
                }];
                return nil;
            }];
        }];
    }
    return _buildCommand;
    
}

- (RACCommand *)getCommand
{
    if (!_getCommand)
    {
        _getCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                [JMSGGroup createGroupWithName:input desc:input[@"desc"] memberArray:input[@"member"] completionHandler:^(id resultObject, NSError *error) {
                    if (!error) {
                        NSLog(@"创建群组成功!");
                        JMSGGroup *group = (JMSGGroup *)resultObject;
                        [subscriber sendNext:group];
                        [subscriber sendCompleted];
                    } else {
                        [subscriber sendCompleted];
                        [ULProgressHUD showWithMsg:@"请求失败"];
                    }
                }];
                return nil;
            }];
        }];
    }
    return _getCommand;
    
}
@end
