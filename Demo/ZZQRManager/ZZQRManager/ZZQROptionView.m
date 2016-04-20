//
//  ZZQROptionView.m
//  ZZQRManager
//
//  Created by 刘威振 on 2/4/16.
//  Copyright © 2016 LiuWeiZhen. All rights reserved.
//

#import "ZZQROptionView.h"

@interface ZZQROptionView ()

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttons;

@end

@implementation ZZQROptionView

- (IBAction)decodeQRImage:(UIButton *)button {
    if (self.callbackHandler) {
        self.callbackHandler(button, [self.buttons indexOfObject:button]);
    }
}

- (IBAction)lightOn:(UIButton *)button {
    button.selected = !button.selected;
    if (self.callbackHandler) {
        self.callbackHandler(button, [self.buttons indexOfObject:button]);
    }
}

- (IBAction)cancel:(UIButton *)button {
    if (self.callbackHandler) {
        self.callbackHandler(button, [self.buttons indexOfObject:button]);
    }
}

- (void)dealloc {
    // NSLog(@"内存没有问题");
    // NSLog(@"%s", __func__);
}

@end
