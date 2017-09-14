//
//  ULUserOrderViewModel.m
//  U-Lab
//
//  Created by 周维康 on 17/5/30.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULUserOrderViewModel.h"
#import "ULUserOrderModel.h"

@interface ULUserOrderViewModel()

@end
@implementation ULUserOrderViewModel

- (void)ul_initialize
{
    self.orderSubject = [RACSubject subject];
    self.agreeySubject = [RACSubject subject];
}

- (RACCommand *)orderCommand
{
    if (!_orderCommand)
    {
        _orderCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                [self.request getDataWithParameter:input session:YES progress:nil success:^(ULBaseRequest *request, NSDictionary *responseObject) {
                    NSMutableArray *objectArray = [NSMutableArray array];
                    if ([responseObject[@"data"] class] != [NSNull class])
                    {
                        for (NSDictionary *objectDic in responseObject[@"data"])
                        {
                            ULUserOrderModel *model = [[ULUserOrderModel alloc] init];
                            [model yy_modelSetWithDictionary:objectDic];
                            if ([input[@"type"] integerValue] == 0) {
                                model.imageURL = objectDic[@"user"][@"headImage"];
                                model.orderName = objectDic[@"item"][@"name"];
                                model.itemType = [objectDic[@"item"][@"type"] integerValue];
                            }else{
                                if (objectDic[@"user"]&&![objectDic[@"user"] isKindOfClass:[NSNull class]]) {
                                    if (![objectDic[@"user"][@"headImage"] isKindOfClass:[NSNull class]]) {
                                        model.imageURL = objectDic[@"user"][@"headImage"];
                                    }
                                    
                                    model.orderName = objectDic[@"item"][@"name"];
                                    model.itemType = [objectDic[@"item"][@"type"] integerValue];
                                }
                                
                            }
                            
                            [objectArray addObject:model];
                        }
                    }
                    NSDictionary *resultDic = @{@"type" : input[@"type"],
                                                @"response" : objectArray};
                    [ULProgressHUD hide];
                    [self.orderSubject sendNext:resultDic];
                    [subscriber sendCompleted];
                } failure:^(ULBaseRequest *request, NSError *error) {
                    [ULProgressHUD hide];
                    [self.orderSubject sendError:error];
                    [subscriber sendCompleted];
                } withPath:@"ulab_user/users/orders"];
                
                return nil;
            }];
        }];
    }
    return _orderCommand;
}

- (RACCommand *)agreeCommand
{
    if (!_agreeCommand)
    {
        _agreeCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                [self.request postDataWithParameter:input session:YES progress:nil success:^(ULBaseRequest *request, NSDictionary *responseObject) {
                    [ULProgressHUD hide];
                    [subscriber sendNext:nil];
                    
                    [subscriber sendCompleted];
                } failure:^(ULBaseRequest *request, NSError *error) {
                    [ULProgressHUD hide];
                    [ULProgressHUD showWithMsg:@"请求失败"];
                    [subscriber sendCompleted];
                } withPath:@"ulab_item/item/itemOrder/status"];
                
                return nil;
            }];
        }];
    }
    return _agreeCommand;
}

@end
