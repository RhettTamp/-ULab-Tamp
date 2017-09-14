//
//  ULMainShareSelectViewController.h
//  ULab
//
//  Created by 周维康 on 2017/6/13.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULViewController.h"

typedef NS_ENUM(NSInteger, ULMainShareSelectType)
{
    ULMainShareSelectTypeFriend = 1,
    ULMainShareSelectTypeLab = 0
};

@interface ULMainShareSelectViewController : ULViewController
@property (nonatomic, strong) RACSubject *popSubject;  /**< pop */
@property (nonatomic, strong) NSMutableArray *resultArray;  /**< array */
- (instancetype)initWithSelectType:(ULMainShareSelectType)selectType;

@end
