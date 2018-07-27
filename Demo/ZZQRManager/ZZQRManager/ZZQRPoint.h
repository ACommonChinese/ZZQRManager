//
//  ZZQRPoint.h
//  ZZQRManager
//
//  Created by 刘威振 on 2/8/16.
//  Copyright © 2016 LiuWeiZhen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ZZQRPoint : NSObject

@property (nonatomic) double x;
@property (nonatomic) double y;

- (CGPoint)cgPoint;
- (ZZQRPoint *)initWithCGPoint:(CGPoint)cgPoint;
+ (NSArray<ZZQRPoint *> *)pointsWithRect:(CGRect)rect;
+ (NSArray<ZZQRPoint *> *)pointsWithCorners:(NSArray *)points;
//+ (CGPoint *)cgPointsWithPoints:(NSArray<ZZQRPoint *> *)points;
//+ (NSArray<ZZQRPoint *> *)pointsWithCGPoints:(CGPoint *)cgPoints;

- (ZZQRPoint *)addPoint:(ZZQRPoint *)point;
@end
