//
//  ULUserJobModel.h
//  U-Lab
//
//  Created by 周维康 on 2017/6/7.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ULUserJobModel : NSObject

@property (nonatomic, assign) NSInteger jobId;  /**< 工作id  */
@property (nonatomic, copy) NSString *jobTitle;  /**< 工作标题 */
@property (nonatomic, copy) NSString *jobTime;  /**< 工作时间 */
@property (nonatomic, copy) NSString *jobContent;  /**< 工作内容 */
@property (nonatomic, assign) NSInteger userId;  /**< 用户id  */
@property (nonatomic,strong) NSString *username; /**< 用户名 */

@end
