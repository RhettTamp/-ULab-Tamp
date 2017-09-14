//
//  ULLabViewModel.m
//  U-Lab
//
//  Created by 周维康 on 17/5/31.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULLabViewModel.h"
#import "ULLabModel.h"
#import "ULLabMemberModel.h"

@implementation ULLabViewModel

- (void)ul_initialize
{
    self.memberSubject = [RACSubject subject];
    self.addMemberSubject = [RACSubject subject];
    self.friendSubject = [RACSubject subject];
    self.applyFriendSubject = [RACSubject subject];
    self.agreeSubject = [RACSubject subject];
    self.relieveSubject = [RACSubject subject];
}
- (RACCommand *)labCommand
{
    if (!_labCommand)
    {
        @weakify(self)
        _labCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self)
                [self.request getDataWithParameter:@{@"labId" : @([ULUserMgr sharedMgr].laboratoryId)} session:YES progress:nil success:^(ULBaseRequest *request, NSDictionary *responseObject) {
                    [[ULUserMgr sharedMgr] yy_modelSetWithDictionary:responseObject[@"data"]];
                    if (responseObject[@"data"]&&![responseObject[@"data"] isKindOfClass:[NSNull class]]){
                        [ULUserMgr sharedMgr].laboratoryName = responseObject[@"data"][@"name"];
                        if ([responseObject[@"data"][@"researchDirection"] isKindOfClass:[NSNull class]]) {
                            [ULUserMgr sharedMgr].labResearch = nil;
                        }else{
                            [ULUserMgr sharedMgr].labResearch = responseObject[@"data"][@"researchDirection"];
                        }
                    }
                    [subscriber sendCompleted];
                } failure:^(ULBaseRequest *request, NSError *error) {
                    [ULProgressHUD showWithMsg:@"请求失败"];
                    [subscriber sendCompleted];
                } withPath:@"ulab_lab/lab"];
                return nil;
            }];
        }];
    }
    return _labCommand;
}

- (RACCommand *)relieveCommand
{
    if (!_relieveCommand)
    {
        @weakify(self)
        _relieveCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self)
                [self.request postDataWithParameter:input session:YES progress:nil success:^(ULBaseRequest *request, NSDictionary *responseObject) {
                    [self.relieveSubject sendNext:nil];
                    [subscriber sendCompleted];
                } failure:^(ULBaseRequest *request, NSError *error) {
                    [ULProgressHUD showWithMsg:@"请求失败"];
                    [subscriber sendCompleted];
                } withPath:@"ulab_lab/lab/friendlyLab/del"];
                return nil;
            }];
        }];
    }
    return _relieveCommand;
}


- (RACCommand *)agreeCommand          //处理实验申请
{
    if (!_agreeCommand)
    {
        @weakify(self)
        _agreeCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self)
                [self.request postDataWithParameter:input session:YES progress:nil success:^(ULBaseRequest *request, NSDictionary *responseObject) {
                    [ULProgressHUD hide];
                    [ULProgressHUD showWithMsg:@"处理成功"];
                    [subscriber sendCompleted];
                } failure:^(ULBaseRequest *request, NSError *error) {
                    [ULProgressHUD hide];
                    [ULProgressHUD showWithMsg:@"请求失败"];
                    [subscriber sendCompleted];
                } withPath:@"ulab_lab/lab/labApply/status"];
                return nil;
            }];
        }];
    }
    return _agreeCommand;
}


- (RACCommand *)memberCommand    //获得实验室成员列表
{
    if (!_memberCommand)
    {
        _memberCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                [self.request getDataWithParameter:@{
                                                     @"labId" : input
                                                     }session:YES progress:nil success:^(ULBaseRequest *request, NSDictionary *responseObject) {
                                                         NSMutableArray *memberArray = [NSMutableArray array];
                                                         if ([responseObject[@"data"] class] != [NSNull class])
                                                         {
                                                             for (NSDictionary *memberDic in responseObject[@"data"])
                                                             {
                                                                 ULLabMemberModel *model = [[ULLabMemberModel alloc] init];
                                                                 [model yy_modelSetWithDictionary:memberDic];
                                                                 [memberArray addObject:model];
                                                             }
                                                         }
                                                         
                                                         [self.memberSubject sendNext:memberArray];
                                                         [subscriber sendCompleted];
                                                     } failure:^(ULBaseRequest *request, NSError *error) {
                                                         [subscriber sendError:error];
                                                         [subscriber sendCompleted];
                                                     } withPath:@"ulab_lab/lab/users"];
                return nil;
            }];
            
        }];
    }
    return _memberCommand;
}

- (RACCommand *)friendCommand
{
    if (!_friendCommand)
    {
        @weakify(self)
        _friendCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self)
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                [self.request getDataWithParameter:@{
                                                     @"labId" : @([ULUserMgr sharedMgr].laboratoryId)
                                                     }session:YES progress:nil success:^(ULBaseRequest *request, NSDictionary *responseObject) {
                                                         NSMutableArray *labArray = [NSMutableArray array];
                                                         if ([responseObject[@"data"] class] != [NSNull class])
                                                         {
                                                             for (NSDictionary *labDic in responseObject[@"data"])
                                                             {
                                                                 ULLabModel *model = [[ULLabModel alloc] init];
                                                                 [model yy_modelSetWithDictionary:labDic];
                                                                 [labArray addObject:model];
                                                             }
                                                         }
                                                         [self.friendSubject sendNext:labArray];
                                                         [subscriber sendNext:labArray];
                                                         [subscriber sendCompleted];
                                                     } failure:^(ULBaseRequest *request, NSError *error) {
                                                         [subscriber sendError:error];
                                                         [subscriber sendCompleted];
                                                     } withPath:@"ulab_lab/lab/friendlyLabs"];
                return nil;
            }];
            
        }];
        
    }
    return _friendCommand;
}

