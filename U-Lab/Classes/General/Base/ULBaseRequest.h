//
//  ULBaseRequest.h
//  U-Lab
//
//  Created by 周维康 on 17/5/17.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ULBaseRequest : NSObject

@property (nonatomic,assign) BOOL isJson;

- (void)postDataWithParameter:(id)parameter session:(BOOL)hasSession
                    progress:(void (^)(NSProgress * pregress))downloadProgress
                     success:(void (^)(ULBaseRequest * request, NSDictionary *responseObject))success
                     failure:(void (^)(ULBaseRequest * request, NSError * error))failure withPath:(NSString *)path;

- (void)getDataWithParameter:(NSDictionary *)parameter session:(BOOL)hasSession
                    progress:(void (^)(NSProgress * progress))downloadProgress
                     success:(void (^)(ULBaseRequest * request, NSDictionary *responseObject))success
                     failure:(void (^)(ULBaseRequest * request, NSError * error))failure withPath:(NSString *)path;

- (void)patchDataWithParameter:(NSDictionary *)parameter session:(BOOL)hasSession
                       success:(void (^)(ULBaseRequest * request, NSDictionary *responseObject))success
                       failure:(void (^)(ULBaseRequest * request, NSError * error))failure withPath:(NSString *)path;

- (void)deleteDataWithParameter:(NSDictionary *)parameter session:(BOOL)hasSession
                        success:(void (^)(ULBaseRequest * request, NSDictionary *responseObject))success
                        failure:(void (^)(ULBaseRequest * request, NSError * error))failure withPath:(NSString *)path;
@end
