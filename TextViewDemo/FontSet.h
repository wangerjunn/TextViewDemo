//
//  FontSet.h
//  TextViewDemo
//
//  Created by 花花 on 16/8/8.
//  Copyright © 2016年 花花. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface FontSet : NSObject

@property (assign,nonatomic) BOOL isImg;//是否是图片
@property (assign,nonatomic) BOOL isBold;//是否加粗
@property (assign,nonatomic) BOOL isUnderline;//是否包含下划线
@property (assign,nonatomic) UIColor* color;//文字颜色
@property (assign,nonatomic) CGFloat fontSize;//字号
@property (assign,nonatomic) NSUInteger startLocation;//开始位置
@property (assign,nonatomic) NSUInteger endLocation;
@property (copy,nonatomic) NSString *content;//内容
@property (copy,nonatomic) NSAttributedString *attribute;
@property (strong, nonatomic) NSMutableArray *imgArr;//保存图片
@property (assign,nonatomic) NSUInteger imageLocation;//图片位置
@end
