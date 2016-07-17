//
//  ViewController.m
//  LGPhotoBrowser
//
//  Created by ligang on 15/10/27.
//  Copyright (c) 2015年 L&G. All rights reserved.
//

#import "ViewController.h"
//#import "LGPhoto.h"
#define HEADER_HEIGHT 100
#import "SandBoxHandle.h"
#import "TouchidViewController.h"

@interface ViewController ()<LGPhotoPickerViewControllerDelegate,LGPhotoPickerBrowserViewControllerDataSource,LGPhotoPickerBrowserViewControllerDelegate, UITableViewDataSource,UITableViewDelegate,touchIdDelegate>

@property (nonatomic, weak) IBOutlet UITableView *myTableView;
@property (nonatomic, copy) NSArray *titleArray;
@property (nonatomic, strong)NSMutableArray *LGPhotoPickerBrowserPhotoArray;
@property (nonatomic, strong)NSMutableArray *LGPhotoPickerBrowserURLArray;
@property (nonatomic, assign) LGShowImageType showType;
- (IBAction)BarButtonClicked:(UIBarButtonItem *)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.view.backgroundColor=[UIColor colorWithRed:1/255.0 green:150/255.0 blue:255/255 alpha:1];
     self.titleArray = [[NSArray alloc] init];
    self.titleArray = @[@"照片浏览器",@"网络图片浏览器",@"单张拍照",@"手动连拍"];
    
  }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [self showMessage:@"MemoryWarninh!!!"];

}

/**
 *  给照片浏览器传image的时候先包装成LGPhotoPickerBrowserPhoto对象
 */
- (void)prepareForPhotoBroswerWithImage {
    
    //从沙盒目录取data 转成数组
    NSString *f = [SandBoxHandle fullpathOfFilename:@"mypicArr"];
    NSData*arrdata=[NSData dataWithContentsOfFile:f];
     NSArray*arr= [NSKeyedUnarchiver unarchiveObjectWithData:arrdata];//可以还原为原本的数组格式。
     NSLog(@"%@",arr);

    if(arr.count>0){
        
    self.LGPhotoPickerBrowserPhotoArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < arr.count; i++) {
        LGPhotoPickerBrowserPhoto *photo = [[LGPhotoPickerBrowserPhoto alloc] init];
        photo.photoImage =  arr[i];
        [self.LGPhotoPickerBrowserPhotoArray addObject:photo];
    }
        [self pushPhotoBroswerWithStyle:LGShowImageTypeImageBroswer];

    }else{
        [self showMessage:@"暂无照片。。。"];
    }
}

 /**
 *  初始化相册选择器
 */
- (void)presentPhotoPickerViewControllerWithStyle:(LGShowImageType)style {
    LGPhotoPickerViewController *pickerVc = [[LGPhotoPickerViewController alloc] initWithShowType:style];
    pickerVc.status = PickerViewShowStatusCameraRoll;
    pickerVc.maxCount = 9;   // 最多能选9张图片
    pickerVc.delegate = self;
    self.showType = style;
    [pickerVc showPickerVc:self];
}

/**
 *  初始化图片浏览器
 */
- (void)pushPhotoBroswerWithStyle:(LGShowImageType)style{
    LGPhotoPickerBrowserViewController *BroswerVC = [[LGPhotoPickerBrowserViewController alloc] init];
    BroswerVC.delegate = self;
    BroswerVC.dataSource = self;
    BroswerVC.showType = style;
    self.showType = style;
    [self presentViewController:BroswerVC animated:NO completion:nil];
}

/**
 *  初始化自定义相机（单拍）
 */
- (void)presentCameraSingle {
    ZLCameraViewController *cameraVC = [[ZLCameraViewController alloc] init];
    // 拍照最多个数
    cameraVC.maxCount = 1;
    // 单拍
    cameraVC.cameraType = ZLCameraSingle;
    cameraVC.callback = ^(NSArray *cameras){
        //在这里得到拍照结果
        //数组元素是ZLCamera对象
        /*
         @exemple
         ZLCamera *canamerPhoto = cameras[0];
         UIImage *image = canamerPhoto.photoImage;
         */
    };
    [cameraVC showPickerVc:self];
}

/**
 *  初始化自定义相机（连拍）
 */
