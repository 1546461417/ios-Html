# ios-Html
用UITextView解析Html点击内容默认选中两个逗号之间的内容，并实现图文混排，自定义调整html 中图片的大小，点击图片可以取出其中的图片


![效果图](https://github.com/1546461417/ios-Html/blob/master/效果图.jpg)

![点击解析出路的图片可以得到对应的图片](https://github.com/1546461417/ios-Html/blob/master/取出链接中的图片.jpg)


//调整图片的大小
- (void)changeImageSize{
    [self.pastView.attributedText enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, self.pastView.attributedText.string.length)
                                         options:0
                                      usingBlock:^(NSTextAttachment *value, NSRange range, BOOL *stop) {

                                          if (value) {
                                              CGSize originSize = value.bounds.size;
                                              CGFloat widthI = Screen_Width - 30;
                                              CGFloat heightI = widthI * originSize.height/originSize.width;
                                              value.bounds = CGRectMake(0, 0, widthI, heightI);
                                          }
                                      }];

}





