//
//  ViewController.m
//  TextViewDemo
//
//  Created by 花花 on 16/8/8.
//  Copyright © 2016年 花花. All rights reserved.
//

#import "ViewController.h"
#import "FontSet.h"
#import "ColorView.h"
#import "TakePhoto.h"
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "EJTextAttachment.h"

@interface ViewController ()<
    UITextViewDelegate,
    UIImagePickerControllerDelegate,
    UINavigationControllerDelegate,
    UIActionSheetDelegate>
{
    UITextView *tv_content;
    UIView *keyboardView;//键盘view
    
    NSMutableArray *mutableArr;
    FontSet *curFontSet;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //初始化数组
    mutableArr = [NSMutableArray arrayWithCapacity:10];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
//    CGRect rect = CGRectMake(10, 40, 300, 200);
//    NSTextContainer * textContainer = [[NSTextContainer alloc]initWithSize:CGSizeMake(rect.size.width, rect.size.height)];
//    tv_content = [[UITextView alloc]initWithFrame:rect textContainer:textContainer];
    tv_content = [[UITextView alloc]init];
    tv_content.frame = CGRectMake(10, 40, 300, 200);
    tv_content.layer.cornerRadius = 4;
    tv_content.layer.masksToBounds = YES;
    tv_content.layer.borderColor = [UIColor redColor].CGColor;
    tv_content.layer.borderWidth = 1.0;
    tv_content.delegate = self;
    
    
    [self.view addSubview:tv_content];
    
    
    //键盘view
    
    NSArray *titleArr = @[@"加粗",@"下划线",@"颜色",@"字号",@"图片"];
    
    keyboardView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    keyboardView.backgroundColor = [UIColor lightGrayColor];
    CGFloat coorX = 10;
    
    for (int i = 0; i < titleArr.count; i++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(coorX, 0, 50, keyboardView.frame.size.height);
        
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [keyboardView addSubview:btn];
        btn.tag = 100+i;
        
        [btn addTarget:self
                action:@selector(operationStringByBtn:)
      forControlEvents:UIControlEventTouchUpInside];
        
        coorX += 50+15;
    }
    
    
    tv_content.inputAccessoryView = keyboardView;
    
    
}

#pragma mark -- 操作按钮 加粗 | 下划线 | 颜色 | 字号 | 图片
- (void)operationStringByBtn:(UIButton *)btn {
    
    //结束本次操作时保存状态
    if (mutableArr.count > 0) {
        FontSet  *tmpFontSet = (FontSet*)mutableArr.lastObject;
        tmpFontSet.endLocation = tv_content.text.length;
        tmpFontSet.content = [tv_content.text substringFromIndex:tmpFontSet.startLocation];

    }
    
    //初始化新对象
    FontSet  *fontSet = [[FontSet alloc]init];
    UIView *view =  btn.superview;
    
    //初始化fontSet
    for (UIButton *tmp in view.subviews) {
        //赋值状态
        [self initFontSet:fontSet btn:tmp isChangeStatu:NO];
    }
    
    
    fontSet.startLocation = tv_content.text.length;
    
    if (mutableArr.count > 0 || mutableArr.count < 1) {
        
        if (mutableArr.count > 0) {
            FontSet *tmp = (FontSet *)mutableArr.lastObject;
            //判断上一个对象是否有内容，有内容时添加新对象，无修改上一个对象状态
            if (tmp.content.length > 0) {
                //记录修改操作
                [self initFontSet:fontSet btn:btn isChangeStatu:YES];
                [mutableArr addObject:fontSet];
            }else{
                //修改当前的记录状态
                [self initFontSet:tmp btn:btn isChangeStatu:YES];
            }
        }else{
            //记录修改操作
            [self initFontSet:fontSet btn:btn isChangeStatu:YES];
            [mutableArr addObject:fontSet];
        }
        
    }
    
    if (btn.tag == 104) {
        [self.view endEditing:YES];
        [self chooseOpenTheWay];
    }
    
}

