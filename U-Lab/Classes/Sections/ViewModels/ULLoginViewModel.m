//
//  ULLoginViewModel.m
//  U-Lab
//
//  Created by 周维康 on 17/5/18.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULLoginViewModel.h"

@implementation ULLoginViewModel


- (void)ul_initialize
{
    self.successSubject = [RACSubject subject];
    self.failureSubject = [RACSubject subject];
    self.registerSubject = [RACSubject subject];
    self.forgetSubject = [RACSubject subject];
}

- (RACCommand *)loginCommand
{
    if (!_loginCommand)
    {
        @weakify(self);
        _loginCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self);
                
                    [self.request postDataWithParameter:input session:NO progress:nil success:^(ULBaseRequest *request, NSDictionary *responseObject) {
                        [[NSUserDefaults standardUserDefaults] setObject:input[@"password"] forKey:@"user_password"];
                        [[NSUserDefaults standardUserDefaults] setObject:input[@"password"] forKey:@"user_old_password"];
                        [[NSUserDefaults standardUserDefaults] setObject:input[@"userName"] forKey:@"private_user_account"];
                        [[ULUserMgr sharedMgr] yy_modelSetWithDictionary:responseObject[@"data"]];
                        if (responseObject[@"data"]&&![responseObject[@"data"] isKindOfClass:[NSNull class]]) {
                            [ULUserMgr sharedMgr].research = responseObject[@"data"][@"researchDirection"];
                        }
                        if ([[ULUserMgr sharedMgr].research isKindOfClass:[NSNull class]]) {
                            [ULUserMgr sharedMgr].research = nil;
                        }
                        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[ULUserMgr sharedMgr].avaterImageUrl]]];

                        [ULUserMgr sharedMgr].avaterImage = image;
                        [ULUserMgr saveMgr];
                        [[NSNotificationCenter defaultCenter] postNotificationName:kUserAvatorImageDidChange object:nil userInfo:nil];
                        [self.successSubject sendNext:responseObject];
                        [subscriber sendCompleted];
                    } failure:^(ULBaseRequest *request, NSError *error) {
                        [ULProgressHUD hide];
                        [ULProgressHUD showWithMsg:@"请求失败"];
                        [subscriber sendCompleted];
                    } withPath:@"ulab_user/users/session"];
                
                
                return nil;
            }];
        }];
    }
    return _loginCommand;
}


@end
