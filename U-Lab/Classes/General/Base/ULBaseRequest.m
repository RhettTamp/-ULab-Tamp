//
//  ULBaseRequest.m
//  U-Lab
//
//  Created by 周维康 on 17/5/17.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULBaseRequest.h"

static const NSString *baseURL = @"http://47.92.133.141/";

@interface ULBaseRequest()

@property (nonatomic, strong) AFHTTPSessionManager *manager;  /**< 请求 */

@end

@implementation ULBaseRequest

- (AFHTTPSessionManager *)manager
{
    if (!_manager)
    {
        _manager = [AFHTTPSessionManager manager];
    }
    return _manager;
}
- (void)postDataWithParameter:(id)parameter session:(BOOL)hasSession
                     progress:(void (^)(NSProgress * progress))downloadProgress
                      success:(void (^)(ULBaseRequest * request, NSDictionary *responseObject))success
                      failure:(void (^)(ULBaseRequest * request, NSError * error))failure withPath:(NSString *)path
{
    if (hasSession)
    {
        [self.manager.requestSerializer setValue:[ULKeychainTool load:@"user_session"] forHTTPHeaderField:@"Cookie"];
    }else{
        NSURL *url = [NSURL URLWithString:@"http://47.92.133.141/ulab_user/users/session"];
        if (url) {
            NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:url];
            for (int i = 0; i < [cookies count]; i++) {
                NSHTTPCookie *cookie = (NSHTTPCookie *)[cookies objectAtIndex:i];
                [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
                
            }
        }
//        [self.manager.requestSerializer setValue:nil forHTTPHeaderField:@"Cookie"];
    }
    if (_isJson) {
        self.manager.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    
    //2.发送请求
    NSString *urlString = [NSString stringWithFormat:@"%@%@", baseURL, path];
    [self.manager POST:urlString parameters:parameter progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([path  isEqual: @"ulab_user/users/session"])
        {
            NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
            NSArray *array = [NSHTTPCookie cookiesWithResponseHeaderFields:[response allHeaderFields] forURL:[NSURL URLWithString:urlString]];
            NSDictionary *requestFields = [NSHTTPCookie requestHeaderFieldsWithCookies:array];
            NSLog(@"%@",[requestFields objectForKey:@"Cookie"]);
            NSLog(@"%@",[NSHTTPCookieStorage sharedHTTPCookieStorage].cookies);
            NSLog(@"%@",[ULKeychainTool load:@"user_session"]);
            if ([requestFields objectForKey:@"Cookie"]&&![[requestFields objectForKey:@"Cookie"] isKindOfClass:[NSNull class]]) {
                [ULKeychainTool save:@"user_session" data:[requestFields objectForKey:@"Cookie"]];
            }
//            NSLog(@"%@---%@",[ULKeychainTool load:@"user_session"],[NSHTTPCookieStorage sharedHTTPCookieStorage].cookies);
//            if (array.count!=0)
//            {
//                NSLog(@"%@",array[0]);
//                [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:array[0]];
//            }
        }
        success(self, responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(self, error);
    }];
}

- (void)patchDataWithParameter:(NSDictionary *)parameter session:(BOOL)hasSession
                       success:(void (^)(ULBaseRequest * request, NSDictionary *responseObject))success
                       failure:(void (^)(ULBaseRequest * request, NSError * error))failure withPath:(NSString *)path
{

    if (hasSession)
    {
        [self.manager.requestSerializer setValue:[ULKeychainTool load:@"user_session"] forHTTPHeaderField:@"Cookie"];
        
    }
    NSString *urlString = [NSString stringWithFormat:@"%@%@", baseURL, path];
    [self.manager PATCH:urlString parameters:parameter success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(self, responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(self, error);
    }];
}

- (void)getDataWithParameter:(NSDictionary *)parameter session:(BOOL)hasSession
                    progress:(void (^)(NSProgress * progress))downloadProgress
                     success:(void (^)(ULBaseRequest * request, NSDictionary *responseObject))success
                     failure:(void (^)(ULBaseRequest * request, NSError * error))failure withPath:(NSString *)path
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@", baseURL, path];

    if (hasSession)
    {
        [self.manager.requestSerializer setValue:[ULKeychainTool load:@"user_session"] forHTTPHeaderField:@"Cookie"];
    }
    [self.manager GET:urlString parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(self, responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(self, error);
    }];
}

- (void)deleteDataWithParameter:(NSDictionary *)parameter session:(BOOL)hasSession
                        success:(void (^)(ULBaseRequest * request, NSDictionary *responseObject))success
                        failure:(void (^)(ULBaseRequest * request, NSError * error))failure withPath:(NSString *)path
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@", baseURL, path];
    if (hasSession)
    {
        [self.manager.requestSerializer setValue:[ULKeychainTool load:@"user_session"] forHTTPHeaderField:@"Cookie"];
    }
    [self.manager DELETE:urlString parameters:parameter success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(self, responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(self, error);
    }];
}
@end