- (void)presentCameraContinuous {
    ZLCameraViewController *cameraVC = [[ZLCameraViewController alloc] init];
    // 拍照最多个数
    cameraVC.maxCount = 4;
    // 连拍
    cameraVC.cameraType = ZLCameraContinuous;
    cameraVC.callback = ^(NSArray *cameras){
        //在这里得到拍照结果
        //数组元素是ZLCamera对象
        /*
         @exemple
            ZLCamera *canamerPhoto = cameras[0];
            UIImage *image = canamerPhoto.photoImage;
         */
    };
    [cameraVC showPickerVc:self];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.text = [self.titleArray objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 66;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    switch (indexPath.row) {
         case 0:
            
        {
            TouchidViewController *touch=[[TouchidViewController alloc]init];
            touch.delegate=self;
            [self presentViewController:touch animated:YES completion:nil ];
            break;
        }
//            [self prepareForPhotoBroswerWithImage];
//
//            [self pushPhotoBroswerWithStyle:LGShowImageTypeImageBroswer];
//            break;
        case 1:
            [self pushPhotoBroswerWithStyle:LGShowImageTypeImageURL];
            break;
        case 2:
            [self presentCameraSingle];
            break;
        case 3:
            [self presentCameraContinuous];
            break;
            
        default:
            break;
    }
}

#pragma mark - LGPhotoPickerViewControllerDelegate

- (void)pickerViewControllerDoneAsstes:(NSArray *)assets isOriginal:(BOOL)original{
   // /*
    //assets的元素是LGPhotoAssets对象，获取image方法如下:
    NSMutableArray *thumbImageArray = [NSMutableArray array];
    NSMutableArray *originImage = [NSMutableArray array];
    NSMutableArray *fullResolutionImage = [NSMutableArray array];
    
    for (LGPhotoAssets *photo in assets) {
        //缩略图
        [thumbImageArray addObject:photo.thumbImage];
        //原图
        [originImage addObject:photo.originImage];
        //全屏图
        [fullResolutionImage addObject:photo.fullResolutionImage];
         NSLog(@"photo==%@",photo);
    }
  //  */
//    
//    NSLog(@"thumbImageArray==%@",thumbImageArray);
//    NSLog(@"originImage==%@",originImage);
//    NSLog(@"fullResolutionImage==%@",fullResolutionImage);
//    
//    NSInteger num = (long)assets.count;
//    NSString *isOriginal = original? @"YES":@"NO";
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"发送图片" message:[NSString stringWithFormat:@"您选择了%ld张图片\n是否原图：%@",(long)num,isOriginal] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
//    [alertView show];

    
    //读取沙盒目录 对比用
    
    NSString *f = [SandBoxHandle fullpathOfFilename:@"mypicArr"];
    NSData*arrdata=[NSData dataWithContentsOfFile:f];
    NSArray*arr= [NSKeyedUnarchiver unarchiveObjectWithData:arrdata];//可以还原为原本的数组格式。
    
    //合并数组
    for (int i = 0; i<[arr count]; i++)
    {
        if (![originImage containsObject:[arr objectAtIndex:i]] )
        {
            [originImage addObject:[arr objectAtIndex:i]];
        }
    }

    //写入沙盒目录

    NSData *imageData = [NSKeyedArchiver archivedDataWithRootObject:originImage];
    BOOL isSucceed=[SandBoxHandle savedData:imageData FileUrl:@"mypicArr"];
 
    NSString *message= isSucceed ? @"保存成功":@"保存失败";
    [self showMessage:message];
    
    //读取沙盒目录 检查是否保存成功

    [self readFromSandbox];
    

 }
-(void)readFromSandbox{
    
    NSString *fs = [SandBoxHandle fullpathOfFilename:@"mypicArr"];
    NSData*arrdatas=[NSData dataWithContentsOfFile:fs];
    
    NSArray*arrs= [NSKeyedUnarchiver unarchiveObjectWithData:arrdatas];//可以还原为原本的数组格式。
    
    NSLog(@"%@",arrs);

}
#pragma mark - LGPhotoPickerBrowserViewControllerDataSource

- (NSInteger)photoBrowser:(LGPhotoPickerBrowserViewController *)photoBrowser numberOfItemsInSection:(NSUInteger)section{if (self.showType == LGShowImageTypeImageBroswer) {
        return self.LGPhotoPickerBrowserPhotoArray.count;
    } else if (self.showType == LGShowImageTypeImageURL) {
        return self.LGPhotoPickerBrowserURLArray.count;
    } else {
        NSLog(@"非法数据源");
        return 0;
    }
}

- (id<LGPhotoPickerBrowserPhoto>)photoBrowser:(LGPhotoPickerBrowserViewController *)pickerBrowser photoAtIndexPath:(NSIndexPath *)indexPath{
    if (self.showType == LGShowImageTypeImageBroswer) {
        return [self.LGPhotoPickerBrowserPhotoArray objectAtIndex:indexPath.item];
    } else if (self.showType == LGShowImageTypeImageURL) {
        return [self.LGPhotoPickerBrowserURLArray objectAtIndex:indexPath.item];
    } else {
        NSLog(@"非法数据源");
        return nil;
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

- (IBAction)BarButtonClicked:(UIBarButtonItem *)sender {
    
    [self presentPhotoPickerViewControllerWithStyle:LGShowImageTypeImagePicker];

}
-(void)showPics{
    
                [self prepareForPhotoBroswerWithImage];
    

}
@end
