//
//  FontSet.m
//  TextViewDemo
//
//  Created by 花花 on 16/8/8.
//  Copyright © 2016年 花花. All rights reserved.
//

#import "FontSet.h"

@implementation FontSet

- (instancetype)init {
    if (self = [super init]) {
        
        _isBold = NO;
        _isUnderline = NO;
        _isImg = NO;
        _color = [UIColor blackColor];
        _fontSize = 15;
        _startLocation = 0;
        _endLocation = 0;
        _content = @"";
        _attribute = [[NSAttributedString alloc]initWithString:@""];
    }
    
    return self;
}

- (void)setIsImg:(BOOL)isImg {
    _isImg = isImg;
    if (_isImg) {
        if (!self.imgArr) {
            self.imgArr = [[NSMutableArray alloc]init];
        }
    }
    
}

@end
