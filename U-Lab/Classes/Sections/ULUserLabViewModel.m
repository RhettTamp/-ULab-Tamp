//
//  ULUserLabViewModel.m
//  U-Lab
//
//  Created by 周维康 on 17/5/31.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULUserLabViewModel.h"
#import "ULUserLabModel.h"
#import "ULUserProjectModel.h"

@implementation ULUserLabViewModel

//@synthesize request = _request;
//
////请求管理
//- (ULBaseRequest *)request
//{
//    if (!_request)
//    {
//        _request = [[ULBaseRequest alloc] init];
//        _request.isJson = YES;
//    }
//    return _request;
//}

- (void)ul_initialize
{
    self.addSubject = [RACSubject subject];
    self.updateSubject = [RACSubject subject];
    self.getSubject = [RACSubject subject];
}

- (RACCommand *)addCommand
{
    if (!_addCommand)
    {
        @weakify(self)
        _addCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self)
                self.request.isJson = YES;
                [self.request postDataWithParameter:@[input] session:YES progress:nil success:^(ULBaseRequest *request, NSDictionary *responseObject) {
                    [ULProgressHUD hide];
                    [self.addSubject sendNext:input];
                    [subscriber sendCompleted];
                } failure:^(ULBaseRequest *request, NSError *error) {
                    [ULProgressHUD hide];
                    NSLog(@"%@",error);
                    [ULProgressHUD showWithMsg:@"请求失败"];
                    [subscriber sendCompleted];
                } withPath:@"ulab_user/users/experiment"];
                return nil;
            }];
        }];
    }
    return _addCommand;
}

- (RACCommand *)updateCommand
{
    if (!_updateCommand)
    {
        @weakify(self)
        _updateCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self)
                self.request.isJson = YES;
                [self.request patchDataWithParameter:input session:YES success:^(ULBaseRequest *request, NSDictionary *responseObject) {
                    [ULProgressHUD hide];
                    [self.updateSubject sendNext:responseObject];
                    [subscriber sendCompleted];
                } failure:^(ULBaseRequest *request, NSError *error) {
                    [ULProgressHUD hide];
                    [self.updateSubject sendError:error];
                    [subscriber sendCompleted];
                } withPath:@"ulab_user/users/experiment"];
                return nil;
            }];
        }];
    }
    return _updateCommand;
}

- (RACCommand *)getCommand
{
    if (!_getCommand)
    {
        @weakify(self)
        _getCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self)
                [self.request getDataWithParameter:nil session:YES progress:nil success:^(ULBaseRequest *request, NSDictionary *responseObject) {
                    NSMutableArray *projectArray = [NSMutableArray array];
                    if ([responseObject[@"data"] class] != [NSNull class])
                    {
                        for (NSDictionary *projectDic in responseObject[@"data"])
                        {
                            ULUserProjectModel *model = [[ULUserProjectModel alloc] init];
                            [model yy_modelSetWithDictionary:projectDic];
                            NSMutableArray *labArray = [NSMutableArray array];
                            for (NSDictionary *labDic in projectDic[@"experimentList"])
                            {
                                ULUserLabModel *labModel = [[ULUserLabModel alloc] init];
                                [labModel yy_modelSetWithDictionary:labDic];
                                [labArray addObject:labModel];
                            }
                            model.labArray = labArray;
                            [projectArray addObject:model];
                        }
                    }
                    [ULProgressHUD hide];
                    [self.getSubject sendNext:projectArray];
                    [subscriber sendCompleted];
                } failure:^(ULBaseRequest *request, NSError *error) {
                    [ULProgressHUD hide];
                    [self.getSubject sendError:error];
                    [subscriber sendCompleted];
                } withPath:@"ulab_user/users/projects"];
                return nil;
            }];
        }];
    }
    return _getCommand;
}

- (RACCommand *)deleteCommand
{
    if (!_deleteCommand)
    {
        @weakify(self)
        _deleteCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self)
                [self.request deleteDataWithParameter:input session:YES success:^(ULBaseRequest *request, NSDictionary *responseObject) {
                    [ULProgressHUD hide];
                    [subscriber sendNext:nil];
                    [subscriber sendCompleted];
                } failure:^(ULBaseRequest *request, NSError *error) {
                    [ULProgressHUD hide];
                    [ULProgressHUD showWithMsg:@"删除失败"];
                    [subscriber sendCompleted];
                } withPath:@"ulab_user/users/project"];
                return nil;
            }];
        }];
    }
    return _deleteCommand;
}

- (RACCommand *)addProjectCommand
{
    if (!_addProjectCommand)
    {
        @weakify(self)
        _addProjectCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self)
                [self.request postDataWithParameter:input session:YES progress:nil success:^(ULBaseRequest *request, NSDictionary *responseObject) {
                    [ULProgressHUD hide];
                    [subscriber sendNext:responseObject];
                    [subscriber sendCompleted];
                } failure:^(ULBaseRequest *request, NSError *error) {
                    [ULProgressHUD hide];
                    [ULProgressHUD showWithMsg:[error localizedDescription]];
                    
                    [subscriber sendCompleted];
                } withPath:@"ulab_user/users/project"];
                return nil;
            }];
        }];
    }
    return _addProjectCommand;
}
@end
