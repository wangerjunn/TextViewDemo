//
//  ColorView.m
//  TextViewDemo
//
//  Created by 花花 on 16/8/9.
//  Copyright © 2016年 花花. All rights reserved.
//

#import "ColorView.h"

@implementation ColorView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initColorViewByTitleArr:(NSArray *)titleArr
                                   rect:(CGRect)rect
                                isColor:(BOOL)isColor
                            resultBlock:(ResultBlock)resultBlock
{
    if (self = [super initWithFrame:rect]) {
        self.resultBlock = resultBlock;
     
        self.backgroundColor = [UIColor purpleColor];
        for (int i = 0; i < titleArr.count; i++) {
            UIButton *colorBtn = [[UIButton alloc]initWithFrame:CGRectMake(i*CGRectGetWidth(rect)/3.0, 0, CGRectGetWidth(rect)/3.0, CGRectGetHeight(rect))];
            colorBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            [colorBtn setTitle:titleArr[i] forState:UIControlStateNormal];
            
            if (isColor) {
                colorBtn.tag = 100+i;
            }else{
                colorBtn.tag = 1000+i;
            }
            
            [colorBtn addTarget:self
                         action:@selector(chooseColor:)
               forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:colorBtn];
            
            UIImageView *img_line = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(colorBtn.frame), 0, 1, CGRectGetHeight(colorBtn.frame))];
            img_line.backgroundColor = [UIColor whiteColor];
            [self addSubview:img_line];
        }
    }
    
    return self;
    
}

#pragma mark -- 选择颜色
- (void)chooseColor:(UIButton *)btn {
    
    if (self.resultBlock) {
        self.resultBlock(btn.tag);
    }
    UIView *superView = (UIView *)btn.superview;
    [superView removeFromSuperview];
}


@end