- (void)initFontSet:(FontSet *)fontSet btn:(UIButton *)btn isChangeStatu:(BOOL)isChange {
    
    if (isChange) {
        curFontSet = fontSet;
        btn.selected = !btn.selected;
    }
    switch (btn.tag) {
        case 100:
        {
            //加粗
            fontSet.isBold = btn.selected;
            break;
        }case 101:
        {
            //下划线
            fontSet.isUnderline = btn.selected;
            break;
        }case 102:
        {
            //颜色
            if (isChange) {
                if (btn.selected) {
                    NSArray *colorArr = @[@"黑",@"红色",@"绿色"];
                    [self setTextColorOrFontSizeByTitleArr:colorArr btn:btn isTextColor:YES fontSet:fontSet];
                }else{
                    
                    fontSet.color = [UIColor blackColor];
                }
            }else{
                
                //赋值之前的保存信息
                if (btn.selected) {
                    if (mutableArr.count > 0) {
                        FontSet *tmp = (FontSet *)mutableArr.lastObject;
                        fontSet.color = tmp.color;
                    }else{
                        fontSet.color = curFontSet.color;
                    }
                }
            }
            
            break;
        }case 103:
        {
            //字号
//            fontSet.fontSize = 15;
            if (isChange) {
                if (btn.selected) {
                    NSArray *colorArr = @[@"小",@"中",@"大"];
                    [self setTextColorOrFontSizeByTitleArr:colorArr btn:btn isTextColor:NO fontSet:fontSet];
                }else{
                    fontSet.fontSize = 15;
                }
            }else{
                //赋值之前的保存信息
                if (btn.selected) {
                    if (mutableArr.count > 0) {
                        FontSet *tmp = (FontSet *)mutableArr.lastObject;
                        fontSet.fontSize = tmp.fontSize;
                    }else{
                        fontSet.fontSize = curFontSet.fontSize;
                    }
                }
            }
            break;
        }case 104:{
            //图片
//            [self.view endEditing:YES];
//            TakePhoto *takePhoto = [TakePhoto shareTakePhoto];
//            
//            [takePhoto chooseOpenTheWayByView:self];
            
            break;
        }
            
        default:
            break;
    }
    
    
}

