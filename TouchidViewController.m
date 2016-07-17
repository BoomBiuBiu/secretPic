//
//  TouchidViewController.m
//  LGPhotoBrowser
//
//  Created by hanwenjing on 2016/7/17.
//  Copyright © 2016年 L&G. All rights reserved.
//

#import "TouchidViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "ViewController.h"
@interface TouchidViewController ()

@end

@implementation TouchidViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
         self.view.backgroundColor = [UIColor whiteColor];
//
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(authenticateUser)];
//    [self.view addGestureRecognizer:tap];

    // Do any additional setup after loading the view.
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self authenticateUser];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)authenticateUser{
    LAContext *context = [[LAContext alloc] init];
    NSError *error = nil;
    NSString *result = @"通过home键验证已有手机指纹";
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]){//支持指纹
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:result reply:^(BOOL success, NSError * _Nullable error) {
            if (success) {
                
                 dispatch_sync(dispatch_get_main_queue(), ^{
                    //Update UI in UI thread here
//                    [[[UIAlertView alloc] initWithTitle:@"wonderful!" message:@"指纹比对成功！" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil] show];
 
                     if(self.delegate&&[self.delegate respondsToSelector:@selector(showPics)]){
                         
                         [self dismissViewControllerAnimated:YES completion:^{
                             [self.delegate performSelector:@selector(showPics) withObject:nil];

                         }];
                     }
    
                });  
                
            }else{
                NSLog(@"%@",error.localizedDescription);
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    
                    [self showMessage:@"验证失败。。。"];
                    [self dismissViewControllerAnimated:YES completion:nil];
                    
                                });
                return ;

                switch (error.code) {
                    case LAErrorAuthenticationFailed:
                    {
                        [[[UIAlertView alloc] initWithTitle:@"warning!" message:@"授权失败！" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil] show];
                        
                    }
                        break;
                    case LAErrorUserCancel:
                    {
                        [[[UIAlertView alloc] initWithTitle:@"warning!" message:@"用户取消验证Touch ID！" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil] show];
                        
                    }
                        break;
                    case LAErrorUserFallback:
                    {
                        [[[UIAlertView alloc] initWithTitle:@"warning!" message:@"用户选择其他验证方式，切换主线程处理！" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil] show];
                        
                    }
                        break;
                    case LAErrorSystemCancel:
                    {
                        [[[UIAlertView alloc] initWithTitle:@"warning!" message:@"系统取消验证Touch ID！" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil] show];
                        
                    }
                        break;
                    case LAErrorPasscodeNotSet:
                    {
                        [[[UIAlertView alloc] initWithTitle:@"warning!" message:@"系统未设置密码！" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil] show];
                        
                    }
                        break;
                    case LAErrorTouchIDNotAvailable:
                    {
                        [[[UIAlertView alloc] initWithTitle:@"warning!" message:@"设备Touch ID不可用！" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil] show];
                        
                    }
                        break;
                    case LAErrorTouchIDNotEnrolled:
                    {
                        [[[UIAlertView alloc] initWithTitle:@"warning!" message:@"设备Touch ID不可用，用户未录入！" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil] show];
                        
                    }
                        break;
                    case LAErrorTouchIDLockout:
                    {
                        [[[UIAlertView alloc] initWithTitle:@"warning!" message:@"用户取消验证Touch ID！" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil] show];
                        
                    }
                        break;
                    case LAErrorAppCancel:
                    {
                        [[[UIAlertView alloc] initWithTitle:@"warning!" message:@"用户取消验证Touch ID！" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil] show];
                        
                    }
                        break;
                    case LAErrorInvalidContext:
                    {
                        [[[UIAlertView alloc] initWithTitle:@"warning!" message:@"无效的上下文！" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil] show];
                        
                    }
                        break;
                        
                    default:
                        break;
                }
            }
        }];
    }else{//不支持指纹
        [[[UIAlertView alloc] initWithTitle:@"warning!" message:@"当前手机系统不支持指纹功能，请升级系统！" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil] show];
    }
}

-(void)showMessage:(NSString *)message
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIView *showview =  [[UIView alloc]init];
    showview.backgroundColor = [UIColor blackColor];
    showview.frame = CGRectMake(1, 1, 1, 1);
    showview.alpha = 1.0f;
    showview.layer.cornerRadius = 5.0f;
    showview.layer.masksToBounds = YES;
    [window addSubview:showview];
    
    UILabel *label = [[UILabel alloc]init];
    CGSize LabelSize = [message sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(290, 9000)];
    label.frame = CGRectMake(10, 5, LabelSize.width, LabelSize.height);
    label.text = message;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = 1;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:15];
    [showview addSubview:label];
    showview.frame = CGRectMake((SCREEN_WIDTH - LabelSize.width - 20)/2, 200, LabelSize.width+20, LabelSize.height+10);
    [UIView animateWithDuration:1.9 animations:^{
        showview.alpha = 0;
    } completion:^(BOOL finished) {
        [showview removeFromSuperview];
    }];
}
@end
