//
//  ULView.m
//  U-Lab
//
//  Created by 周维康 on 17/5/17.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULView.h"
#import "ULAppDelegate.h"

@implementation ULView

- (instancetype)init
{
    if (self = [super init])
    {
        [self ul_setupViews];
        [self ul_bindViewModel];
    }
    return self;
}

- (instancetype)initWithViewModel:(id<ULViewProtocol>)viewModel
{
    if (self = [super init])
    {
        [self ul_setupViews];
        [self ul_bindViewModel];
    }
    return self;
}

- (void)ul_bindViewModel
{
    
}

- (void)ul_setupViews
{
    
}

- (void)ul_addReturnKeyBoard
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [tap.rac_gestureSignal subscribeNext:^(id x) {
        ULAppDelegate *delegate = (ULAppDelegate *)[[UIApplication sharedApplication] delegate];
        [delegate.window endEditing:YES];
    }];
    [self addGestureRecognizer:tap];
}
@end
