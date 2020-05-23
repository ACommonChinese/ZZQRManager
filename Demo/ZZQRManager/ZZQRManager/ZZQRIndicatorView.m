//
//  ZZQRIndicatorView.m
//  ZZQRManager
//
//  Created by 刘威振 on 2/8/16.
//  Copyright © 2016 LiuWeiZhen. All rights reserved.
//

#import "ZZQRIndicatorView.h"

#define FPS 60

@interface ZZQRIndicatorView ()

/**
 *  刷新屏幕, FPS: 60
 */
@property (nonatomic) CADisplayLink *link;

/**
 *  步进量数组
 */
@property (nonatomic) NSMutableArray *stepPoints;

/**
 *  临界值
 */
@property (nonatomic) double criticalValue;

/**
 *  步进量总值，如果步进量超过临界值，停止
 */
@property (nonatomic) double stepTotalValue;

/**
 *  动画视图，不断的扩大和缩小
 */
@property (nonatomic) UIView *animationView;

@property (nonatomic) NSArray<ZZQRPoint *> *fromPoints;
@property (nonatomic) NSArray<ZZQRPoint *> *toPoints;
@property (nonatomic, copy) void (^lockInCompletion)(NSString *str);
@end

@implementation ZZQRIndicatorView

- (double)duration {
    if (!_duration) {
        _duration = 0.25;
    }
    return _duration;
}

// Only override drawRect: if you perform custom drawing.
- (void)drawRect:(CGRect)rect {
    if (self.fromPoints == nil || self.fromPoints.count != self.toPoints.count) {
        return;
    }
    NSUInteger count = self.fromPoints.count;
    CGPoint cgPointArr[count];
    for (NSUInteger i = 0; i < count; i++) {
        ZZQRPoint *stepPoint = self.stepPoints[i];
        if (i == 0) {
            self.stepTotalValue += fabs(stepPoint.x);
        }
        cgPointArr[i] = [[self.fromPoints[i] addPoint:stepPoint] cgPoint];
        // NSLog(@"%lf %lf", cgPointArr[i].x, cgPointArr[i].y);
    }
    
    CGContextRef ctf = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(ctf, [[UIColor whiteColor] CGColor]);
    CGContextSetLineWidth(ctf, 2.0);
    CGContextAddLines(ctf, cgPointArr, count);
    CGContextClosePath(ctf);
    CGContextStrokePath(ctf);
    
    if (self.stepTotalValue >=  self.criticalValue) {
        // self.link.paused = YES;
        [self.link invalidate];
        [self performSelector:@selector(callback) withObject:nil afterDelay:.75];
    }
}

- (void)callback {
    if (self.lockInCompletion) {
        self.lockInCompletion([self.codeObject stringValue]);
    }
}

/**
 *  search animation begin
 */
- (void)indicateStart {
    CGFloat length = self.bounds.size.width / 2;
    self.animationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, length, length)]; // ZZQRIndicatorView
    self.animationView.backgroundColor = [UIColor clearColor];
    self.animationView.center = CGPointMake(self.bounds.size.width/2.0, self.bounds.size.height/2.0);
    self.animationView.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.animationView.layer.borderWidth = 1.0;
    [self addSubview:self.animationView];
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    scaleAnimation.duration     = 1.48;
    scaleAnimation.fromValue    = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)];
    scaleAnimation.toValue      = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.5, 0.5, 1.0)];
    // scaleAnimation.delegate  = self;
    scaleAnimation.autoreverses = YES;
    scaleAnimation.repeatCount  = MAXFLOAT;
    [self.animationView.layer addAnimation:scaleAnimation forKey:@"ScaleAnimationKey"];
}

- (void)indicateEnd {
    // [self.animationView.layer removeAnimationForKey:@"ScaleAnimationKey"];
    [self.animationView removeFromSuperview];
}

