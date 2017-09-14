//
//  ULLabObjectViewModel.m
//  U-Lab
//
//  Created by 周维康 on 2017/6/9.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULLabObjectViewModel.h"
#import "ULUserObjectModel.h"

@implementation ULLabObjectViewModel

- (void)ul_initialize
{
    self.objectSubject = [RACSubject subject];
}
- (RACCommand *)objectCommand
{
    if (!_objectCommand)
    {
        @weakify(self)
        _objectCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self)
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
                    
                    [self.objectSubject sendNext:@{
                                           @"type" : input[@"type"],
                                           @"response" : objectArray
                                            }];
                    [ULProgressHUD hide];
                    [subscriber sendCompleted];
                } failure:^(ULBaseRequest *request, NSError *error) {
                    [ULProgressHUD hide];
                    [ULProgressHUD showWithMsg:@"请求失败"];
                    [subscriber sendCompleted];
                } withPath:@"ulab_lab/lab/items"];
                return nil;
            }];
            
        }];
    }
    return _objectCommand;
}
- (RACCommand *)detailCommand
{
    if (!_detailCommand)
    {
        @weakify(self)
        _detailCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self)
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                [self.request getDataWithParameter:input session:NO progress:nil success:^(ULBaseRequest *request, NSDictionary *responseObject) {
                    ULUserObjectModel *model;
                    if ([responseObject[@"data"] class] != [NSNull class])
                    {
                        model = [[ULUserObjectModel alloc] init];
                        [model yy_modelSetWithDictionary:responseObject];
                    }
                    
                    [subscriber sendNext:model];
              [subscriber sendCompleted];
                } failure:^(ULBaseRequest *request, NSError *error) {
                    [subscriber sendError:error];
                  [subscriber sendCompleted];
                } withPath:@"ulab_item/item"];
                return nil;
            }];
            
        }];
    }
    return _detailCommand;
}
- (RACCommand *)lendCommand
{
    if (!_lendCommand)
    {
        @weakify(self)
        _lendCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self)
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                [self.request postDataWithParameter:input session:YES progress:nil success:^(ULBaseRequest *request, NSDictionary *responseObject) {
                    [subscriber sendNext:responseObject];
            [subscriber sendCompleted];
                } failure:^(ULBaseRequest *request, NSError *error) {
                    [ULProgressHUD showWithMsg:@"请求失败"];
                    [subscriber sendCompleted];
                } withPath:@"ulab_item/item/request"];
                return nil;
            }];
            
        }];
    }
    return _lendCommand;
}
- (RACCommand *)buyCommand
{
    if (!_buyCommand)
    {
        @weakify(self)
        _buyCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self)
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                [self.request postDataWithParameter:input session:YES progress:nil success:^(ULBaseRequest *request, NSDictionary *responseObject) {
                    [ULProgressHUD hide];

                    [subscriber sendNext:responseObject];
                    [subscriber sendCompleted];
                } failure:^(ULBaseRequest *request, NSError *error) {
                    [ULProgressHUD hide];
                    [ULProgressHUD showWithMsg:@"购买失败"];
                    [subscriber sendCompleted];
                } withPath:@"ulab_item/item/application"];
                return nil;
            }];
            
        }];
    }
    return _buyCommand;
}
- (RACCommand *)inCommand
{
    if (!_inCommand)
    {
//        @weakify(self)
        _inCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
//            @strongify(self)
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                manager.requestSerializer = [AFJSONRequestSerializer serializer];
                manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];
                NSLog(@"%@--%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"user_session"],input);
                [manager.requestSerializer setValue:[ULKeychainTool load:@"user_session"] forHTTPHeaderField:@"Cookie"];
                
                NSMutableDictionary *param = [input mutableCopy];
                [param removeObjectForKey:@"itemImage"];
                [manager POST:@"http://47.92.133.141/ulab_item/item" parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                    NSData *imageData = UIImageJPEGRepresentation(input[@"itemImage"], 0.02);                    [formData appendPartWithFileData:imageData name:@"itemImage" fileName:[NSString stringWithFormat:@"image.png"] mimeType:@"image/png"];
                    NSLog(@"%@",imageData);
//                    int i = 1;
//                    for (UIImage * image in self.photoselectVC.images) {
//                        //把图片转换为二进制流
//                        NSData *imageData = UIImagePNGRepresentation(image);
//                        //按照表单格式把二进制文件写入formData表单
//                        [formData appendPartWithFileData:imageData name:@"upLoad" fileName:[NSString stringWithFormat:@"%d.png", i] mimeType:@"image/png"];
//                        
//                        i++;
                    
//                    }
                } progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                    [subscriber sendNext:responseObject];
                    [subscriber sendCompleted];
                } failure:^(NSURLSessionDataTask *task, NSError *error) {
                    [ULProgressHUD showWithMsg:@"共享失败"];
                    [subscriber sendCompleted];
                }];

                return nil;
            }];
            
        }];
    }
    return _inCommand;
}
@end
