//
//  WTFirstPageVC.m
//  解析Html
//
//  Created by admin10 on 2019/8/21.
//  Copyright © 2019年 sgg. All rights reserved.
//

#import "WTFirstPageVC.h"
#import "PasteboardTextView.h"
@interface WTFirstPageVC ()<UITableViewDelegate,UITableViewDataSource,PasteboardTextViewDelegateall>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,copy)NSString *content;
@property (nonatomic,strong)PasteboardTextView *pastView;
@property (nonatomic,strong)UILabel *label;
@end

@implementation WTFirstPageVC
static NSString *Shun = @"shuyanFine";
-(PasteboardTextView *)pastView{
    if (_pastView == nil) {
        _pastView = [[PasteboardTextView alloc]init];
        _pastView.delegates = self;
    }
    return _pastView;
}

-(UILabel *)label{
    if (!_label) {
        _label = [[UILabel alloc]initWithFrame:CGRectMake(100, Screen_Height - SYS_SafeArea_BOTTOM - SYS_NavigationBar_HEIGHT, 100, 100)];
    }
    return _label;
}



-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, SYS_NavigationBar_HEIGHT, Screen_Width, Screen_Height - SYS_SafeArea_BOTTOM - SYS_NavigationBar_HEIGHT ) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 100;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        if (@available(iOS 11.0, *))
        {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            
        }
        else
        {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    NSString *path = [[NSBundle mainBundle]pathForResource:@"list.plist" ofType:nil];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    self.content = dict[@"content"];
    [self.view addSubview:self.tableView];
    
    
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ddd"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ddd"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.numberOfLines = 0;
    NSString *str;
    if (Screen_Width < 322) {
        str = @"<head><style>img{width:218pt !important;height:auto}</style></head>";
    }else{
        if (Screen_Width > 376) {
            str = @"<head><style>img{width:280pt !important;height:auto}</style></head>";
        }else{
            str = @"<head><style>img{width:258pt !important;height:auto}</style></head>";
        }
    }
    if (self.content != nil) {
        cell.textLabel.attributedText = [self attributedStringWithHTMLString:[str stringByAppendingString:self.content]];
        cell.textLabel.hidden = YES;
    }
    [cell.contentView addSubview:self.pastView];
    self.pastView.tintColor = [UIColor orangeColor];
    [self.pastView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(cell.contentView).offset(10);
        make.top.equalTo(cell.contentView);
        make.bottom.equalTo(cell.contentView);
        make.right.equalTo(cell.contentView).offset(- 10);
    }];
    
    if (self.content != nil) {
        self.pastView.attributedText = [self attributedStringWithHTMLString:[str stringByAppendingString:self.content]];
        [self.pastView textViewImageLocation];
    }
    
    return cell;
}


//html 转化为普通文本
- (NSAttributedString *)attributedStringWithHTMLString:(NSString *)htmlString
{
    //    //转换参数
    //    NSDictionary *options = @{ NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute :@(NSUTF8StringEncoding) };
    //将html文本转换为正常格式的文本
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    //以下三个设置其实不是必要的，只是为了让解析出来的html文本更好看。
    //设置段落格式
    NSMutableParagraphStyle *para = [[NSMutableParagraphStyle alloc] init];
    //设置两端对齐
    para.alignment = NSTextAlignmentJustified;
    para.lineSpacing = 10;
    //para.paragraphSpacing = 10;
    [attStr addAttribute:NSParagraphStyleAttributeName value:para range:NSMakeRange(0, attStr.length)];
    //    //颜色
    //    [attStr addAttribute:NSForegroundColorAttributeName
    //                   value:UIColorFromRGB(0x3d3d3d)
    //                   range:NSMakeRange(0, attStr.length)];
    //字体
    [attStr addAttribute:NSFontAttributeName
                   value:[UIFont systemFontOfSize:15]
                   range:NSMakeRange(0, attStr.length)];
   
    return attStr;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
//获得选中的字符串
-(void)getContentSelected:(NSString *)content selectedIndex:(int)selectIndex{
    
    NSLog(@"%@   %d",content ,selectIndex);
  
}


-(void)getContentSelected:(NSTextAttachment *)attach{
    
    [self.view addSubview:self.label];
    
    NSMutableAttributedString *textAttrStr = [[NSMutableAttributedString alloc] init];
   // attach.image = [UIImage imageNamed:@"bankcard_icon"];
    attach.bounds = CGRectMake(0, 0 , 100, 100);
    NSAttributedString *imgStr = [NSAttributedString attributedStringWithAttachment:attach];
    [textAttrStr appendAttributedString:imgStr];
    self.label.attributedText = textAttrStr;

}






- (void)test{
    NSMutableString *plainString = [NSMutableString stringWithString:self.pastView.attributedText.string];
    __block NSUInteger base = 0;
    
    /*
     一些方法的搜索方向
     - NSAttributedStringEnumerationReverse: 逆向搜索
     - NSAttributedStringEnumerationLongestEffectiveRangeNotRequired: 顺向搜索
     */
   
     
    
    
    [self.pastView.attributedText enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, self.pastView.attributedText.string.length)
                                         options:0
                                      usingBlock:^(NSTextAttachment *value, NSRange range, BOOL *stop) {
                                          
                                          
                                          
                                          
                                         
                    
                                          if (value) {
//                                              [plainString replaceCharactersInRange:NSMakeRange(range.location + base, range.length)
//                                                                         withString:content];
//                                              base += content.length - 1;
                                              value.image = [UIImage imageNamed:@"qw"];
                                          }
                                      }];
    
}



@end
