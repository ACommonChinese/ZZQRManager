//
//  SecondViewController.m
//  ZZQRManager
//
//  Created by 刘威振 on 2/3/16.
//  Copyright © 2016 LiuWeiZhen. All rights reserved.
//

#import "SecondViewController.h"
#import "ZZQRManager.h"

@interface SecondViewController ()

@property (weak, nonatomic) IBOutlet UITextField *inputField;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (weak, nonatomic) IBOutlet UIImageView *resultImageView;

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"使用ZZQRManager";
    [self setUp];
}

- (void)setUp {
    // For generate qr-code image
    self.inputField.rightViewMode = UITextFieldViewModeAlways;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(0, 0, 100, 45);
    [button setTitle:@"generate" forState:UIControlStateNormal];
     button.backgroundColor = [UIColor colorWithRed:0 green:128.0/256 blue:128/256.0 alpha:1.0];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(generateQRCode:) forControlEvents:UIControlEventTouchUpInside];
    self.inputField.rightView = button;
    
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
}

- (IBAction)scan:(id)sender {
    ZZQRScanViewController *controller = [[ZZQRScanViewController alloc] init];
    //[controller setResultHandler:nil];
    [controller setModalPresentationStyle:UIModalPresentationFullScreen];
    [controller setResultHandler:^(ZZQRScanViewController *controller, NSString *result) {
        [controller dismissViewControllerAnimated:YES completion:^{
            self.resultLabel.text = result;
        }];
    }];
    controller.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)generateQRCode:(id)sender {
    self.resultImageView.image = [ZZQRImageHelper generateBarcode2ImageWithStr:self.inputField.text size:self.resultImageView.frame.size.width];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

@end
