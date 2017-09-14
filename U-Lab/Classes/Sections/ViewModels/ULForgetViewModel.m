//
//  ULForgetViewModel.m
//  U-Lab
//
//  Created by 周维康 on 17/5/30.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULForgetViewModel.h"

@implementation ULForgetViewModel

- (void)ul_initialize
{
    self.validSubject = [RACSubject subject];
    self.forgetSubject = [RACSubject subject];
    self.changeSubject = [RACSubject subject];
}

- (RACCommand *)validCommand
{
    if (!_validCommand)
    {
        @weakify(self)
        _validCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self)
                NSDictionary *dic = input;
                
                if ([[dic allKeys][0]  isEqual: @"emailAddress"])
                {
                    [self.request getDataWithParameter:input session:NO progress:nil success:^(ULBaseRequest *request, NSDictionary *responseObject) {
                        [self.validSubject sendNext:responseObject];
                        [subscriber sendCompleted];
                    } failure:^(ULBaseRequest *request, NSError *error) {
                        [self.validSubject sendError:error];
                        [subscriber sendCompleted];
                    } withPath:@"ulab_user/users/email"];
                } else {
                    [self.request getDataWithParameter:input session:NO progress:nil success:^(ULBaseRequest *request, NSDictionary *responseObject) {
                        [self.validSubject sendNext:responseObject];
                        [subscriber sendCompleted];
                    } failure:^(ULBaseRequest *request, NSError *error) {
                        [self.validSubject sendError:error];
                        [subscriber sendCompleted];
                    } withPath:@"ulab_user/users/message"];
                    
                }
                return nil;
            }];
        }];
    }
    return _validCommand;
}

- (RACCommand *)forgetCommand
{
    if (!_forgetCommand)
    {
        @weakify(self)
        _forgetCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            NSLog(@"%@",input);
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self)
                [self.request postDataWithParameter:input session:NO progress:nil success:^(ULBaseRequest *request, NSDictionary *responseObject) {
                    [[NSUserDefaults standardUserDefaults] setObject:input[@"newPassword"] forKey:@"user_password"];
                    [[NSUserDefaults standardUserDefaults] setObject:input[@"newPassword"] forKey:@"user_old_password"];
                    [self.forgetSubject sendNext:responseObject];
                    [subscriber sendCompleted];
                } failure:^(ULBaseRequest *request, NSError *error) {
                    [ULProgressHUD showWithMsg:@"请求失败"];
                    [subscriber sendCompleted];
                } withPath:@"ulab_user/users/password"];
                return nil;
            }];
        }];
    }
    return _forgetCommand;
}

- (RACCommand *)changeCommand
{
    if (!_changeCommand)
    {
        @weakify(self)
        _changeCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            NSLog(@"%@",input);
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self)
                [self.request postDataWithParameter:input session:YES progress:nil success:^(ULBaseRequest *request, NSDictionary *responseObject) {
                    [[NSUserDefaults standardUserDefaults] setObject:input[@"newPassword"] forKey:@"user_password"];
                    [[NSUserDefaults standardUserDefaults] setObject:input[@"newPassword"] forKey:@"user_old_password"];
                    [self.changeSubject sendNext:responseObject];
                    [subscriber sendCompleted];
                } failure:^(ULBaseRequest *request, NSError *error) {
                    [ULProgressHUD showWithMsg:@"请求失败"];
                    [subscriber sendCompleted];
                } withPath:@"ulab_user/users/password/update"];
                return nil;
            }];
        }];
    }
    return _changeCommand;
}


@end
