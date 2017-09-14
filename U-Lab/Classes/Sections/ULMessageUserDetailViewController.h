//
//  ULMessageUserDetailViewController.h
//  ULab
//
//  Created by 周维康 on 2017/6/11.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULViewController.h"
@class ULLabMemberModel;
@interface ULMessageUserDetailViewController : ULViewController

- (instancetype)initWithUser:(JMSGUser *)user;
- (instancetype)initWithModel:(ULLabMemberModel *)model  andType:(NSInteger)type;
@end
