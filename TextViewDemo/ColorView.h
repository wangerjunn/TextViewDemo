//
//  ColorView.h
//  TextViewDemo
//
//  Created by 花花 on 16/8/9.
//  Copyright © 2016年 花花. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ResultBlock)(NSInteger iden);
@interface ColorView : UIView

@property (copy,nonatomic) ResultBlock resultBlock;

- (instancetype)initColorViewByTitleArr:(NSArray *)titleArr rect:(CGRect)rect isColor:(BOOL)isColor resultBlock:(ResultBlock)resultBlock;

@end