- (void)setTextColorOrFontSizeByTitleArr:(NSArray *)titleArr btn:(UIButton *)btn isTextColor:(BOOL)isColor fontSet:(FontSet *)fontSet {
    
    UIView *superView = keyboardView.superview;
    CGRect rect = CGRectMake(btn.frame.origin.x-CGRectGetWidth(btn.frame), superView.frame.origin.y-CGRectGetHeight(btn.frame), CGRectGetWidth(btn.frame)*3, CGRectGetHeight(btn.frame));
    ColorView *colorView = [[ColorView alloc]initColorViewByTitleArr:titleArr rect:rect isColor:isColor resultBlock:^(NSInteger iden) {
        
        if (iden < 1000) {
            switch (iden) {
                case 100:
                {
                    fontSet.color = [UIColor blackColor];
                    break;
                }case 101:
                {
                    fontSet.color = [UIColor redColor];
                    break;
                }case 102:
                {
                    fontSet.color = [UIColor greenColor];
                    break;
                }
                    
                default:
                    break;
            }
        }else{
            switch (iden) {
                case 1000:
                {
                    fontSet.fontSize = 13;
                    break;
                }case 1001:
                {
                    fontSet.fontSize = 15;
                    break;
                }case 1002:
                {
                    fontSet.fontSize = 17;
                    break;
                }
                    
                default:
                    break;
            }
        }
//        __weak weakSelf = colorView;
//        [colorView removeFromSuperview];
    }];
    
    [self.view addSubview:colorView];
    
//    UIView *colorView = [[UIView alloc]init];
//    UIView *superView = keyboardView.superview;
//
//    colorView.frame = CGRectMake(btn.frame.origin.x-CGRectGetWidth(btn.frame), superView.frame.origin.y-CGRectGetHeight(btn.frame), CGRectGetWidth(btn.frame)*3, CGRectGetHeight(btn.frame));
//    colorView.tag = 1111;
//    colorView.backgroundColor = [UIColor purpleColor];
//    
//    [self.view addSubview:colorView];
//    
//    
//    for (int i = 0; i < titleArr.count; i++) {
//        UIButton *colorBtn = [[UIButton alloc]initWithFrame:CGRectMake(i*CGRectGetWidth(btn.frame), 0, CGRectGetWidth(btn.frame), CGRectGetHeight(btn.frame))];
//        colorBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//        [colorBtn setTitle:titleArr[i] forState:UIControlStateNormal];
//        
//        if (isColor) {
//            colorBtn.tag = 100+i;
//        }else{
//            colorBtn.tag = 1000+i;
//        }
//        
//        [colorBtn addTarget:self
//                     action:@selector(chooseColor:)
//           forControlEvents:UIControlEventTouchUpInside];
//        [colorView addSubview:colorBtn];
//        
//        UIImageView *img_line = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(colorBtn.frame), 0, 1, CGRectGetHeight(colorBtn.frame))];
//        img_line.backgroundColor = [UIColor whiteColor];
//        [colorView addSubview:img_line];
//    }
}
/*
#pragma mark -- 选择颜色
- (void)chooseColor:(UIButton *)btn {
    if (btn.tag < 1000) {
        switch (btn.tag) {
            case 100:
            {
                curFontSet.color = [UIColor blackColor];
                break;
            }case 101:
            {
                curFontSet.color = [UIColor redColor];
                break;
            }case 102:
            {
                curFontSet.color = [UIColor greenColor];
                break;
            }
                
            default:
                break;
        }
    }else{
        switch (btn.tag) {
            case 1000:
            {
                curFontSet.fontSize = 13;
                break;
            }case 1001:
            {
                curFontSet.fontSize = 15;
                break;
            }case 1002:
            {
                curFontSet.fontSize = 17;
                break;
            }
                
            default:
                break;
        }
    }
    
    
    UIView *superView = (UIView *)btn.superview;
    [superView removeFromSuperview];
}
*/

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if (mutableArr.count < 1) {
        FontSet *fontSet = [[FontSet alloc]init];
        [mutableArr addObject:fontSet];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    
//    tv_content.attributedText 
    
    return YES;
}


- (void)textViewDidChange:(UITextView *)textView {
    
    
    BOOL isChinese;//判断当前输入法是否是中文
    
    if ([[[textView textInputMode] primaryLanguage]  isEqualToString: @"en-US"]) {
        isChinese = false;
    }
    else
    {
        isChinese = true;
    }
    NSString *str = [[ tv_content text] stringByReplacingOccurrencesOfString:@"?" withString:@""];
    if (isChinese) { //中文输入法下
        UITextRange *selectedRange = [textView markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            NSLog(@"汉字");
            [self updateContentByText:textView.text];
        }else
        {
            NSLog(@"没有转化--%@",str);
        }
    }else{
        NSLog(@"英文");
        [self updateContentByText:textView.text];
    }
    
    //保存每个FontSet的attributeString
    /*
     
     */
    
}

- (void)updateContentByText:(NSString *)text {
    
    NSMutableAttributedString *mutableAttri = [[NSMutableAttributedString alloc]init];
    
    if (mutableArr.count > 0) {
        
        FontSet *fontSet = (FontSet *)mutableArr.lastObject;
        
        if (fontSet.startLocation > text.length) {
            //删除编辑
            [mutableArr removeLastObject];
            fontSet = (FontSet *)mutableArr.lastObject;
        }
        
        if (mutableArr.count == 1 && text.length < 1) {
            [mutableArr removeAllObjects];
            //初始化fontSet
            fontSet = nil;
            fontSet = [[FontSet alloc]init];
            for (UIButton *tmp in keyboardView.subviews) {
                //赋值状态
                [self initFontSet:fontSet btn:tmp isChangeStatu:NO];
            }
            
            [mutableArr addObject:fontSet];
        }
        
        NSString *content = [text substringFromIndex:fontSet.startLocation];
        
        fontSet.content = content;
        NSAttributedString *tmpAttri = [self attributeStringByFontSet:fontSet con:content];
        
        
        if (mutableArr.count > 1) {
            for (int i = 0; i < mutableArr.count-1; i++) {
                FontSet *tmpFontSet = mutableArr[i];
                [mutableAttri appendAttributedString:tmpFontSet.attribute];
            }
        }
        
        fontSet.attribute = tmpAttri;
        [mutableAttri appendAttributedString:tmpAttri];
        tv_content.attributedText = mutableAttri;
    }
}

