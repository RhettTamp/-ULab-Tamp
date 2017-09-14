//
//  ULLabDetailViewController.h
//  ULab
//
//  Created by 周维康 on 2017/6/18.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULViewController.h"
@class ULLabModel;
@interface ULLabDetailViewController : ULViewController

@property (nonatomic, strong) ULLabModel *model;  /**< model */
- (instancetype)initWithStatus:(NSInteger)status labModel:(ULLabModel *)model;
@end
