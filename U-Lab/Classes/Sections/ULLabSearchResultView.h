//
//  ULLabSearchResultView.h
//  U-Lab
//
//  Created by 周维康 on 2017/6/3.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULView.h"

@interface ULLabSearchResultView : ULView

- (instancetype)initWithKey:(NSString *)key labArray:(NSArray *)array andType:(NSInteger)type;  //0是加入实验室 1是成为友好实验室
@property (nonatomic,strong) RACSubject *nextObject;

@end
