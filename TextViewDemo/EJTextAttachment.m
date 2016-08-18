//
//  EJTextAttachment.m
//  TextViewDemo
//
//  Created by 花花 on 16/8/13.
//  Copyright © 2016年 花花. All rights reserved.
//

#import "EJTextAttachment.h"

@implementation EJTextAttachment

- (CGRect)attachmentBoundsForTextContainer:(NSTextContainer *)textContainer proposedLineFragment:(CGRect)lineFrag glyphPosition:(CGPoint)position characterIndex:(NSUInteger)charIndex {
//    CGFloat attachmentWidth = CGRectGetWidth(lineFrag) - textContainer.lineFragmentPadding *2;
    CGFloat factor =50/self.image.size.width;
    
    return CGRectMake(0, 0, self.image.size.width*factor, self.image.size.height*factor);
}

@end
