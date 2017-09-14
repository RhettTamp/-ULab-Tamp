 //
//  ULUserObjectViewModel.m
//  U-Lab
//
//  Created by 周维康 on 17/5/29.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULUserObjectViewModel.h"
#import "ULUserObjectModel.h"

@implementation ULUserObjectViewModel

- (void)ul_initialize
{
    self.objectSubject = [RACSubject subject];
}

- (RACCommand *)objectCommand
{
    if (!_objectCommand)
    {
        _objectCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                [self.request getDataWithParameter:input session:YES progress:nil success:^(ULBaseRequest *request, NSDictionary *responseObject) {
                    NSLog(@"%@",responseObject);
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
                    NSDictionary *resultDic = @{@"type" : input[@"type"],
                                                @"response" : objectArray};
                    [ULProgressHUD hide];
                    [self.objectSubject sendNext:resultDic];
                    [subscriber sendCompleted];
    
                } failure:^(ULBaseRequest *request, NSError *error) {
                    [ULProgressHUD hide];
                    [self.objectSubject sendError:error];
                    [subscriber sendCompleted];
                } withPath:@"ulab_user/users/items"];

                return nil;
            }];
        }];
    }
    return _objectCommand;
}
@end
