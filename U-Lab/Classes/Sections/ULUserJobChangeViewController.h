//
//  ULUserJobChangeViewController.h
//  ULab
//
//  Created by 周维康 on 2017/6/23.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULViewController.h"
@class ULUserJobModel;

@interface ULUserJobChangeViewController : ULViewController

- (instancetype)initWithJob:(ULUserJobModel *)job andType:(NSInteger)type;
- (instancetype)initWithUserId:(NSInteger)userId andType:(NSInteger)type;

@end
