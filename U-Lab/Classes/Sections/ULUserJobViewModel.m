//
//  ULUserJobViewModel.m
//  U-Lab
//
//  Created by 周维康 on 17/5/30.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULUserJobViewModel.h"
#import "ULLabMemberModel.h"
#import "ULUserJobModel.h"

@interface ULUserJobViewModel()

@end

@implementation ULUserJobViewModel

- (void)ul_initialize
{
    self.jobSubject = [RACSubject subject];
    self.otherSubject = [RACSubject subject];
    self.otherJobSubject = [RACSubject subject];
}

- (RACCommand *)jobCommand
{
    if (!_jobCommand)
    {
        @weakify(self)
        _jobCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self)
                [self.request getDataWithParameter:nil session:YES progress:nil success:^(ULBaseRequest *request, NSDictionary *responseObject) {
                    NSMutableArray *jobArray = [NSMutableArray array];
                    if ([responseObject[@"data"] class] != [NSNull class])
                    {
                        for (NSDictionary *jobDic in responseObject[@"data"])
                        {
                            ULUserJobModel *model = [[ULUserJobModel alloc] init];
                            [model yy_modelSetWithDictionary:jobDic];
                            [jobArray addObject:model];
                        }
                    }
                    [self.jobSubject sendNext:jobArray];
                    [subscriber sendCompleted];
                } failure:^(ULBaseRequest *request, NSError *error) {
                    [ULProgressHUD showWithMsg:@"获取失败"];
                    [subscriber sendCompleted];
                } withPath:@"ulab_user/users/todayWork"];
  
                return nil;
            }];
        }];
    }
    return _jobCommand;
}

- (RACCommand *)addCommand
{
    if (!_addCommand)
    {
        @weakify(self)
        _addCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self)
                [self.request postDataWithParameter:input session:YES progress:nil success:^(ULBaseRequest *request, NSDictionary *responseObject) {
                    NSMutableArray *jobArray = [NSMutableArray array];
                    if ([responseObject[@"data"] class] != [NSNull class])
                    {
                        for (NSDictionary *jobDic in responseObject[@"data"])
                        {
                            ULUserJobModel *model = [[ULUserJobModel alloc] init];
                            [model yy_modelSetWithDictionary:jobDic];
                            [jobArray addObject:model];
                        }
                    }
                    [ULProgressHUD hide];
                    [subscriber sendNext:jobArray];
                    [subscriber sendCompleted];
                } failure:^(ULBaseRequest *request, NSError *error) {
                    [ULProgressHUD hide];
                    [ULProgressHUD showWithMsg:@"请求失败"];
                    [subscriber sendCompleted];
                } withPath:@"ulab_user/users/todayWork"];
                return nil;
            }];
        }];
    }
    return _addCommand;
}

- (RACCommand *)otherJobCommand
{
    if (!_otherJobCommand)
    {
        @weakify(self)
        _otherJobCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self)
                [self.request getDataWithParameter:input session:YES progress:nil success:^(ULBaseRequest *request, NSDictionary *responseObject) {
                    NSMutableArray *jobArray = [NSMutableArray array];
                    if ([responseObject[@"data"] class] != [NSNull class])
                    {
                        for (NSDictionary *jobDic in responseObject[@"data"])
                        {
                            ULUserJobModel *model = [[ULUserJobModel alloc] init];
                            [model yy_modelSetWithDictionary:jobDic];
                            [jobArray addObject:model];
                        }
                    }
                    [ULProgressHUD hide];
                    [self.otherJobSubject sendNext:jobArray];
                    [subscriber sendCompleted];
                } failure:^(ULBaseRequest *request, NSError *error) {
                    [ULProgressHUD hide];
                    [ULProgressHUD showWithMsg:@"请求失败"];
                    [subscriber sendCompleted];
                } withPath:@"ulab_user/users/others/todayWork"];
                return nil;
            }];
        }];
    }
    return _otherJobCommand;
}


- (RACCommand *)otherCommand
{
    if (!_otherCommand)
    {
        @weakify(self)
        _otherCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self)
                [self.request getDataWithParameter:input session:YES progress:nil success:^(ULBaseRequest *request, NSDictionary *responseObject) {
                    [ULProgressHUD hide];
                    NSMutableArray *arr = [NSMutableArray array];
                    if (responseObject[@"data"]&&![responseObject[@"data"] isKindOfClass:[NSNull class]]) {
                        for (NSDictionary *dic in responseObject[@"data"]) {
                            ULLabMemberModel *jobModel = [[ULLabMemberModel alloc]init];
                            [jobModel yy_modelSetWithJSON:dic];
                            if (jobModel.memberId != [[ULUserMgr sharedMgr].userId integerValue]) {
                                [arr addObject:jobModel];
                            }
                        }

                    }
                    [self.otherSubject sendNext:arr];
                    [subscriber sendCompleted];
                } failure:^(ULBaseRequest *request, NSError *error) {
                    [ULProgressHUD hide];
                    [subscriber sendError:error];
                    
                    [subscriber sendCompleted];
                } withPath:@"ulab_lab/lab/users"];
                return nil;
            }];
        }];
    }
    return _otherCommand;

}

- (RACCommand *)updateCommand
{
    if (!_updateCommand)
    {
        @weakify(self)
        _updateCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self)
                [self.request patchDataWithParameter:input session:YES success:^(ULBaseRequest *request, NSDictionary *responseObject) {
                    [ULProgressHUD hide];
                    [subscriber sendNext:nil];
                    [subscriber sendCompleted];
                } failure:^(ULBaseRequest *request, NSError *error) {
                    [ULProgressHUD hide];
                    [ULProgressHUD showWithMsg:@"修改失败"];
                    
                    [subscriber sendCompleted];

                } withPath:@"ulab_user/users/todayWork"];
                return nil;
            }];
        }];
    }
    return _updateCommand;
    
}

//- (RACSubject *)otherSubject{
//    if (_otherSubject) {
//        _otherSubject = [RACSubject subject];
//    }
//    return _otherSubject;
//}

@end
