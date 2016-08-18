//
//  TakePhoto.h
//  TextViewDemo
//
//  Created by 花花 on 16/8/9.
//  Copyright © 2016年 花花. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TakePhoto : NSObject <
    UIImagePickerControllerDelegate,
    UINavigationControllerDelegate,
    UIActionSheetDelegate>

+ (TakePhoto *)shareTakePhoto;

- (void)chooseOpenTheWayByView:(UIViewController *)viewController;
@end
