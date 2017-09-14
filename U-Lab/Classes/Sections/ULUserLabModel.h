//
//  ULUserLabModel.h
//  U-Lab
//
//  Created by 周维康 on 2017/6/6.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ULUserLabModel : NSObject

@property (nonatomic, assign) NSInteger labId;  /**< 实验ID  */
@property (nonatomic, copy) NSString *labName;  /**< 实验名称 */
@property (nonatomic, copy) NSString *labMain;  /**< 实验要点 */
@property (nonatomic, copy) NSString *labDifficult;  /**< 实验难点 */
@property (nonatomic, copy) NSString *labIntro;  /**< 实验介绍 */
@property (nonatomic, copy) NSString *labTime;  /**< 实验时间 */
@property (nonatomic, strong) NSNumber *projectId;  /**< <#comment#> */
@property (nonatomic, strong) NSNumber *userId;  /**< <#comment#> */
@end