/**
 *  锁定目标，在二维码的周边画线
 *  扫描二维码后得到的四个角的点有可能不是一个矩形，而是一个有四条边的不规则图形
 *  AVMetadataMachineReadableCodeObject对象的corners属性是个数组，它包含了这4个点的具体坐标，我们根据这4个点的坐标把这个不规则图形画出来，这4个点的顺序如下：
 http://stackoverflow.com/questions/21712632/using-barcode-corners-to-create-cgrect
 ⚫️0-------------3⚫️
  \                |
   \               |
    \              |
     \             |
     ⚫️1----------2⚫️
 
 fromPoints                           toPoints
  ______________                       ______________
 | 0 ZZQQRPoint |     ----------->    | 0 ZZQQRPoint |
 |--------------|                     |--------------|
 | 1 ZZQQRPoint |     ----------->    | 1 ZZQQRPoint |
 |--------------|                     |--------------|
 | 2 ZZQQRPoint |     ----------->    | 2 ZZQQRPoint |
 |--------------|                     |--------------|
 | 3 ZZQQRPoint |     ----------->    | 3 ZZQQRPoint |
 '--------------'                     '--------------'
 
 */
- (void)indicateLockInWithCompletion:(void (^)(NSString *str))completion {
    self.lockInCompletion = completion;
    
    self.fromPoints = [ZZQRPoint pointsWithRect:self.animationView.frame];
    [self.animationView removeFromSuperview];
    self.toPoints = [ZZQRPoint pointsWithCorners:self.codeObject.corners];
    // NSLog(@"barcode type：%@", self.codeObject.type);
    // po self.codeObject
    // one-dimensional barcode example 1：
    // <AVMetadataMachineReadableCodeObject: 0x1456bca0, type="org.iso.Code128", bounds={ 41.3,284.2 231.9x1.5 }>corners { 41.3,284.2 41.3,285.8 273.1,285.8 273.1,284.2 }, time 13928009860958, stringValue "1234567890123"
    // one-dimensional barcode example 2：
    // <AVMetadataMachineReadableCodeObject: 0x1658eb10, type="org.iso.Code128", bounds={ 82.0,265.7 172.6x31.9 }>corners { 82.0,296.1 82.3,297.5 254.6,267.1 254.3,265.7 }, time 14118918735416, stringValue "1234567890123"
    // two-dimensional barcode example 1：：
    // <AVMetadataMachineReadableCodeObject: 0x15ebc4f0, type="org.iso.QRCode", bounds={ 131.8,239.8 118.4x111.0 }>corners { 144.0,239.8 131.8,339.0 233.0,350.8 250.3,252.4 }, time 13743881148500, stringValue "hanguanghui"
    // 取临界值
    self.criticalValue = fabs(self.toPoints[0].x - self.fromPoints[0].x);
    NSInteger count = self.fromPoints.count;
    if (count != self.toPoints.count) {
        @throw [NSException exceptionWithName:NSStringFromSelector(_cmd) reason:@"起始点和终点个数不匹配" userInfo:nil];
    }
    self.stepPoints = [NSMutableArray arrayWithCapacity:count];
    for (NSInteger i = 0; i < count; i++) {
        ZZQRPoint *fromPoint = self.fromPoints[i];
        ZZQRPoint *toPoint   = self.toPoints[i];
        // 1秒60次刷新 FPS: 60
        CGPoint cgPoint      = CGPointMake((toPoint.x - fromPoint.x)/(self.duration*FPS), (toPoint.y - fromPoint.y)/(self.duration*FPS));
        ZZQRPoint *stepPoint = [[ZZQRPoint alloc] initWithCGPoint:cgPoint]; // 步进量
        self.stepPoints[i]   = stepPoint;
    }
    self.link = [CADisplayLink displayLinkWithTarget:self selector:@selector(setNeedsDisplay)];
    [self.link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)dealloc {
    // NSLog(@"%s", __func__);
}

@end