- (RACCommand *)addMemberCommand             //添加实验室申请列表
{
    if (!_addMemberCommand)
    {
        @weakify(self)
        _addMemberCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self)
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                [self.request getDataWithParameter:@{
                                                     @"labId" : @([ULUserMgr sharedMgr].laboratoryId)
                                                     }session:YES progress:nil success:^(ULBaseRequest *request, NSDictionary *responseObject) {
                                                         [ULProgressHUD hide];
                                                         NSLog(@"%@",responseObject);
                                                         NSMutableArray *memberArray = [NSMutableArray array];
                                                         if ([responseObject[@"data"] class] != [NSNull class])
                                                         {
                                                             for (NSDictionary *memberDic in responseObject[@"data"])
                                                             {
                                                                 ULLabMemberModel *model = [[ULLabMemberModel alloc] init];
                                                                 
                                                                 [model yy_modelSetWithDictionary:memberDic[@"user"]];
                                                                 model.applyId = memberDic[@"id"];
                                                                 if ([memberDic[@"status"] isKindOfClass:[NSString class]]) {
                                                                     model.menberStatus = @(-1);
                                                                 }else{
                                                                     model.menberStatus = memberDic[@"status"];
                                                                 }
                                                                 
                                                                 [memberArray addObject:model];
                                                             }
                                                         }
                                                         
                                                         [self.addMemberSubject sendNext:memberArray];
                                                         [subscriber sendCompleted];
                                                     } failure:^(ULBaseRequest *request, NSError *error) {
                                                         [ULProgressHUD hide];
                                                         [ULProgressHUD showWithMsg:@"请求失败"];
                                                         [subscriber sendCompleted];
                                                     } withPath:@"ulab_lab/lab/labApplies"];
                return nil;
            }];
            
        }];
    }
    return _addMemberCommand;
}

- (RACCommand *)friendDealCommand     //
{
    if (!_friendDealCommand)
    {
        @weakify(self)
        _friendDealCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self)
                [self.request postDataWithParameter:input
                                            session:YES progress:nil success:^(ULBaseRequest *request, NSDictionary *responseObject) {
                                                [ULProgressHUD hide];
                                                [subscriber sendCompleted];
                                            } failure:^(ULBaseRequest *request, NSError *error) {
                                                [ULProgressHUD hide];
                                                [ULProgressHUD showWithMsg:@"请求失败"];
                                                [subscriber sendCompleted];
                                            } withPath:@"ulab_lab/lab/friendlyApply/status"];
                return nil;
            }];
        }];
    }
    return _friendDealCommand;
}

- (RACCommand *)applyFriendCommand
{
    if (!_applyFriendCommand)
    {
        @weakify(self)
        _applyFriendCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self)
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                [self.request getDataWithParameter:@{@"labId":@([ULUserMgr sharedMgr].laboratoryId)} session:YES progress:nil success:^(ULBaseRequest *request, NSDictionary *responseObject) {
                    NSMutableArray *labArray = [NSMutableArray array];
                    if ([responseObject[@"data"] class] != [NSNull class])
                    {
                        for (NSDictionary *labDic in responseObject[@"data"])
                        {
                            NSDictionary *dic = labDic[@"srcLaboratory"];
                            ULLabModel *model = [[ULLabModel alloc] init];
                            [model yy_modelSetWithDictionary:dic];
                            model.labID = [labDic[@"id"] integerValue];
                            if ([labDic[@"status"] integerValue] != 0&&[labDic[@"status"] integerValue] != 1) {
                                model.applyStatus = -1;
                            }else{
                                model.applyStatus = [labDic[@"status"] integerValue];
                            }
                            [labArray addObject:model];
                        }
                    }
                    [self.applyFriendSubject sendNext:labArray];
                    [subscriber sendNext:labArray];
                    [subscriber sendCompleted];
                } failure:^(ULBaseRequest *request, NSError *error) {
                    [subscriber sendError:error];
                    [subscriber sendCompleted];
                } withPath:@"ulab_lab/lab/friendlyApplies"];
                return nil;
            }];
            
        }];
        
    }
    return _applyFriendCommand;
}

- (RACCommand *)changeCommand
{
    if (!_changeCommand)
    {
        @weakify(self)
        _changeCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self)
                [self.request postDataWithParameter:input session:YES progress:nil success:^(ULBaseRequest *request, NSDictionary *responseObject) {
                    
                    [self.changeSubject sendNext:nil];
                    [subscriber sendCompleted];
                } failure:^(ULBaseRequest *request, NSError *error) {
                    [ULProgressHUD showWithMsg:@"请求失败"];
                    [subscriber sendCompleted];
                } withPath:@"ulab_lab/lab/info"];
                return nil;
            }];
        }];
    }
    return _changeCommand;
}

- (RACSubject *)changeSubject{
    if (!_changeSubject) {
        _changeSubject = [RACSubject subject];
    }
    return _changeSubject;
}

@end
