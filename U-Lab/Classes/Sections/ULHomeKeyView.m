//
//  OLHomeKeyView.m
//  U-Lab
//
//  Created by 周维康 on 17/5/19.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULHomeKeyView.h"

@interface ULHomeKeyView()

@property (nonatomic, strong) NSMutableArray *buttonArray;  /**< 按钮数组 */

@end
@implementation ULHomeKeyView
{
    NSArray *_colorArray;
}

- (void)reloadData{
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    self.buttonArray = [NSMutableArray arrayWithCapacity:self.keyArray.count];
    for (int i=0; i<self.keyArray.count; i++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self setButton:button WithKey:self.keyArray[i]];
        [self addSubview:button];
        [self.buttonArray addObject:button];
    }
    [self updateConstraints];
}


- (void)ul_bindViewModel
{
    self.touchSubject = [RACSubject subject];
}
- (instancetype)initWithKeyArray:(NSArray *)keyArray
{
    self.keyArray = [NSMutableArray array];
    [self.keyArray addObjectsFromArray:keyArray];
    _colorArray = @[[UIColor colorWithRGBHex:0xFF833E], [UIColor colorWithRGBHex:0x84E5BD], [UIColor colorWithRGBHex:0xC684EC], [UIColor colorWithRGBHex:0xF58888], [UIColor colorWithRGBHex:0x83DD92], [UIColor colorWithRGBHex:0x999999]];
    if (self = [super init])
    {
    }
    return self;
}

- (void)updateConstraints
{
    NSInteger totalWidth = 15;
    NSInteger line = 0;
    for (int i=0 ;i<self.keyArray.count; i++)
    {
        UIButton *button = self.buttonArray[i];
        NSDictionary *attrs = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:kStandardPx(24)]};
        CGSize size=[_keyArray[i] sizeWithAttributes:attrs];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(totalWidth);
            make.top.equalTo(self).offset(line*30);
            make.size.mas_equalTo(CGSizeMake(size.width+30, 22));
        }];
        totalWidth = totalWidth+size.width+30+5;
        CGSize nextSize;
        if (i!=self.keyArray.count-1)
        {
            nextSize = [_keyArray[i+1] sizeWithAttributes:attrs];
        } else {
            nextSize = CGSizeZero;
        }
        if (totalWidth+nextSize.width > [UIApplication sharedApplication].keyWindow.frame.size.width-30)
        {
            line++;
            totalWidth = 15;
        }
    }
    [super updateConstraints];
}
- (void)ul_setupViews
{
    self.buttonArray = [NSMutableArray arrayWithCapacity:self.keyArray.count];
    for (int i=0; i<self.keyArray.count; i++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self setButton:button WithKey:self.keyArray[i]];
        [self addSubview:button];
        [self.buttonArray addObject:button];
    }
    [self updateConstraintsIfNeeded];
    [self setNeedsUpdateConstraints];
}

- (void)setButton:(UIButton *)button WithKey:(NSString *)key
{
    [button setTitle:key forState:UIControlStateNormal];
    NSInteger colorIndex = arc4random()%5;
    button.titleLabel.font = kFont(kStandardPx(24));
    [button setTitleColor:_colorArray[colorIndex] forState:UIControlStateNormal];
    button.backgroundColor = kCommonWhiteColor;
    button.layer.cornerRadius = kStandardPx(22);
    button.layer.masksToBounds = YES;
    button.layer.borderWidth = 0.5;
    button.layer.borderColor = kCommonLightGrayColor.CGColor;
    [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self.touchSubject sendNext:key];
    }];
}
@end
