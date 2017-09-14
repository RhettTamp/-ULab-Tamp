//
//  ULStack.m
//  ULab
//
//  Created by 谭培 on 2017/7/20.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULQueueTool.h"

@interface ULQueueTool ()

@property (nonatomic,strong) NSMutableArray *array;

@end

@implementation ULQueueTool

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.array = [NSMutableArray array];
    }
    return self;
}



- (void)enQueue:(id)object{
    [self.array addObject:object];
    for (NSInteger i = self.array.count; i > 0; i--) {
        self.array[i] = self.array[i-1];
    }
    self.array[0] = object;
}

- (void)deQueue{
    id object = self.array[self.array.count];
    [self.array removeObject:object];
}

- (NSArray *)getQueue{
    return [self.array copy];
}

@end
