//
//  ULLabObjectModel.h
//  U-Lab
//
//  Created by 周维康 on 2017/6/9.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ULLabObjectModel : NSObject

@property (nonatomic, assign) NSInteger objectId;  /**< 物品id  */
@property (nonatomic, copy) NSString *objectName;  /**< 物品名字 */
@property (nonatomic, assign) NSInteger objectType;  /**< 物品类型  */
@property (nonatomic, assign) NSInteger objectQuantity;  /**< <#comment#>  */
@property (nonatomic, copy) NSString *objectLocation;  /**< <#comment#> */
@property (nonatomic, copy) NSString *userName;  /**< <#comment#> */
@end
