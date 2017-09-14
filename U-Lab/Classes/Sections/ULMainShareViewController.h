//
//  ULMainShareViewController.h
//  ULab
//
//  Created by 周维康 on 2017/6/13.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULViewController.h"

typedef NS_ENUM(NSUInteger, ULShareObjectType) {
    ULShareObjectTypeMaterial = 1,
    ULShareObjectTypeReagent = 2,
    ULShareObjectTypeAnimal = 3,
    ULShareObjectTypeLab = 4,
    ULShareObjectTypeOther = 5
};
@interface ULMainShareViewController : ULViewController

- (instancetype)initWithShareType:(ULShareObjectType)shareType;

@end
