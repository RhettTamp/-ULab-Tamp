//
//  ULMessageOrderViewModel.m
//  ULab
//
//  Created by 周维康 on 2017/6/15.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULMessageOrderViewModel.h"
#import "ULUserObjectModel.h"
#import "ULUserOrderModel.h"

@implementation ULMessageOrderViewModel

- (void)ul_initialize
{
    self.objectSubject = [RACSubject subject];
    self.lendSubject = [RACSubject subject];
    self.inSubject = [RACSubject subject];
}

- (RACCommand *)agreeCommand
{
    if (!_agreeCommand)
    {
        _agreeCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                [self.request postDataWithParameter:input session:YES progress:nil success:^(ULBaseRequest *request, NSDictionary *responseObject) {
                    [subscriber sendNext:nil];
                    [subscriber sendCompleted];
                } failure:^(ULBaseRequest *request, NSError *error) {
                    [ULProgressHUD showWithMsg:@"请求失败"];
                    [subscriber sendCompleted];
                } withPath:@"ulab_item/item/buyOrders"];
                
                return nil;
            }];
        }];
    }
    return _agreeCommand;
}

- (RACCommand *)getCommand  //购买申请
{
    if (!_getCommand)
    {
        @weakify(self)
        _getCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self)
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                [self.request getDataWithParameter:input session:YES progress:nil success:^(ULBaseRequest *request, NSDictionary *responseObject) {
                    NSMutableArray *objectArray = [NSMutableArray array];
                    if ([responseObject[@"data"] class] != [NSNull class])
                    {
                        if ([input[@"status"] integerValue] == 1) {
                            for (NSDictionary *objectDic in responseObject[@"data"])
                            {
                                ULUserObjectModel *model = [[ULUserObjectModel alloc] init];
                                [model yy_modelSetWithDictionary:objectDic];
                                if (model.amount == 0) {
                                    model.objectType = [objectDic[@"itemType"] integerValue];
                                    model.objectName = objectDic[@"itemName"];
                                    model.imageURL = objectDic[@"applicantUser"][@"headImage"];
                                    model.userName = objectDic[@"applicantName"];[objectArray addObject:model];
                                    model.userLabName = objectDic[@"applicantUser"][@"laboratoryName"];
                                    [objectArray addObject:model];
                                }
                                
                            }
                        }else{
                            for (NSDictionary *objectDic in responseObject[@"data"])
                            {
                                ULUserObjectModel *model = [[ULUserObjectModel alloc] init];
                                [model yy_modelSetWithDictionary:objectDic];                                                                         model.objectType = [objectDic[@"itemType"] integerValue];
                                model.objectName = objectDic[@"itemName"];
                                model.imageURL = objectDic[@"applicantUser"][@"headImage"];
                                model.userName = objectDic[@"applicantName"];
                                model.userLabName = objectDic[@"applicantUser"][@"laboratoryName"];           [objectArray addObject:model];
                                
                                
                                
                            }
                        }
                    }
                    [self.objectSubject sendNext:@{@"response":objectArray,@"status":input[@"status"]}];
                    [subscriber sendCompleted];
                } failure:^(ULBaseRequest *request, NSError *error) {
                    [subscriber sendCompleted];
                } withPath:@"ulab_item/item/buyOrders"];
                
                return nil;
            }];
        }];
    }
    return _getCommand;
}

- (RACCommand *)getLendCommand
{
    if (!_getLendCommand)
    {
        _getLendCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                [self.request getDataWithParameter:input session:YES progress:nil success:^(ULBaseRequest *request, NSDictionary *responseObject) {
                    NSMutableArray *objectArray = [NSMutableArray array];
                    if ([responseObject[@"data"] class] != [NSNull class])
                    {
                        for (NSDictionary *objectDic in responseObject[@"data"])
                        {
                            ULUserOrderModel *model = [[ULUserOrderModel alloc] init];
                            [model yy_modelSetWithDictionary:objectDic];
                            if (objectDic[@"user"] && ![objectDic[@"user"] isKindOfClass:[NSNull class]]) {
                                if (![objectDic[@"user"][@"headImage"] isKindOfClass:[NSNull class]]) {
                                    model.imageURL = objectDic[@"user"][@"headImage"];
                                }
                            }
                            
                            model.orderName = objectDic[@"item"][@"name"];
                            model.itemType = [objectDic[@"item"][@"type"] integerValue];
                            [objectArray addObject:model];
                        }
                    }
                    NSDictionary *resultDic = @{@"type" : input[@"type"],
                                                @"response" : objectArray};
                    [self.lendSubject sendNext:resultDic];
                    [subscriber sendCompleted];
                } failure:^(ULBaseRequest *request, NSError *error) {
                    [self.lendSubject sendError:error];
                    [subscriber sendCompleted];
                } withPath:@"ulab_user/users/orders"];
                
                return nil;
            }];
        }];
    }
    return _getLendCommand;
}

- (RACCommand *)inCommand
{
    if (!_inCommand)
    {
        _inCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                [self.request getDataWithParameter:input session:YES progress:nil success:^(ULBaseRequest *request, NSDictionary *responseObject) {
                    NSMutableArray *objectArray = [NSMutableArray array];
                    if ([responseObject[@"data"] class] != [NSNull class])
                    {
                        for (NSDictionary *objectDic in responseObject[@"data"])
                        {
                            ULUserObjectModel *model = [[ULUserObjectModel alloc] init];
                            [model yy_modelSetWithDictionary:objectDic];
                            [objectArray addObject:model];
                        }
                    }
                    [self.inSubject sendNext:objectArray];
                    [subscriber sendCompleted];
                } failure:^(ULBaseRequest *request, NSError *error) {
                    [self.inSubject sendError:error];
                    [subscriber sendCompleted];
                } withPath:@"ulab_user/users/items"];
                
                return nil;
            }];
        }];
    }
    return _inCommand;
}


@end
