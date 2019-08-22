//
//  PasteboardTextView.m
//  GraspCourse
//
//  Created by admin10 on 2019/3/18.
//  Copyright © 2019年 sun. All rights reserved.
//

#import "PasteboardTextView.h"
@interface PasteboardTextView ()
@property (nonatomic,strong)UIMenuItem *menuItem;
@property (nonatomic,strong)UIMenuItem *menuItem2;
@property (nonatomic,strong)UIMenuController *menu;
@property (nonatomic, strong) UIPasteboard *pasteboard;
@property (nonatomic,strong)NSMutableDictionary *dict;
@end
@implementation PasteboardTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.font = [UIFont systemFontOfSize:15.f];
        self.editable = NO;
        self.scrollEnabled = NO;
        self.menuItem = [[UIMenuItem alloc] initWithTitle:@"分享图文" action:@selector(shareSina:)];
        //self.menuItem2 = [[UIMenuItem alloc] initWithTitle:@"分享文字" action:@selector(shareSinas:)];
        self.menu = [UIMenuController sharedMenuController];
        [self.menu setMenuItems:[NSArray arrayWithObjects:self.menuItem,self.menuItem2,nil]];
        self.pasteboard = [UIPasteboard generalPasteboard];
    }
    return self;
}

-(NSMutableDictionary *)dict{
    if (!_dict) {
        _dict = [NSMutableDictionary dictionary];
    }
    return _dict;
}



//获取图片的位置
- (void)textViewImageLocation{
    [self.attributedText enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, self.attributedText.string.length)
                                    options:0
                                 usingBlock:^(NSTextAttachment *value, NSRange range, BOOL *stop) {
                                     
                                     if (value) {
                                         NSLog(@"%@    %@",value , NSStringFromRange(range));
                                         [self.dict setValue:value forKey:NSStringFromRange(range)];
                                         
                                     }
                                 }];
    
  
}



//选中的文本在图片周围
- (void)lastSet:(NSArray *)array contnt:(NSString *)str{
    NSRange range = [self selectedRange];
    for (int i = 0; i < array.count;  i++) {
        NSString *contnt = array[i];
        NSString *contnt2 = [self getContentduo:array[i]];
        long rel = contnt.length - contnt2.length;
        if ([contnt containsString:str]) {
            NSRange range2 = [self.attributedText.string rangeOfString:[contnt stringByAppendingString:@"。"]];
            if ( range.location - range2.location < contnt.length || range.location - range2.location == contnt.length) {
                range2.location = range2.location + rel+ 1;
                range2.length = range2.length - rel - 1 ;
                self.selectedRange  = range2;
                break;
            }
        }
        
    
    }
    
}

#pragma mark - Overwrite

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event{
    [super touchesBegan:touches withEvent:event];

    
    // 获取当前触摸位置的字符所属的字母(提示：触摸位置需向下调整10个点，以便与文本元素对齐)
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    touchPoint.y -= 10;
    
    // 获取点击的字母的位置
    NSInteger characterIndex = [self.layoutManager characterIndexForPoint:touchPoint inTextContainer:self.textContainer fractionOfDistanceBetweenInsertionPoints:NULL];
    
    // 获取单词的范围。range 由起始位置和长度构成。
    NSRange range = [self getWordRange:characterIndex];
    
    NSLog(@"---%@",NSStringFromRange(range));
    
    NSTextAttachment *value    =     [self.dict valueForKey:NSStringFromRange(range)];
    if (value) {
        if ([self.delegates respondsToSelector:@selector(getContentSelected:)]) {
            [self.delegates getContentSelected:value];
        }
    }
    //[self setBackgroundHighlighted:YES];
}


//获取单词的范围
- (NSRange)getWordRange:(NSInteger)characterIndex {
    NSInteger left = characterIndex - 1;
    NSInteger right = characterIndex + 1;
    NSInteger length = 0;
    NSString *string = self.attributedText.string;
    
    // 往左遍历直到空格
    while (left >=0) {
        NSString *s=[string substringWithRange:NSMakeRange(left, 1)];
        
        if ([self isLetter:s]) {
            left --;
        } else {
            break;
        }
    }
    
    // 往右遍历直到空格
    while (right < self.text.length) {
        NSString *s=[string substringWithRange:NSMakeRange(right, 1)];
        
        if ([self isLetter:s]) {
            right ++;
        } else {
            break;
        }
    }
    
    // 此时 left 和 right 都指向空格
    left ++;
    right --;
    NSLog(@"letf = %ld, right = %ld",left,right);
    
    length = right - left + 1;
    NSRange range = NSMakeRange(left, length);
    
    return range;
}




