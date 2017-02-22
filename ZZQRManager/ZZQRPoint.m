//
//  ZZQRPoint.m
//  ZZQRManager
//
//  Created by 刘威振 on 2/8/16.
//  Copyright © 2016 LiuWeiZhen. All rights reserved.
//

#import "ZZQRPoint.h"

@implementation ZZQRPoint


- (CGPoint)cgPoint {
    return CGPointMake(self.x, self.y);
}

- (ZZQRPoint *)initWithCGPoint:(CGPoint)cgPoint {
    if (self = [super init]) {
        self.x = cgPoint.x;
        self.y = cgPoint.y;
    }
    return self;
}

+ (NSArray<ZZQRPoint *> *)pointsWithRect:(CGRect)rect {
    ZZQRPoint *point_0  = [[ZZQRPoint alloc] initWithCGPoint:rect.origin];
    ZZQRPoint *point_1  = [[ZZQRPoint alloc] initWithCGPoint:CGPointMake(rect.origin.x, CGRectGetMaxY(rect))];
    ZZQRPoint *point_2  = [[ZZQRPoint alloc] initWithCGPoint:CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect))];
    ZZQRPoint *point_3  = [[ZZQRPoint alloc] initWithCGPoint:CGPointMake(CGRectGetMaxX(rect), rect.origin.y)];
    return @[point_0, point_1, point_2, point_3];
}

+ (NSArray<ZZQRPoint *> *)pointsWithCorners:(NSArray *)points {
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:points.count];
    for (id obj in points) {
        CGPoint p;
        CGPointMakeWithDictionaryRepresentation((CFDictionaryRef)obj, &p);
        ZZQRPoint *point = [[ZZQRPoint alloc] initWithCGPoint:p];
        [arr addObject:point];
    }
    return arr;
}

- (ZZQRPoint *)addPoint:(ZZQRPoint *)point {
    self.x += point.x;
    self.y += point.y;
    return self;
}

@end
