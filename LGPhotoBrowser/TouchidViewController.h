//
//  TouchidViewController.h
//  LGPhotoBrowser
//
//  Created by hanwenjing on 2016/7/17.
//  Copyright © 2016年 L&G. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ViewController;
@protocol touchIdDelegate <NSObject>

-(void)showPics;

@end
@interface TouchidViewController : UIViewController

@property(nonatomic,weak)  id<touchIdDelegate>delegate;
@property(nonatomic,copy)  NSString *fromPage ;
@end
