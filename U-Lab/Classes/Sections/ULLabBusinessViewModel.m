//
//  ULLabBusinessViewModel.m
//  ULab
//
//  Created by 周维康 on 2017/6/15.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULLabBusinessViewModel.h"

@implementation ULLabBusinessViewModel

- (RACCommand *)getCommand
{
    if (!_getCommand)
    {
        @weakify(self)
        _getCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self)
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                [self.request getDataWithParameter:input session:YES progress:nil success:^(ULBaseRequest *request, NSDictionary *responseObject) {
                    [ULProgressHUD hide];
                    [self.nextSubject sendNext:responseObject[@"data"]];
                    
                    [subscriber sendCompleted];
                } failure:^(ULBaseRequest *request, NSError *error) {
                    [ULProgressHUD hide];
                    [self.nextSubject sendNext:nil];
                    [subscriber sendCompleted];
                } withPath:@"ulab_lab/lab/financial"];
                return nil;
            }];
            
        }];
    }
    return _getCommand;
}

- (RACCommand *)detailCommand
{
    if (!_detailCommand)
    {
        @weakify(self)
        _detailCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self)
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                [self.request getDataWithParameter:input session:YES progress:nil success:^(ULBaseRequest *request, NSDictionary *responseObject) {
                    [ULProgressHUD hide];
                    [self.detailSubject sendNext:responseObject[@"data"]];
                    [subscriber sendCompleted];
                } failure:^(ULBaseRequest *request, NSError *error) {
                    [ULProgressHUD hide];
                    [ULProgressHUD showWithMsg:@"请求失败"];
                    [subscriber sendCompleted];
                } withPath:@"ulab_lab/lab/financial/detail"];
                return nil;
            }];
            
        }];
    }
    return _detailCommand;
}

- (RACSubject *)nextSubject{
    if (!_nextSubject) {
        _nextSubject = [[RACSubject alloc]init
                        ];
    }
    return _nextSubject;
}

- (RACSubject *)detailSubject{
    if (!_detailSubject) {
        _detailSubject = [[RACSubject alloc]init];
    }
    return _detailSubject;
}

@end
