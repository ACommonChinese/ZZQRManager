//
//  ZZQRPlaceholderView.m
//  ZZQRManager
//
//  Created by 刘威振 on 2017/2/21.
//  Copyright © 2017年 LiuWeiZhen. All rights reserved.
//

#import "ZZQRPlaceholderView.h"

@interface QRRefreshView ()

@property (nonatomic, strong, readwrite) UIButton *refreshButton;
@property (nonatomic, strong, readwrite) UIButton *backButton;
@end

@implementation QRRefreshView
@synthesize refreshButton = _refreshButton;

+ (QRRefreshView *)getRefreshView {
    CGRect frame         = [[[UIApplication sharedApplication] keyWindow] bounds];
    QRRefreshView *view  = [[QRRefreshView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor blackColor];
    view.refreshButton   = [UIButton buttonWithType:UIButtonTypeSystem];
    view.refreshButton.frame = view.bounds;
    [view addSubview:view.refreshButton];
    
    UILabel *label          = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 100)];
    label.center            =  CGPointMake(CGRectGetMidX(view.refreshButton.bounds), CGRectGetMidY(view.refreshButton.bounds));
    label.font              = [UIFont systemFontOfSize:22.0f];
    label.numberOfLines     = 0;
    label.textAlignment     = NSTextAlignmentCenter;
    label.textColor         = [UIColor whiteColor];
    label.text              = @"未检测到二维码/条形码\n\n点击重新扫描";
    [view addSubview:label];
    
    view.backButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [view.backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [view.backButton setTitle:@"返回" forState:UIControlStateNormal];
    [view.backButton.titleLabel setFont:[UIFont systemFontOfSize:18.0]];
    view.backButton.frame = CGRectMake(0, 20, 60, 50);
    [view addSubview:view.backButton];
    
    return view;
}

@end

////////////////////////////////////////////////////////////////////////

@interface ZZQRPlaceholderView ()

@property (nonatomic) CGRect originFrame;
@end

@implementation ZZQRPlaceholderView

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:[[UIScreen mainScreen] bounds]];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.0f];
}

- (void)show {
    NSAssert(self.contentView, @"The contentView must not be nil");
    NSAssert(self.contentView.frame.size.width == self.bounds.size.width, @"The contentView's width must be same as window");
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    CGRect frame           = self.contentView.frame;
    self.originFrame       = frame;
    frame.origin.y         = self.bounds.size.height;
    self.contentView.frame = frame;
    [self addSubview:self.contentView];
    [UIView animateWithDuration:0.25 animations:^{
        self.contentView.frame = self.originFrame;
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5f];
    } completion:^(BOOL finished) {}];
}

- (void)showWithMode:(ZZQRPlaceholderViewMode)mode {
    switch (mode) {
        case ZZQRPlaceholderViewModeIndicator:
            self.contentView = [self getPlaceholderView];
            break;
        case ZZQRPlaceholderViewModeRefresh:
            self.contentView = [self getRefreshView];
            break;
        default:
            break;
    }
    [self show];
}

- (UIView *)getPlaceholderView {
    CGRect frame         = [[[UIApplication sharedApplication] keyWindow] bounds];
    UIView *view         = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor clearColor];
    UIActivityIndicatorView *indicatorView   = [[UIActivityIndicatorView alloc] init];
    indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    indicatorView.center = CGPointMake(CGRectGetMidX(view.bounds), CGRectGetMidY(view.bounds));
    [indicatorView startAnimating];
    [view addSubview:indicatorView];
    return view;
}

- (UIView *)getRefreshView {
    QRRefreshView *refreshView = [QRRefreshView getRefreshView];
    return refreshView;
}

- (void)dismiss {
    [self dismissWithCompletion:nil];
}

- (void)dismissWithCompletion:(dispatch_block_t)completion {
    [UIView animateWithDuration:0.25 animations:^{
        CGRect frame = self.originFrame;
        frame.origin.y = self.bounds.size.height;
        self.contentView.frame = frame;
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.0f];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (completion) {
            completion();
        }
    }];
}

@end
