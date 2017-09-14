//
//  ULLabModel.h
//  U-Lab
//
//  Created by 周维康 on 17/5/31.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ULLabModel : NSObject

@property (nonatomic, assign) NSInteger labID;  /**< 实验室ID */
@property (nonatomic, strong) NSString *labName;  /**< 实验室名字 */
@property (nonatomic, strong) NSString *labLocation;  /**< 实验室地点 */
@property (nonatomic, strong) NSString *labIntroduction;  /**< 实验室介绍 */
@property (nonatomic, strong) NSString *labResearch;  /**< 实验室研究方向 */
@property (nonatomic, strong) NSString *labSetTime;  /**< 实验室成立时间 */
@property (nonatomic, strong) NSString *labImage;  /**< 实验室图片 */
@property (nonatomic, strong) NSNumber *piId;  /**< piId */
@property (nonatomic, strong) NSString *piName;  /**< piId */
@property (nonatomic, strong) NSNumber *labMoney;
@property (nonatomic, assign) NSInteger applyStatus;

@end
