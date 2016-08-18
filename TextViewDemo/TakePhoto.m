//
//  TakePhoto.m
//  TextViewDemo
//
//  Created by 花花 on 16/8/9.
//  Copyright © 2016年 花花. All rights reserved.
//

#import "TakePhoto.h"
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>

@implementation TakePhoto
{
    UIViewController *vc;
}
+ (TakePhoto *)shareTakePhoto {
    static TakePhoto *shareTakePhotoInstance = nil;
    static dispatch_once_t predicate;
    
    dispatch_once(&predicate, ^{
        shareTakePhotoInstance = [[self alloc]init];
    });
    
    return shareTakePhotoInstance;
}

- (void)chooseOpenTheWayByView:(UIViewController *)viewController {
    
    vc = viewController;
    UIActionSheet *action = [[UIActionSheet alloc]initWithTitle:@"上传头像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册上传",@"拍照", nil];
    [action showInView:[UIApplication sharedApplication].keyWindow];
}

#pragma mark -- UIActionSheetDelegate 
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"buttonIndex = %ld",(long)buttonIndex);
    if (buttonIndex == 0) {
        //相册上传
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            [self loadImagePickerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        }
        else
        {
            [self showNotiInfo];
        }
    }else if (buttonIndex == 1){
        //拍照
        //判断相机是否能够使用
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if(status == AVAuthorizationStatusAuthorized) {
            // authorized
            [self loadImagePickerWithSourceType:UIImagePickerControllerSourceTypeCamera];
            
        } else if(status == AVAuthorizationStatusDenied){
            // denied
            [self showNotiInfo];
        } else if(status == AVAuthorizationStatusRestricted){
            // restricted
            [self showNotiInfo];
        } else if(status == AVAuthorizationStatusNotDetermined){
            // not determined
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if(granted){
                    [self loadImagePickerWithSourceType:UIImagePickerControllerSourceTypeCamera];
                    
                    
                } else {
                    [self showNotiInfo];
                }
            }];
        }
    }
    
    [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
}

//  调用相机和相册库资源
- (void)loadImagePickerWithSourceType:(UIImagePickerControllerSourceType)type{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = type;
    
    picker.allowsEditing = YES;
    
    picker.delegate = self;
    [vc presentViewController:picker animated:YES completion:^{
    }];
    
}

- (void)showNotiInfo
{
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请到设置->隐私->照片->帮帮助学中打开相应权限" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
    
    [alert show];
//    AlertLabelView *alert = [[AlertLabelView alloc]initWithTitle:@"提示" content:@"请到设置->隐私->照片->帮帮助学中打开相应权限" sureText:@"知道了" ShutClick:^{
//        
//    } AndSureClick:^{
//        
//    }];
//    [alert show];
}

#pragma mark -- UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo {
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
