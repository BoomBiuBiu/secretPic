//
//  ViewController.h
//  LGPhotoBrowser
//
//  Created by ligang on 15/10/27.
//  Copyright (c) 2015年 L&G. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LGPhoto.h"

@interface ViewController : UIViewController

- (void)prepareForPhotoBroswerWithImage;
- (void)pushPhotoBroswerWithStyle:(LGShowImageType)style;
@end

