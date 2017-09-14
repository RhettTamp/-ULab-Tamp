//
//  ULUserDetailViewModel.m
//  U-Lab
//
//  Created by 周维康 on 17/5/30.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULUserDetailViewModel.h"

@interface ULUserDetailViewModel()

@end

@implementation ULUserDetailViewModel

- (RACCommand *)detailCommand
{
    if (!_detailCommand)
    {
        @weakify(self)
        _detailCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self)
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self)
                [self.request getDataWithParameter:input session:YES progress:nil success:^(ULBaseRequest *request, NSDictionary *responseObject) {
                    [[ULUserMgr sharedMgr] yy_modelSetWithDictionary:responseObject[@"data"]];
                    
            [subscriber sendCompleted];
                } failure:^(ULBaseRequest *request, NSError *error) {
                    [ULProgressHUD showWithMsg:@"请求失败"];
         [subscriber sendCompleted];
                } withPath:@"ulab_user/users/info"];
                return nil;
            }];
        }];
    }
    return _detailCommand;
}

- (RACCommand *)improveCommand
{
    if (!_improveCommand)
    {
        @weakify(self)
        _improveCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self)
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self)
                [self.request postDataWithParameter:input session:YES progress:nil success:^(ULBaseRequest *request, NSDictionary *responseObject) {
                    [ULProgressHUD hide];
                    [ULUserMgr sharedMgr].sex = input[@"sex"];
                    [ULUserMgr sharedMgr].role = input[@"role"];
                    [ULUserMgr sharedMgr].userName = input[@"username"];
                    [ULUserMgr sharedMgr].labLocation = input[@"labLocation"];
                    [ULUserMgr sharedMgr].laboratoryName = input[@"laboratoryName"];
                    [subscriber sendNext:nil];
                    [subscriber sendCompleted];
                } failure:^(ULBaseRequest *request, NSError *error) {
                    [ULProgressHUD hide];
                    [ULProgressHUD showWithMsg:@"请求失败"];
                    [subscriber sendCompleted];
                } withPath:@"ulab_user/users/info"];
                return nil;
            }];
        }];
    }
    return _improveCommand;
}
- (RACCommand *)researchCommand
{
    if (!_researchCommand)
    {
        @weakify(self)
        _researchCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self)
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self)
                [self.request postDataWithParameter:input session:YES progress:nil success:^(ULBaseRequest *request, NSDictionary *responseObject) {
                    [ULProgressHUD hide];
                    [ULUserMgr sharedMgr].research = input[@"researchDirection"];
                    [ULUserMgr sharedMgr].school = input[@"educationalHistory"];
                    [ULProgressHUD showWithMsg:@"保存成功"];
                    [subscriber sendCompleted];
                } failure:^(ULBaseRequest *request, NSError *error) {
                    [ULProgressHUD hide];
                    [ULProgressHUD showWithMsg:@"保存失败"];
                    [subscriber sendCompleted];
                } withPath:@"ulab_user/users/personalInfo"];
                return nil;
            }];
        }];
    }
    return _researchCommand;
}

@end
