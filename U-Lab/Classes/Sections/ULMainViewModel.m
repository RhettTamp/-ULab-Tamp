//
//  ULMainViewModel.m
//  ULab
//
//  Created by 周维康 on 2017/6/15.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULMainViewModel.h"
#import "ULUserObjectModel.h"

@implementation ULMainViewModel

- (RACCommand *)searchCommand
{
    if (!_searchCommand)
    {
        _searchCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
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
                    
                    [subscriber sendNext:objectArray];
                    [subscriber sendCompleted];
                    
                } failure:^(ULBaseRequest *request, NSError *error) {
                    [ULProgressHUD hide];
                    [ULProgressHUD showWithMsg:@"请求失败"];
                    [subscriber sendCompleted];
                } withPath:@"ulab_item/item/search"];
                
                return nil;
            }];
        }];
    }
    return _searchCommand;
}
@end