- (NSMutableAttributedString *)attributeStringByFontSet:(FontSet *)fontSet con:(NSString *)con {
    
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc]initWithString:con];
    
    NSRange range = NSMakeRange(0, con.length);

    if (fontSet.isBold) {
        [attri addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:fontSet.fontSize] range:range];
    }else{
        [attri addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:fontSet.fontSize] range:range];
    }
    
    [attri addAttribute:NSForegroundColorAttributeName value:fontSet.color range:range];
    
    if (fontSet.isUnderline) {
        [attri addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:1] range:range];
        [attri addAttribute:NSUnderlineColorAttributeName value:fontSet.color range:range];
    }
    
    return attri;
}

- (void)chooseOpenTheWay {
    
    UIActionSheet *action = [[UIActionSheet alloc]initWithTitle:@"上传头像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册上传",@"拍照", nil];
    
    [action showInView:self.view];
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
    
//    picker.allowsEditing = YES;
    
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:^{
    }];
    
}

- (void)showNotiInfo
{
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请到设置->隐私->照片->帮帮助学中打开相应权限" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
    
    [alert show];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
//    NSString *path = info[@"UIImagePickerControllerReferenceURL"];
//    UIImage *img = [UIImage imageWithContentsOfFile:path];
//    NSLog(@"%d M",UIImagePNGRepresentation(img).length/1024/1024);
    
//    if (tv_content.text.length > 0) {
//        NSAttributedString * returnStr=[[NSAttributedString alloc]initWithString:@"\n"];
//        NSMutableAttributedString * att=[[NSMutableAttributedString alloc]initWithAttributedString:tv_content.attributedText];
//        [att appendAttributedString:returnStr];
//        
//        tv_content.attributedText=att;
//    }
    
    
    FontSet *fontSet = (FontSet *)[mutableArr lastObject];
    fontSet.isImg = YES;
    UIImage *image = info[@"UIImagePickerControllerOriginalImage"];
//    fontSet.content = [NSString stringWithFormat:@"\n"];
    [fontSet.imgArr addObject:image];
    
    
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithAttributedString:tv_content.attributedText];
    
    NSMutableAttributedString *imgAttributeString;
    
    
    if (tv_content.text.length > 0) {
        tv_content.text = [tv_content.text stringByAppendingString:@"\n"];
        imgAttributeString = [[NSMutableAttributedString alloc]initWithString:@"\n"];
    }else{
        imgAttributeString = [[NSMutableAttributedString alloc]init];
    }
    
    EJTextAttachment *textAttachment = [[EJTextAttachment alloc] initWithData:nil ofType:nil] ;
    
    textAttachment.image = image;
    
    NSAttributedString *textAttachmentString = [NSAttributedString attributedStringWithAttachment:textAttachment] ;
    
    [imgAttributeString appendAttributedString:textAttachmentString];
    fontSet.attribute = imgAttributeString;
    [string insertAttributedString:imgAttributeString atIndex:string.length];//index为用户指定要插入图片的位置
    
    tv_content.attributedText = string;
    
    FontSet  *tmpFontSet = [[FontSet alloc]init];
    
    tmpFontSet.isBold = fontSet.isBold;
    tmpFontSet.isUnderline = fontSet.isUnderline;
    tmpFontSet.fontSize = fontSet.fontSize;
    tmpFontSet.color = fontSet.color;
    tmpFontSet.startLocation = fontSet.startLocation+imgAttributeString.length;
    [mutableArr addObject:tmpFontSet];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
