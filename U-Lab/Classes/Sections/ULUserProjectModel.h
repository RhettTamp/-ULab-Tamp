//
//  ULUserProjectModel.h
//  U-Lab
//
//  Created by 周维康 on 2017/6/6.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ULUserProjectModel : NSObject

@property (nonatomic, copy) NSString *projectName;  /**< 项目名称 */
@property (nonatomic, copy) NSString *projectIntro;  /**< 项目介绍 */
@property (nonatomic, assign) NSInteger userId;  /**< 用户ID  */
@property (nonatomic, strong) NSArray *labArray;  /**< 实验清单 */
@property (nonatomic, strong) NSNumber *projectId;  /**< <#comment#> */
@property (nonatomic, strong) NSString *time;  /**< <#comment#> */
@end
