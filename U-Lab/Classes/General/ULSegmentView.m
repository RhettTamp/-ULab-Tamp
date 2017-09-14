//
//  ULSegmentView.m
//  U-Lab
//
//  Created by 周维康 on 17/5/22.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULSegmentView.h"

@interface ULSegmentView() <UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *itemArray;  /**< item */
@property (nonatomic, strong) NSMutableArray *buttonArray;  /**< 按钮数组 */
@property (nonatomic, strong) NSMutableArray *lineArray;  /**< 横线 */
@property (nonatomic, strong) NSArray *viewArray;  /**< 试图数组 */
@property (nonatomic, strong) UIScrollView *scrollView;  /**< 背景滑动板 */

@end

@implementation ULSegmentView
{
    NSUInteger _selectedIndex;
}

- (void)ul_bindViewModel
{
    self.subject = [RACSubject subject];
}
- (instancetype)initWithItems:(NSArray *)items viewArray:(NSArray *)viewArray
{
    self.itemArray = [items copy];
    self.viewArray = [viewArray copy];
    _selectedIndex = 0;
    self.buttonArray = [NSMutableArray arrayWithCapacity:items.count];
    self.lineArray = [NSMutableArray arrayWithCapacity:items.count];
    if (self = [super init])
    {
        
    }
    return self;
}

- (void)ul_setupViews
{
    self.backgroundColor = [UIColor colorWithRGBHex:0xF5F6F7];
    NSInteger index;
    for (index=0; index<self.itemArray.count; index++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitleColor:[UIColor colorWithRGBHex:0x57B6EF] forState:UIControlStateSelected];
        [button setTitleColor:[UIColor colorWithRGBHex:0x666666] forState:UIControlStateNormal];
        [button setTitle:self.itemArray[index] forState:UIControlStateNormal];
        button.titleLabel.font = kFont(kStandardPx(30));
        button.backgroundColor = [UIColor clearColor];
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor colorWithRGBHex:0x57B6EF];
        line.hidden = NO;
        [self.lineArray addObject:line];
        [self.buttonArray addObject:button];
        [self addSubview:line];
        [self addSubview:button];
        [self selectIndex:_selectedIndex];
        @weakify(self)
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self)
            _selectedIndex = index;
            button.selected = !button.isSelected;
            line.hidden = !line.isHidden;
            [self selectIndex:index];
            self.scrollView.contentOffset = CGPointMake(_selectedIndex*[UIApplication sharedApplication].keyWindow.frame.size.width, 0);
            [self.subject sendNext:[NSNumber numberWithInteger:_selectedIndex]];
        }];
    }
    [self addSubview:self.scrollView];
    for (UIView *view in self.viewArray)
    {
        [self.scrollView addSubview:view];
    }
    [self updateConstraintsIfNeeded];
    [self setNeedsUpdateConstraints];
}

- (void)updateConstraints
{
    CGFloat itemWidth = [UIApplication sharedApplication].keyWindow.frame.size.width/self.itemArray.count;
    for (NSInteger index=0; index<self.buttonArray.count; index++)
    {
        UIButton *button = self.buttonArray[index];
        UIView *line = self.lineArray[index];
        NSDictionary *attrs = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:kStandardPx(30)]};
        CGSize size=[self.itemArray[index] sizeWithAttributes:attrs];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(index*itemWidth);
            make.width.mas_equalTo(itemWidth);
            make.top.equalTo(self);
            make.height.mas_equalTo(40);
        }];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(button);
            make.width.mas_equalTo(size.width);
            make.bottom.equalTo(button);
            make.height.mas_equalTo(1);
        }];
    }
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self);
        make.top.equalTo(self).offset(40);
    }];
    [self.viewArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.scrollView).offset(idx*screenWidth);
            make.width.mas_equalTo(screenWidth);
            make.top.equalTo(self.scrollView);
            make.height.mas_equalTo(screenHeight-64-40-33);
        }];
    }];
    [super updateConstraints];
}

- (void)selectIndex:(NSInteger)index
{
    for (NSInteger i=0; i<self.buttonArray.count; i++)
    {
        UIButton *button = self.buttonArray[i];
        UIView *line = self.lineArray[i];
        if (i==index)
        {
            button.selected = YES;
            line.hidden = NO;
        } else {
            button.selected = NO;
            line.hidden = YES;
        }
        
    }
}

- (UIScrollView *)scrollView
{
    if (!_scrollView)
    {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.contentSize = CGSizeMake(screenWidth*self.viewArray.count, screenHeight-64-40-33);
        _scrollView.contentOffset = CGPointMake(0, 0);
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.scrollEnabled = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.backgroundColor = kBackgroundColor;
    }
    return _scrollView;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self selectIndex:scrollView.contentOffset.x/screenWidth];
    [self.delegate segView:self didSelectedIndex:scrollView.contentOffset.x/screenWidth];
    
}
@end
