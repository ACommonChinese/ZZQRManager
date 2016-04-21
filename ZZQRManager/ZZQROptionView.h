//
//  ZZQROptionView.h
//  ZZQRManager
//
//  Created by 刘威振 on 2/4/16.
//  Copyright © 2016 LiuWeiZhen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZZQROptionView : UIView

@property (nonatomic, copy) void (^callbackHandler)(NSInteger index);

+ (instancetype)optionViewWithFrame:(CGRect)frame;

@end
