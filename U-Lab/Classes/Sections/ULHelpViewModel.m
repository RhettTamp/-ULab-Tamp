//
//  ULHelpViewModel.m
//  ULab
//
//  Created by 周维康 on 2017/6/22.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULHelpViewModel.h"

@implementation ULHelpViewModel

- (RACCommand *)useCommand
{
    if (!_useCommand)
    {
        _useCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                [self.request getDataWithParameter:input session:YES progress:nil success:^(ULBaseRequest *request, NSDictionary *responseObject) {
                    [ULProgressHUD hide];
                    [subscriber sendNext:responseObject];
                    [subscriber sendCompleted];
                } failure:^(ULBaseRequest *request, NSError *error) {
                    [ULProgressHUD hide];
                    [subscriber sendCompleted];
                } withPath:@"ulab_user/users/helpInfo"];
                
                return nil;
            }];
        }];
    }
    return _useCommand;
}

- (RACCommand *)feedbackCommand
{
    if (!_feedbackCommand)
    {
        _feedbackCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                [self.request postDataWithParameter:input session:YES progress:nil success:^(ULBaseRequest *request, NSDictionary *responseObject) {
                    [ULProgressHUD hide];
                    [subscriber sendNext:responseObject];
                    [subscriber sendCompleted];
                } failure:^(ULBaseRequest *request, NSError *error) {
                    [ULProgressHUD hide];
                    [subscriber sendCompleted];
                } withPath:@"ulab_user/users/feedback"];
                
                return nil;
            }];
        }];
    }
    return _feedbackCommand;
}

@end
