//
//  ZZQRPlaceholderView.h
//  ZZQRManager
//
//  Created by 刘威振 on 2017/2/21.
//  Copyright © 2017年 LiuWeiZhen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QRRefreshView : UIView

@property (nonatomic, strong, readonly) UIButton *refreshButton;
@property (nonatomic, strong, readonly) UIButton *backButton;

+ (QRRefreshView *)getRefreshView;
@end

typedef enum : NSUInteger {
    ZZQRPlaceholderViewModeNone      = 0, // 自定义contentView
    ZZQRPlaceholderViewModeIndicator = 1, // 风火轮
    ZZQRPlaceholderViewModeRefresh   = 2  // 触屏重新开始
} ZZQRPlaceholderViewMode;

@interface ZZQRPlaceholderView : UIView

@property (nonatomic) UIView *contentView;

- (void)show;
- (void)showWithMode:(ZZQRPlaceholderViewMode)mode;

- (void)dismiss;
- (void)dismissWithCompletion:(dispatch_block_t)completion;
@end
