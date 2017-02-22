//
//  ZZQRScanTypes.h
//  ZZQRManager
//
//  Created by 刘威振 on 2017/2/22.
//  Copyright © 2017年 LiuWeiZhen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZZQRScanTypes : NSObject

+ (NSArray *)scanTypes;
+ (NSString *)barcode1FilterType; // 生成的一维码类型
+ (NSString *)barcode2FilterType; // 生成的二维码类型
@end