//判断是否字母
- (BOOL)isLetter:(NSString *)str {
    char letter = [str characterAtIndex:0];
    
    if ((letter >= 'a' && letter <='z') || (letter >= 'A' && letter <= 'Z')) {
        return YES;
    }
    return NO;
}





- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event{
    [super touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    [self setBackgroundHighlighted:NO];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event{
    [super touchesCancelled:touches withEvent:event];
    [self setBackgroundHighlighted:NO];
}

- (void)setBackgroundHighlighted:(BOOL)highlighted{
    [UIView animateWithDuration:0.3f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        if (!highlighted) {
           [self setBackgroundColor:[UIColor clearColor]];
        }
        
    } completion:^(BOOL finished) {
        
    }];
}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    NSRange range = [self selectedRange];
    NSString *str = nil;
    str = [self.attributedText.string substringWithRange:range];
    NSString *show = [self getContentduo:str];
    if (show.length < 5) {
        if ([str containsString:@"。"]) {
            NSArray *arrays = [str componentsSeparatedByString:@"。"];
            str = arrays[0];
        }
        NSArray *array = [self.attributedText.string componentsSeparatedByString:@"。"];
        int index = 0;
        for (int i = 0; i < array.count;  i++) {
            NSString *contnt = [self getContentduo:array[i]];
            if ([contnt containsString:str]) {
                index = i;
                // NSLog(@"%@",array[i]);
                NSRange range2 = [self.attributedText.string rangeOfString:[contnt stringByAppendingString:@"。"]];
                if ( range.location - range2.location < contnt.length || range.location - range2.location == contnt.length) {
                    self.selectedRange  = range2;
                    break;
                }
            }
            //由于存在图片，靠近图片选择的时候会出现不能准确判断位置的问题
            if (i == array.count - 1) {
                [self lastSet:array contnt:str];
            }
            
        }
    }
    //屏蔽了除复制以外的功能
    if (action == @selector(copy:)||action == @selector(shareSinas:)||action == @selector(shareSina:)) {
        return YES;
    }else{
        
        return NO;
    }
    
}

- (NSString *)getContentduo:(NSString *)countString{
    
    countString = [countString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除首位空格
    
    countString = [countString stringByReplacingOccurrencesOfString:@" "withString:@""];  //去除中间空格
    
    countString = [countString stringByReplacingOccurrencesOfString:@"\n" withString:@""];  //去除换行符
    return countString;
}
- (void)copy:(id)sender {
    NSRange range = [self selectedRange];
    NSString *str = [self.attributedText.string substringWithRange:range];
    self.pasteboard.string = [self getContentduo:str];
   // [LCProgressHUD showMessage:@"内容已经复制"];
    //[self gecontentDeta:0];
    [self endEditing:YES];
}
- (void)shareSina:(id)sender {
    NSRange range = [self selectedRange];
    NSString *str = [self.attributedText.string substringWithRange:range];
    self.pasteboard.string = [self getContentduo:str];
    
    [self gecontentDeta:1];
}

//分享文字
- (void)shareSinas:(id)sender {
    NSRange range = [self selectedRange];
    NSString *str = [self.attributedText.string substringWithRange:range];
    if ([self.delegates respondsToSelector:@selector(getContentSelected:selectedIndex:)]) {
        [self.delegates getContentSelected:str selectedIndex:2];
    }
}

- (void)gecontentDeta:(int)index{
    NSRange range = [self selectedRange];
    NSString *str = [self.text substringWithRange:range];
    //NSLog(@"%@",str);
    if ([self.delegates respondsToSelector:@selector(getContentSelected:selectedIndex:)]) {
        [self.delegates getContentSelected:str selectedIndex:index];
    }
}




@end
