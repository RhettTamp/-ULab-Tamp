//
//  ULMyOrderTableViewCell.h
//  U-Lab
//
//  Created by 周维康 on 17/5/23.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULTableViewCell.h"

typedef NS_ENUM(NSInteger, ULMyOrderLendStatus)
{
    ULMyOrderLendWaiting = 0,            //等待回复
    ULMyOrderLendAgree,                  //已同意
    ULMyOrderLendReject,                 //已拒绝
    ULMyOrderLendTransport,              //运输中
    ULMyOrderLendArrive,                 //已到达
    ULMyOrderLendBack                    //已归还
};

@interface ULMyOrderTableViewCell : ULTableViewCell

- (instancetype)initWithOrderStatus:(ULMyOrderLendStatus)status reuseIdentifier:(NSString *)reuseIdentifier;

@end
