//
//  ULLabFriendView.h
//  U-Lab
//
//  Created by 周维康 on 2017/6/8.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULView.h"

@interface ULLabFriendView : ULView

@property (nonatomic, strong) RACSubject *nextSubject;  /**< <#comment#> */
- (void)updataViews;

@end
