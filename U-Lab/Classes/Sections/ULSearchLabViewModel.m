//
//  ULSearchLabViewModel.m
//  U-Lab
//
//  Created by 周维康 on 17/5/31.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULSearchLabViewModel.h"
#import "ULLabModel.h"

@implementation ULSearchLabViewModel

- (RACCommand *)searchCommand
{
    if (!_searchCommand)
    {
        @weakify(self)
        _searchCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                    @strongify(self)
                [self.request getDataWithParameter:@{
                                                     @"name" : input
                                                     }
                                           session:YES progress:nil success:^(ULBaseRequest *request, NSDictionary *responseObject) {
                                               NSLog(@"%@",responseObject);
                                               NSMutableArray *labArray = [NSMutableArray array];
                                               if ([responseObject[@"errCode"] integerValue] == 0)
                                               {
                                                   for (NSDictionary *labDic in responseObject[@"data"])
                                                   {
                                                       ULLabModel *model = [[ULLabModel alloc] init];
                                                       [model yy_modelSetWithDictionary:labDic];
                                                       [labArray addObject:model];
                                                   }
                                               }
                                               
                                               [subscriber sendNext:labArray];
                                               [subscriber sendCompleted];
                                           } failure:^(ULBaseRequest *request, NSError *error) {
                                               [subscriber sendError:error];
                                               [subscriber sendCompleted];
                                           } withPath:@"ulab_lab/labs"];
                return nil;
            }];
        }];
    }
    return _searchCommand;
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
                    [ULProgressHUD hide];
//                    [ULUserMgr sharedMgr].laboratoryId = [input[@"labId"] integerValue];
                    [ULProgressHUD showWithMsg:@"申请成功"];
                    [self.addSubject sendNext:responseObject];
                    [subscriber sendCompleted];
                } failure:^(ULBaseRequest *request, NSError *error) {
                    [ULProgressHUD hide];
                    [ULProgressHUD showWithMsg:@"请求失败"];
                    [subscriber sendCompleted];
                } withPath:@"ulab_lab/lab/labApply"];
                return nil;
            }];
        }];
    }
    return _addCommand;
}

- (RACCommand *)addFriendCommand
{
    if (!_addFriendCommand)
    {
        @weakify(self)
        _addFriendCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self)
                [self.request postDataWithParameter:input session:YES progress:nil success:^(ULBaseRequest *request, NSDictionary *responseObject) {
                    [ULProgressHUD hide];
                    [ULProgressHUD showWithMsg:@"申请成功"];
                    [self.addSubject sendNext:responseObject];
                    [subscriber sendCompleted];
                } failure:^(ULBaseRequest *request, NSError *error) {
                    NSLog(@"%@",error);
                    [ULProgressHUD hide];
                    [ULProgressHUD showWithMsg:@"请求失败"];
                    [subscriber sendCompleted];
                } withPath:@"ulab_lab/lab/friendlyApply"];
                return nil;
            }];
        }];
    }
    return _addFriendCommand;
}

- (RACSubject *)addSubject{
    if (!_addSubject) {
        _addSubject = [[RACSubject alloc]init];
    }
    return _addSubject;
}

@end
