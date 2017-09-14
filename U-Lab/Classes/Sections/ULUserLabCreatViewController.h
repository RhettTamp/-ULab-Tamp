//
//  ULUserLabCreatViewController.h
//  U-Lab
//
//  Created by 周维康 on 2017/6/3.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULViewController.h"
@class ULUserLabModel;
@interface ULUserLabCreatViewController : ULViewController

@property (nonatomic, strong) RACSubject *popSubject;  /**< 返回信号 */
- (instancetype)initWithLabModel:(ULUserLabModel *)model projectId:(NSNumber *)projectId;
@property (nonatomic, assign) BOOL isEdit;  /**< 是否是便是  */
@end
