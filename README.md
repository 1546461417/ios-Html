# ios-Html
用UITextView解析Html点击内容默认选中两个逗号之间的内容，并实现图文混排，自定义调整html 中图片的大小，点击图片可以取出其中的图片


![效果图](https://github.com/1546461417/ios-Html/blob/master/效果图.jpg)

![点击解析出路的图片可以得到对应的图片](https://github.com/1546461417/ios-Html/blob/master/取出链接中的图片.jpg)



//调整图片的大小

 [self.pastView.attributedText enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, self.pastView.attributedText.string.length)
                                         options:0
                                      usingBlock:^(NSTextAttachment *value, NSRange range, BOOL *stop) {

                                          if (value) {
                                           //获取图片的名字
                                               NSLog(@"%@",value.fileWrapper.preferredFilename);
                                              CGSize originSize = value.bounds.size;
                                              CGFloat widthI = Screen_Width - 30;
                                              CGFloat heightI = widthI * originSize.height/originSize.width;
                                              value.bounds = CGRectMake(0, 0, widthI, heightI);
                                          }
                                      }];





//获取html中的图片url
- (NSArray *)filterImage:(NSString *)html

{
    
    NSMutableArray *resultArray = [NSMutableArray array];
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"<(img|IMG)(.*?)(/>|></img>|>)" options:NSRegularExpressionAllowCommentsAndWhitespace error:nil];
    
    NSArray *result = [regex matchesInString:html options:NSMatchingReportCompletion range:NSMakeRange(0, html.length)];
    
    
    
    for (NSTextCheckingResult *item in result) {
        
        NSString *imgHtml = [html substringWithRange:[item rangeAtIndex:0]];
        
        
        
        NSArray *tmpArray = nil;
        
        if ([imgHtml rangeOfString:@"src=\""].location != NSNotFound) {
            
            tmpArray = [imgHtml componentsSeparatedByString:@"src=\""];
            
        } else if ([imgHtml rangeOfString:@"src="].location != NSNotFound) {
            
            tmpArray = [imgHtml componentsSeparatedByString:@"src="];
            
        }
        
        
        
        if (tmpArray.count >= 2) {
            
            NSString *src = tmpArray[1];
            
            
            
            NSUInteger loc = [src rangeOfString:@"\""].location;
            
            if (loc != NSNotFound) {
                
                src = [src substringToIndex:loc];
                
                [resultArray addObject:src];
                
            }
            
        }
        
    }
    
    
    
    return resultArray;
    
}

