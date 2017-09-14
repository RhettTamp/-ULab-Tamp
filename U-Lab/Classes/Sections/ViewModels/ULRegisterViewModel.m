//
//  ULRegisterViewModel.m
//  U-Lab
//
//  Created by 周维康 on 17/5/18.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULRegisterViewModel.h"

@implementation ULRegisterViewModel

- (void)ul_initialize
{
    self.validSubject = [RACSubject subject];
    self.registerSubject = [RACSubject subject];
    self.verifySubject = [RACSubject subject];
    self.verifyContactSubject = [RACSubject subject];
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
                        [ULProgressHUD showWithMsg:@"获取验证码失败"];
                        [subscriber sendCompleted];
                    } withPath:@"ulab_user/users/email"];
                } else {
                    [self.request getDataWithParameter:input session:NO progress:nil success:^(ULBaseRequest *request, NSDictionary *responseObject) {
                        [self.validSubject sendNext:responseObject];
                        [subscriber sendCompleted];
                    } failure:^(ULBaseRequest *request, NSError *error) {
                        [ULProgressHUD showWithMsg:@"获取验证码失败"];
                        [subscriber sendCompleted];
                    } withPath:@"ulab_user/users/message"];
                    
                }
                return nil;
            }];
        }];
    }
    return _validCommand;
}

- (RACCommand *)verifyCommand{
    if (!_verifyCommand)
    {
        @weakify(self)
        _verifyCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self)
                NSLog(@"%@",input);
                [self.request postDataWithParameter:input session:NO progress:nil success:^(ULBaseRequest *request, NSDictionary *responseObject) {
                    [self.verifySubject sendNext:responseObject];
                    [subscriber sendCompleted];
                    
                } failure:^(ULBaseRequest *request, NSError *error) {
                    [ULProgressHUD showWithMsg:@"验证出错"];
                    [subscriber sendCompleted];
                } withPath:@"ulab_user/user/code"];
                return nil;
            }];
        }];
    }
    return _verifyCommand;
}

- (RACCommand *)verifyContactCommand{
    if (!_verifyContactCommand)
    {
        @weakify(self)
        _verifyContactCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self)
                [self.request patchDataWithParameter:input session:YES success:^(ULBaseRequest *request, NSDictionary *responseObject) {
                    [self.verifyContactSubject sendNext:responseObject];
                    [subscriber sendCompleted];
                } failure:^(ULBaseRequest *request, NSError *error) {
                    [subscriber sendCompleted];
                } withPath:@"ulab_user/users/contact"];
                 return nil;
            }];
        }];
    }
    return _verifyContactCommand;
}


- (RACCommand *)registerCommand
{
    if (!_registerCommand)
    {
        @weakify(self)
        _registerCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self)
                [self.request postDataWithParameter:input session:NO progress:nil success:^(ULBaseRequest *request, NSDictionary *responseObject) {
                    [ULProgressHUD hide];
                    if ([responseObject[@"success"] integerValue] != 0) {
                        [[NSUserDefaults standardUserDefaults] setObject:input[@"userName"] forKey:@"private_user_account"];
                        [[NSUserDefaults standardUserDefaults] setObject:input[@"password"] forKey:@"user_password"];
                        NSString *str = input[@"userName"];
                        if (str.length == 11) {
                            [[NSUserDefaults standardUserDefaults] setObject:input[@"userName"] forKey:@"private_user_phone"];
                        }else{
                            [[NSUserDefaults standardUserDefaults] setObject:input[@"userName"] forKey:@"private_user_Email"];
                        }
                        
                        [[NSUserDefaults standardUserDefaults] setObject:input[@"password"] forKey:@"user_old_password"];
                    }
                    [self.registerSubject sendNext:responseObject];
                    [subscriber sendCompleted];
                } failure:^(ULBaseRequest *request, NSError *error) {
                    [ULProgressHUD hide];
                    [ULProgressHUD showWithMsg:@"请求失败"];
                    [subscriber sendCompleted];
                } withPath:@"ulab_user/users"];
                
                return nil;
            }];
        }];
    }
    return _registerCommand;
}



-(BOOL)isValidateEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
@end
